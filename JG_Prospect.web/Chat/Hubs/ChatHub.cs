﻿using Humanizer;
using JG_Prospect.BLL;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using Microsoft.AspNet.SignalR;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Hosting;

namespace JG_Prospect.Chat.Hubs
{
    //[HubName("chatHub")]
    // [Authorize]
    public class ChatHub : Hub
    {
        public void SendChatMessage(string chatGroupId, string message, int chatSourceId, string receiverIds, int? fileId = null,
                                        int? taskId = null, int? taskMultilevelListId = null)
        {
            try
            {
                if (string.IsNullOrEmpty(receiverIds))
                {
                    ErrorLogBLL.Instance.SaveApplicationError("ChatHub", "ReceiverIds cannot be empty or null", "ReceiverIds cannot be empty or null", "");
                    Clients.Group(chatGroupId).sendChatMessageCallbackError(new ActionOutput<string>
                    {
                        Status = ActionStatus.Successfull,
                        Object = "ReceiverIds cannot be empty or null",
                        Message = chatGroupId
                    });
                }

                System.Web.HttpContextBase httpContext = Context.Request.GetHttpContext();
                string baseurl = httpContext.Request.Url.Scheme + "://" +
                                    httpContext.Request.Url.Authority +
                                    httpContext.Request.ApplicationPath.TrimEnd('/') + "/";
                // Getting Logged In UserID from cookie. 
                // FYI: Sessions are not allowed in SignalR, so have to user some other way to pass information
                int SenderUserId = 0;
                HttpCookie auth_cookie = httpContext.Request.Cookies[Cookies.UserId];
                if (auth_cookie != null)
                    SenderUserId = Convert.ToInt32(auth_cookie.Value);

                // Check for file attachment
                if (fileId.HasValue && fileId.Value > 0)
                {
                    ChatFile file = ChatBLL.Instance.GetChatFile(fileId.Value);
                    message = file.DisplayName + ":-:" + file.SavedName;
                }
                //add logger
                //ChatBLL.Instance.ChatLogger(chatGroupId, message, chatSourceId, SenderUserId, httpContext.Request.UserHostAddress);
                DataRow sender = InstallUserBLL.Instance.getuserdetails(SenderUserId).Tables[0].Rows[0];
                string pic = string.IsNullOrEmpty(sender["Picture"].ToString()) ? "default.jpg"
                                    : sender["Picture"].ToString().Replace("~/UploadeProfile/", "");
                pic = /*baseUrl +*/ "Employee/ProfilePictures/" + pic;
                // Instatiate ChatMessage
                ChatMessage chatMessage = new ChatMessage
                {
                    TaskId = taskId,
                    TaskMultilevelListId = taskMultilevelListId,
                    Message = message,
                    FileId = fileId,
                    ChatSourceId = chatSourceId,
                    UserId = SenderUserId,
                    UserProfilePic = pic,
                    UserFullname = sender["FristName"].ToString() + " " + sender["Lastname"].ToString(),
                    UserInstallId = sender["UserInstallID"].ToString(),
                    MessageAt = DateTime.UtcNow.ToEST(),
                    MessageAtFormatted = DateTime.UtcNow.ToEST().ToString()
                };

                // Finding correct chat group in which message suppose to be posted.
                ChatGroup chatGroup = SingletonUserChatGroups.Instance.ChatGroups.Where(m => m.ChatGroupId == chatGroupId).FirstOrDefault();
                if (chatGroup != null && chatGroup.ChatMessages == null)
                    chatGroup.ChatMessages = new List<ChatMessage>();
                // Adding chat message into chatGroup
                // Remove old Messages from list and newly one.
                chatGroup.ChatMessages.RemoveRange(0, chatGroup.ChatMessages.Count()); // May require to comment in future.
                chatGroup.ChatMessages.Add(chatMessage);

                // Checking in database to fetch all connectionIds of browser of this chat group
                // FYI: Everytime, we reload a web page, SignalR brower connectionId gets changed, So
                // we have to always look database for correct connectionIds
                var newConnections = ChatBLL.Instance.GetChatUsers(chatGroup.ChatUsers.Select(m => m.UserId.Value).ToList()).Results;
                List<int> onlineUserIds = newConnections.Select(m => m.UserId.Value).ToList();
                // Modify existing connectionIds into particular ChatGroup and save into static "UserChatGroups" object
                foreach (var user in chatGroup.ChatUsers.Where(m => onlineUserIds.Contains(m.UserId.Value)))
                {
                    if (newConnections.Where(m => m.UserId == user.UserId).Any())
                    {
                        user.ConnectionIds = newConnections.Where(m => m.UserId == user.UserId).Select(m => m.ConnectionIds).FirstOrDefault();
                        user.OnlineAt = newConnections.Where(m => m.UserId == user.UserId).OrderByDescending(m => m.OnlineAt).Select(m => m.OnlineAt).FirstOrDefault();
                        user.OnlineAtFormatted = user.OnlineAt.HasValue ? user.OnlineAt.Value.ToEST().ToString() : null;
                    }
                }
                // Chat status to active of sender
                if (SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == SenderUserId).Any())
                {
                    SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == SenderUserId)
                                                    .First().Status = (int)ChatUserStatus.Active;
                    SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == SenderUserId)
                                                   .First().LastActivityAt = DateTime.UtcNow;
                }

