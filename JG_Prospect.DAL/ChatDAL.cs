using JG_Prospect.Common.modal;
using JG_Prospect.DAL.Database;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JG_Prospect.Common;

namespace JG_Prospect.DAL
{
    public class ChatDAL
    {
        public static ChatDAL m_ChatDAL = new ChatDAL();

        public static ChatDAL Instance
        {
            get { return m_ChatDAL; }
            private set {; }
        }
        public DataSet returndata;

        public void AddChatUser(int UserID, string ConnectionId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("AddChatUser");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserId", DbType.Int32, UserID);
                    database.AddInParameter(command, "@ConnectionId", DbType.String, ConnectionId);
                    database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            { Console.Write(ex.Message); }
        }

        public ActionOutput<ChatUser> GetChatUsers()
        {
            try
            {
                List<ChatUser> users = new List<ChatUser>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatUsers");

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            int userId = Convert.ToInt32(item["UserId"].ToString());
                            ChatUser user = new ChatUser
                            {
                                UserId = userId,
                                //ConnectionId = item["ConnectionId"].ToString(),
                                FirstName = item["FirstName"].ToString(),
                                LastName = item["LastName"].ToString(),
                                Email = item["Email"].ToString(),
                                OnlineAt = Convert.ToDateTime(item["OnlineAt"].ToString()),
                                OnlineAtFormatted = Convert.ToDateTime(item["OnlineAt"].ToString()).ToEST().ToString()
                            };
                            foreach (DataRow connectionRow in returndata.Tables[0].Rows)
                            {
                                // Same user can open chat in multiple browsers/tabs at the same time.
                                // Adding all ConnectionIds with chat user
                                if (Convert.ToInt32(connectionRow["UserId"].ToString()) == userId)
                                {
                                    user.ConnectionIds.Add(connectionRow["ConnectionId"].ToString());
                                }
                            }
                            users.Add(user);
                        }
                    }
                    return new ActionOutput<ChatUser>
                    {
                        Results = users,
                        Status = ActionStatus.Successfull
                    };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<ChatUser>
                {
                    Message = ex.Message,
                    Status = ActionStatus.Successfull
                };
            }
        }

        public void ChatLogger(string chatGroupId, string message, int chatSourceId, int UserId, string IP)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SaveChatLog");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@ChatGroupId", DbType.String, chatGroupId);
                    database.AddInParameter(command, "@Message", DbType.String, message);
                    database.AddInParameter(command, "@ChatSourceId", DbType.String, chatSourceId);
                    database.AddInParameter(command, "@UserId", DbType.Int32, UserId);
                    database.AddInParameter(command, "@IP", DbType.String, IP);
                    database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            { Console.Write(ex.Message); }
        }

        public ActionOutput<ChatUser> GetChatUsers(List<int> userIds)
        {
            try
            {
                List<ChatUser> users = new List<ChatUser>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatUsers");
                    database.AddInParameter(command, "@UserIds", DbType.String, string.Join(",", userIds));

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            int userId = Convert.ToInt32(item["UserId"].ToString());
                            ChatUser user = new ChatUser
                            {
                                UserId = userId,
                                //ConnectionId = item["ConnectionId"].ToString(),
                                FirstName = item["FirstName"].ToString(),
                                LastName = item["LastName"].ToString(),
                                Email = item["Email"].ToString(),
                                OnlineAt = Convert.ToDateTime(item["OnlineAt"].ToString()),
                                OnlineAtFormatted = Convert.ToDateTime(item["OnlineAt"].ToString()).ToEST().ToString()
                            };
                            foreach (DataRow connectionRow in returndata.Tables[0].Rows)
                            {
                                // Same user can open chat in multiple browsers/tabs at the same time.
                                // Adding all ConnectionIds with chat user
                                if (Convert.ToInt32(connectionRow["UserId"].ToString()) == userId)
                                {
                                    user.ConnectionIds.Add(connectionRow["ConnectionId"].ToString());
                                }
                            }
                            users.Add(user);
                        }
                    }
                    return new ActionOutput<ChatUser>
                    {
                        Results = users,
                        Status = ActionStatus.Successfull
                    };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<ChatUser>
                {
                    Message = ex.Message,
                    Status = ActionStatus.Successfull
                };
            }
        }

        public ActionOutput<ChatUser> GetChatUser(int UserId)
        {
            try
            {
                ChatUser user = null;
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatUser");
                    database.AddInParameter(command, "@UserId", DbType.Int32, UserId);
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        DataRow item = returndata.Tables[0].Rows[0];
                        user = new ChatUser
                        {
                            UserId = Convert.ToInt32(item["UserId"].ToString()),
                            //ConnectionId = item["ConnectionId"].ToString(),
                            FirstName = item["FirstName"].ToString(),
                            LastName = item["LastName"].ToString(),
                            Email = item["Email"].ToString(),
                            OnlineAt = Convert.ToDateTime(item["OnlineAt"].ToString()),
                            OnlineAtFormatted = Convert.ToDateTime(item["OnlineAt"].ToString()).ToEST().ToString()
                        };
                        // Same user can open chat in multiple browsers/tabs at the same time.
                        // Adding all ConnectionIds with chat user
                        foreach (DataRow connectionRow in returndata.Tables[0].Rows)
                        {
                            user.ConnectionIds.Add(connectionRow["ConnectionId"].ToString());
                        }
                    }
                    else
                    {
                        // User if Offline
                        var usr = InstallUserDAL.Instance.getuserdetails(UserId).Tables[0].Rows[0];
                        user = new ChatUser
                        {
                            UserId = UserId,
                            FirstName = usr["FristName"].ToString(),
                            LastName = usr["LastName"].ToString(),
                            Email = usr["Email"].ToString(),
                            OnlineAt = null,
                            OnlineAtFormatted = null
                        };
                    }
                    return new ActionOutput<ChatUser>
                    {
                        Object = user,
                        Status = ActionStatus.Successfull
                    };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<ChatUser>
                {
                    Message = ex.Message,
                    Status = ActionStatus.Successfull
                };
            }
        }

        public int GetChatUserCount()
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatUserCount");

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return Convert.ToInt32(returndata.Tables[0].Rows[0]["TotalCount"].ToString());
                }
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        public void DeleteChatUser(string ConnectionId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("DeleteChatUser");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@ConnectionId", DbType.String, ConnectionId);
                    database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
            }
        }

        public void SaveChatMessage(ChatMessage message, string ChatGroupId, string ReceiverIds)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("SaveChatMessage");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@ChatSourceId", DbType.Int32, message.ChatSourceId);
                    database.AddInParameter(command, "@ChatGroupId", DbType.String, ChatGroupId);
                    database.AddInParameter(command, "@SenderId", DbType.Int32, message.UserId);
                    database.AddInParameter(command, "@TextMessage", DbType.String, message.Message);
                    database.AddInParameter(command, "@ChatFileId", DbType.String, null);
                    database.AddInParameter(command, "@ReceiverIds", DbType.String, ReceiverIds);
                    database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
            }
        }
    }
}
