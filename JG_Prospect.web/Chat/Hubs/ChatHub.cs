using JG_Prospect.BLL;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using Microsoft.AspNet.SignalR;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace JG_Prospect.Chat.Hubs
{
    //[HubName("chatHub")]
    // [Authorize]
    public class ChatHub : Hub
    {
        #region---Data Members---
        static List<UserDetail> ConnectedUsers = new List<UserDetail>();
        static List<MessageDetail> CurrentMessage = new List<MessageDetail>();
        #endregion

        public void SendChatMessage(string chatGroupId, string message, int chatSourceId)
        {
            // Getting Website's base URL
            string baseUrl = System.Web.HttpContext.Current.Request.Url.Scheme + "://" + System.Web.HttpContext.Current.Request.Url.Authority + System.Web.HttpContext.Current.Request.ApplicationPath.TrimEnd('/') + "/";
            // Getting Logged In UserID from cookie. 
            // FYI: Sessions are not allowed in SignalR, so have to user some other way to pass information
            int UserId = App_Code.CommonFunction.GetUserIdCookie();
            DataRow sender = InstallUserBLL.Instance.getuserdetails(UserId).Tables[0].Rows[0];
            string pic = string.IsNullOrEmpty(sender["Picture"].ToString()) ? "default.jpg"
                                : sender["Picture"].ToString().Replace("~/UploadeProfile/", "");
            pic = baseUrl + "UploadeProfile/" + pic;
            // Instatiate ChatMessage
            ChatMessage chatMessage = new ChatMessage
            {
                Message = message,
                ChatSourceId = chatSourceId,
                UserId = UserId,
                UserProfilePic = pic,
                UserFullname = sender["FristName"].ToString() + " " + sender["Lastname"].ToString(),
                UserInstallId = sender["UserInstallID"].ToString(),
                MessageAt = DateTime.UtcNow.ToEST(),
                MessageAtFormatted = DateTime.UtcNow.ToEST().ToString()
            };
            // Finding correct chat group in which message suppose to be posted.
            ChatGroup chatGroup = SingletonUserChatGroups.Instance.ChatGroups.Where(m => m.ChatGroupId == chatGroupId).FirstOrDefault();
            // Adding chat message into chatGroup
            // Remove old Messages from list and newly one.
            chatGroup.ChatMessages.RemoveRange(0, chatGroup.ChatMessages.Count()); // May require to comment in future.
            chatGroup.ChatMessages.Add(chatMessage);

            // Checking in database to fetch all connectionIds of browser of this chat group
            // FYI: Everytime, we reload a web page, SignalR brower connectionId gets changed, So
            // we have to always look database for correct connectionIds
            var newConnections = ChatBLL.Instance.GetChatUsers(chatGroup.ChatUsers.Select(m => m.UserId).ToList()).Results;
            List<int> onlineUserIds = newConnections.Select(m => m.UserId).ToList();
            // Modify existing connectionIds into particular ChatGroup and save into static "UserChatGroups" object
            foreach (var user in chatGroup.ChatUsers.Where(m => onlineUserIds.Contains(m.UserId)))
            {
                user.ConnectionIds = newConnections.Where(m => m.UserId == user.UserId).Select(m => m.ConnectionIds).FirstOrDefault();
                user.OnlineAt = newConnections.Where(m => m.UserId == user.UserId).OrderByDescending(m => m.OnlineAt).Select(m => m.OnlineAt).FirstOrDefault();
                user.OnlineAtFormatted = newConnections.Where(m => m.UserId == user.UserId).OrderByDescending(m => m.OnlineAt).Select(m => m.OnlineAt.Value).FirstOrDefault().ToEST().ToString();
            }

            //chatGroup.ChatUsers.ForEach(x => x.ConnectionIds = newConnections.Where(m => m.UserId == x.UserId).Select(m => m.ConnectionIds).FirstOrDefault());
            //chatGroup.ChatUsers.ForEach(x => x.OnlineAt = newConnections.Where(m => m.UserId == x.UserId).OrderByDescending(m => m.OnlineAt).Select(m => m.OnlineAt).FirstOrDefault());
            //chatGroup.ChatUsers.ForEach(x => x.OnlineAtFormatted = newConnections.Where(m => m.UserId == x.UserId).OrderByDescending(m => m.OnlineAt).Select(m => m.OnlineAt.Value).FirstOrDefault().ToEST().ToString());

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
            }

            // Saving chat into database
            string ReceiverId = string.Join(",", chatGroup.ChatUsers.Where(m => m.UserId != UserId).Select(m => m.UserId).ToList());
            ChatBLL.Instance.SaveChatMessage(chatMessage, chatGroupId, ReceiverId);

            //ActionOutput<ChatUser> user = ChatBLL.Instance.GetChatUser(UserId);
            Clients.Group(chatGroupId).updateClient(new ActionOutput<ChatMessage>
            {
                Status = ActionStatus.Successfull,
                Object = chatMessage,
                Message = chatGroupId + "`" + chatGroup.ChatGroupName
            });

            //Clients.All.hello();
            // Call the addNewMessageToPage method to update clients.
            //Clients.Client(user.Object.ConnectionId).updateClient(new ActionOutput<ChatMessage>
            //{
            //    Status = ActionStatus.Successfull,
            //    Object = chatMessage
            //});
        }

        public void CloseChat(string chatGroupId)
        {
            int UserId = App_Code.CommonFunction.GetUserIdCookie();
            // Finding correct chat group in which message suppose to be posted.
            ChatGroup chatGroup = SingletonUserChatGroups.Instance.ChatGroups.Where(m => m.ChatGroupId == chatGroupId).FirstOrDefault();
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
                Message= chatGroupId
            });
        }

        public override System.Threading.Tasks.Task OnConnected()
        {
            int UserId = App_Code.CommonFunction.GetUserIdCookie();
            //string username = Context.QueryString["username"].ToString();
            string clientId = Context.ConnectionId;
            ChatBLL.Instance.AddChatUser(UserId, clientId);
            string data = clientId;
            string count = "";
            try
            {
                count = GetCount().ToString();
            }
            catch (Exception d)
            {
                count = d.Message;
            }
            DataSet ds = InstallUserBLL.Instance.getuserdetails(UserId);
            Clients.Caller.receiveMessage(new ActionOutput
            {
                Status = ActionStatus.Successfull,
                Message = ds.Tables[0].Rows[0]["FristName"] + " " + ds.Tables[0].Rows[0]["Lastname"] + " is connected..."
            });
            return base.OnConnected();
        }

        public override System.Threading.Tasks.Task OnReconnected()
        {
            return base.OnReconnected();
        }

        public override System.Threading.Tasks.Task OnDisconnected(bool stopCalled)
        {
            string count = "";
            string msg = "";

            string clientId = Context.ConnectionId;
            ChatBLL.Instance.DeleteChatUser(clientId);

            try
            {
                count = GetCount().ToString();
            }
            catch (Exception d)
            {
                msg = "DB Error " + d.Message;
            }
            string[] Exceptional = new string[1];
            Exceptional[0] = clientId;
            Clients.AllExcept(Exceptional).receiveMessage("NewConnection", clientId + " leave", count);

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