                // Adding each connection into SignalR Group, so that we can send messages to all connected users.
                foreach (var item in chatGroup.ChatUsers.Where(m => m.OnlineAt.HasValue))
                {
                    foreach (string connectionId in item.ConnectionIds)
                    {
                        Groups.Add(connectionId, chatGroupId);
                    }
                }
                // Send Email notification to all offline users
                foreach (var item in chatGroup.ChatUsers.Where(m => !m.OnlineAt.HasValue))
                {
                    // Send Chat Notification Email
                    ChatBLL.Instance.SendOfflineChatEmail(SenderUserId, item.UserId.Value, sender["UserInstallID"].ToString(),
                                                            chatMessage.Message, chatSourceId, baseurl, chatGroupId);
                }

                // Saving chat into database
                //string ReceiverId = string.Join(",", chatGroup.ChatUsers.Where(m => m.UserId != UserId).Select(m => m.UserId).ToList());
                //string ReceiverId = receiverIds;
                // merge logged in user id into ReceiverIds
                receiverIds += "," + SenderUserId;
                ChatBLL.Instance.SaveChatMessage(chatMessage, chatGroupId, receiverIds, SenderUserId);

                taskId = taskId.HasValue ? taskId.Value : 0;
                taskMultilevelListId = taskMultilevelListId.HasValue ? taskMultilevelListId.Value : 0;

