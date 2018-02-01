using JG_Prospect.Common.modal;
using JG_Prospect.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.BLL
{
    public class ChatBLL
    {
        private static ChatBLL m_ChatBLL = new ChatBLL();

        public static ChatBLL Instance
        {
            get { return m_ChatBLL; }
            private set {; }
        }

        public void AddChatUser(int UserID, string ConnectionId)
        {
            ChatDAL.Instance.AddChatUser(UserID, ConnectionId);
        }

        public ActionOutput<ChatUser> GetChatUsers()
        {
            return ChatDAL.Instance.GetChatUsers();
        }

        public ActionOutput<ChatUser> GetChatUsers(List<int> userIds)
        {
            return ChatDAL.Instance.GetChatUsers(userIds);
        }

        public ActionOutput<ChatUser> GetChatUser(int UserId)
        {
            return ChatDAL.Instance.GetChatUser(UserId);
        }

        public ActionOutput<ChatUser> GetChatUser(string ConnectionId)
        {
            return ChatDAL.Instance.GetChatUser(ConnectionId);
        }

        public ActionOutput<ActiveUser> GetOnlineUsers(int LoggedInUserId)
        {
            return ChatDAL.Instance.GetOnlineUsers(LoggedInUserId);
        }

        public ActionOutput SetChatMessageRead(int ChatMessageId, int ReceiverId)
        {
            return ChatDAL.Instance.SetChatMessageRead(ChatMessageId, ReceiverId);
        }

        public ActionOutput SetChatMessageRead(string ChatGroupId, int ReceiverId)
        {
            return ChatDAL.Instance.SetChatMessageRead(ChatGroupId, ReceiverId);
        }

        public int GetChatUserCount()
        {
            return ChatDAL.Instance.GetChatUserCount();
        }

        public void DeleteChatUser(string ConnectionId)
        {
            ChatDAL.Instance.DeleteChatUser(ConnectionId);
        }

        public void SaveChatMessage(ChatMessage message, string ChatGroupId, string ReceiverIds)
        {
            ChatDAL.Instance.SaveChatMessage(message, ChatGroupId, ReceiverIds);
        }


        public void ChatLogger(string chatGroupId, string message, int chatSourceId, int UserId, string IP)
        {
            ChatDAL.Instance.ChatLogger(chatGroupId, message, chatSourceId, UserId, IP);
        }
    }
}