                Clients.Group(chatGroupId).updateClient(new ActionOutput<ChatMessage>
                {
                    Status = ActionStatus.Successfull,
                    Object = chatMessage,
                    Message = chatGroupId + "`" + chatGroup.ChatGroupName + "`" + receiverIds + "`" + SenderUserId + "`" + taskId + "`" + taskMultilevelListId
                });
            }
            catch (Exception ex)
            {
                ErrorLogBLL.Instance.SaveApplicationError("ChatHub", ex.Message, ex.ToString(), "");
                Clients.Group(chatGroupId).sendChatMessageCallbackError(new ActionOutput<string>
                {
                    Status = ActionStatus.Successfull,
                    Object = ex.ToString(),
                    Message = chatGroupId
                });
            }
        }

        public void addUserIntoChatGroup(string chatGroupId, int userId)
        {
            var receiver = ChatBLL.Instance.GetChatUser(userId).Object;
            string newChatGroupName = string.Empty;
            if (!SingletonUserChatGroups.Instance.ChatGroups
                                                 .Where(m => m.ChatGroupId == chatGroupId)
                                                 .FirstOrDefault()
                                                 .ChatUsers.Where(m => m.UserId == userId)
                                                 .Any())
            {
                // Add user into chat group
                SingletonUserChatGroups.Instance.ChatGroups
                                                 .Where(m => m.ChatGroupId == chatGroupId)
                                                 .FirstOrDefault()
                                                 .ChatUsers
                                                 .Add(receiver);
                // update chatgroup name
                SingletonUserChatGroups.Instance.ChatGroups
                                                 .Where(m => m.ChatGroupId == chatGroupId)
                                                 .FirstOrDefault()
                                                 .ChatGroupName += ", " + receiver.GroupOrUsername +
                                                 ":<a target=\"_blank\" href=\"/Sr_App/ViewSalesUser.aspx?id=" + receiver.UserId + "\">" + receiver.UserInstallId + "</a>";

                newChatGroupName = SingletonUserChatGroups.Instance.ChatGroups
                                                 .Where(m => m.ChatGroupId == chatGroupId)
                                                 .FirstOrDefault()
                                                 .ChatGroupName;


                #region Update ConnectionId
                ChatGroup chatGroup = SingletonUserChatGroups.Instance.ChatGroups.Where(m => m.ChatGroupId == chatGroupId).FirstOrDefault();
                // Checking in database to fetch all connectionIds of browser of this chat group
                // FYI: Everytime, we reload a web page, SignalR brower connectionId gets changed, So
                // we have to always look database for correct connectionIds
                var newConnections = ChatBLL.Instance.GetChatUsers(chatGroup.ChatUsers.Select(m => m.UserId.Value).ToList()).Results;
                List<int> onlineUserIds = newConnections.Select(m => m.UserId.Value).ToList();
                // Modify existing connectionIds into particular ChatGroup and save into static "UserChatGroups" object
                foreach (var user in chatGroup.ChatUsers.Where(m => onlineUserIds.Contains(m.UserId.Value)))
                {
                    if (newConnections.Where(m => m.UserId == user.UserId).Any())
                    {
                        user.ConnectionIds = newConnections.Where(m => m.UserId == user.UserId).Select(m => m.ConnectionIds).FirstOrDefault();
                        user.OnlineAt = newConnections.Where(m => m.UserId == user.UserId).OrderByDescending(m => m.OnlineAt).Select(m => m.OnlineAt).FirstOrDefault();
                        user.OnlineAtFormatted = user.OnlineAt.HasValue ? user.OnlineAt.Value.ToEST().ToString() : null;
                    }
                }
                // Adding each connection into SignalR Group, so that we can send messages to all connected users.
                foreach (var item in chatGroup.ChatUsers.Where(m => m.OnlineAt.HasValue))
                {
                    foreach (string connectionId in item.ConnectionIds)
                    {
                        Groups.Add(connectionId, chatGroupId);
                    }
                }
                #endregion
            }
            Clients.Group(chatGroupId).addUserIntoChatGroupCallback(new ActionOutput<string>
            {
                Status = ActionStatus.Successfull,
                Object = chatGroupId + "`" + newChatGroupName + "`" + userId,
                Message = receiver.GroupOrUsername + " was added to chat"
            });
        }

        public void CloseChat(string chatGroupId)
        {
            System.Web.HttpContextBase httpContext = Context.Request.GetHttpContext();
            int UserId = 0;
            HttpCookie auth_cookie = httpContext.Request.Cookies[Cookies.UserId];
            if (auth_cookie != null)
                UserId = Convert.ToInt32(auth_cookie.Value);
            // Finding correct chat group in which message suppose to be posted.
            ChatGroup chatGroup = SingletonUserChatGroups.Instance.ChatGroups.Where(m => m.ChatGroupId == chatGroupId).FirstOrDefault();
            if (chatGroup != null)
            {
                chatGroup.ChatUsers.Where(m => m.UserId == UserId).FirstOrDefault().ChatClosed = true;
                if (chatGroup.ChatUsers.Where(m => m.ChatClosed).Count() == chatGroup.ChatUsers.Count())
                {
                    // Remove group from list because all users has closed the chat.
                    SingletonUserChatGroups.Instance.ChatGroups.Remove(chatGroup);
                    Clients.Group(chatGroupId).closeChatCallback(new ActionOutput<bool>
                    {
                        Status = ActionStatus.Successfull,
                        Object = true
                    });
                }
                Clients.Group(chatGroupId).closeChatCallback(new ActionOutput<bool>
                {
                    Status = ActionStatus.Successfull,
                    Object = false,
                    Message = chatGroupId
                });
            }
        }

        public override System.Threading.Tasks.Task OnConnected()
        {
            int status = (int)ChatUserStatus.Idle;
            System.Web.HttpContextBase httpContext = Context.Request.GetHttpContext();
            int UserId = 0;
            HttpCookie auth_cookie = httpContext.Request.Cookies[Cookies.UserId];
            if (auth_cookie != null)
                UserId = Convert.ToInt32(auth_cookie.Value);

            ChatBLL.Instance.AddChatUser(UserId, Context.ConnectionId);

            ChatUser user = ChatBLL.Instance.GetChatUser(UserId).Object;

            if (user == null)
                return base.OnConnected();

            // Update ActiveUsers in SingletonUserChatGroups
            var users = ChatBLL.Instance.GetOnlineUsers(UserId).Results;
            var oldOnlineUers = SingletonUserChatGroups.Instance.ActiveUsers;
            SingletonUserChatGroups.Instance.ActiveUsers = users;
            if (oldOnlineUers != null && SingletonUserChatGroups.Instance.ActiveUsers != null && SingletonUserChatGroups.Instance.ActiveUsers.Count() > 0)
                foreach (var item in oldOnlineUers)
                {
                    if (SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == item.UserId)
                                                    .FirstOrDefault() != null)
                    {
                        SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == item.UserId)
                                                        .FirstOrDefault().Status = item.Status;
                        SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == item.UserId)
                                                       .First().LastActivityAt = item.LastActivityAt;
                    }
                }
            if (SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == UserId).Any())
            {
                SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == UserId)
                                                .First().Status = (int)ChatUserStatus.Active;
                status = (int)ChatUserStatus.Active;
                SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == UserId)
                                               .First().LastActivityAt = DateTime.UtcNow;
            }
            if (ChatProcessor.Instance == null)
            {
                // Do nothing
                // It was called to instantiate the ChatProcessor 
            }

            //ChatMessageActiveUser obj = new ChatMessageActiveUser();
            //obj.ActiveUsers = SingletonUserChatGroups.Instance.ActiveUsers.OrderByDescending(m => m.LastMessageAt).ToList();

            Clients.All.onConnectedCallback(new ActionOutput<int>
            {
                Status = ActionStatus.Successfull,
                Message = UserId + " User is connected...",
                Object = status
            });
            return base.OnConnected();
        }

        public override System.Threading.Tasks.Task OnReconnected()
        {
            return base.OnReconnected();
        }

        public override System.Threading.Tasks.Task OnDisconnected(bool stopCalled)
        {
            System.Web.HttpContextBase httpContext = Context.Request.GetHttpContext();
            string clientId = Context.ConnectionId;
            ChatUser user = ChatBLL.Instance.GetChatUser(clientId).Object;
            ChatBLL.Instance.DeleteChatUser(clientId);

            if (!(user != null && user.UserId.HasValue))
                return base.OnDisconnected(stopCalled);

            SingletonGlobal.Instance.ConnectedClients.Remove(Context.ConnectionId);
            string[] Exceptional = new string[1];
            Exceptional[0] = clientId;

            // User is offline            
            // Update ActiveUsers in SingletonUserChatGroups
            var users = ChatBLL.Instance.GetOnlineUsers(user.UserId.Value).Results;
            var oldOnlineUers = SingletonUserChatGroups.Instance.ActiveUsers;
            SingletonUserChatGroups.Instance.ActiveUsers = users;
            if (oldOnlineUers != null && SingletonUserChatGroups.Instance.ActiveUsers != null && SingletonUserChatGroups.Instance.ActiveUsers.Count() > 0)
                foreach (var item in oldOnlineUers)
                {
                    if (SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == item.UserId)
                                                    .FirstOrDefault() != null)
                        SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == item.UserId)
                                                        .FirstOrDefault().Status = item.Status;
                }

            //ChatMessageActiveUser obj = new ChatMessageActiveUser();
            //obj.ActiveUsers = SingletonUserChatGroups.Instance.ActiveUsers.OrderBy(m => m.Status).ToList();

            Clients.AllExcept(Exceptional).onDisconnectedCallback(new ActionOutput
            {
                Status = ActionStatus.Successfull
            });

            return base.OnDisconnected(stopCalled);
        }

        public int GetCount()
        {
            return ChatBLL.Instance.GetChatUserCount();
        }

        public ActionOutput<ChatUser> GetChatUsers()
        {
            return ChatBLL.Instance.GetChatUsers();
        }

        public void getOnlineChatUsers()
        {
            System.Web.HttpContextBase httpContext = Context.Request.GetHttpContext();
            int UserId = 0;
            HttpCookie auth_cookie = httpContext.Request.Cookies[Cookies.UserId];
            if (auth_cookie != null)
                UserId = Convert.ToInt32(auth_cookie.Value);

            //string baseUrl = httpContext.Request.Url.Scheme + "://" +
            //                    httpContext.Request.Url.Authority +
            //                    httpContext.Request.ApplicationPath.TrimEnd('/') + "/";
            string existingUsers = UserId.ToString();
            List<ChatMentionUser> users = new List<ChatMentionUser>();
            ActionOutput<ChatUser> op = ChatBLL.Instance.GetChatUsers();
            if (op != null && op.Status == ActionStatus.Successfull)
            {
                users = op.Results.Select(m => new ChatMentionUser
                {
                    id = m.UserId.Value,
                    name = m.GroupOrUsername,
                    type = "contact",
                    avatar = "Employee/ProfilePictures/" + (string.IsNullOrEmpty(m.ProfilePic) ? "default.jpg"
                                : m.ProfilePic.Replace("~/UploadeProfile/", ""))
                }).ToList();
                // Remove logged in user
                users.RemoveAll(m => m.id == UserId);
            }
            Clients.All.getOnlineChatUsersCallback(new ActionOutput<ChatMentionUser>
            {
                Status = ActionStatus.Successfull,
                Results = users
            });
        }

        public void SetChatUserStatusToIdle(int status)
        {
            System.Web.HttpContextBase httpContext = Context.Request.GetHttpContext();
            int UserId = 0;
            HttpCookie auth_cookie = httpContext.Request.Cookies[Cookies.UserId];
            if (auth_cookie != null)
                UserId = Convert.ToInt32(auth_cookie.Value);
            if (SingletonUserChatGroups.Instance.ActiveUsers
                                            .Where(m => m.UserId == UserId)
                                            .Any())
            {
                SingletonUserChatGroups.Instance.ActiveUsers
                                                .Where(m => m.UserId == UserId)
                                                .FirstOrDefault()
                                                .Status = status;
                if (status == (int)ChatUserStatus.Active)
                {
                    SingletonUserChatGroups.Instance.ActiveUsers
                                                    .Where(m => m.UserId == UserId)
                                                    .FirstOrDefault()
                                                    .LastActivityAt = DateTime.UtcNow;
                }
                SingletonUserChatGroups.Instance.ActiveUsers
                                                .Where(m => m.UserId == UserId)
                                                .FirstOrDefault()
                                                .Status = status;
            }

            ChatMessageActiveUser obj = new ChatMessageActiveUser();
            obj.ActiveUsers = SingletonUserChatGroups.Instance.ActiveUsers.OrderByDescending(m => m.LastMessageAt).ToList();

            Clients.All.SetChatUserStatusToIdleCallback(new ActionOutput<ChatMessageActiveUser>
            {
                Status = ActionStatus.Successfull,
                Object = obj
            });
        }

        public void SetChatMessageRead(string ChatGroupId)
        {
            System.Web.HttpContextBase httpContext = Context.Request.GetHttpContext();
            int UserId = 0;
            HttpCookie auth_cookie = httpContext.Request.Cookies[Cookies.UserId];
            if (auth_cookie != null)
                UserId = Convert.ToInt32(auth_cookie.Value);
            ChatBLL.Instance.SetChatMessageRead(ChatGroupId, UserId);
            List<int> userIds = new List<int>();
            if (SingletonUserChatGroups.Instance.ChatGroups.Where(m => m.ChatGroupId == ChatGroupId).Any())
            {
                userIds = SingletonUserChatGroups.Instance.ChatGroups
                                                            .Where(m => m.ChatGroupId == ChatGroupId)
                                                            .FirstOrDefault()
                                                            .ChatUsers
                                                            //.Where(m => m.UserId.Value != UserId)
                                                            .Select(m => m.UserId.Value)
                                                            .ToList();
            }
            Clients.Group(ChatGroupId).SetChatMessageReadCallback(new ActionOutput<string>
            {
                Status = ActionStatus.Successfull,
                Object = ChatGroupId,
                Message = string.Join(",", userIds)
            });
        }
    }

    internal class UserDetail
    {
        public string ConnectionId { get; set; }
        public string UserID { get; set; }
        public string UserName { get; set; }
    }

    internal class MessageDetail
    {
        public int FromUserID { get; set; }
        public string FromUserName { get; set; }
        public int ToUserID { get; set; }
        public string ToUserName { get; set; }
        public string Message { get; set; }
    }


}