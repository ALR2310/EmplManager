using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SubSonic;
using DAL.Model;
using System.Diagnostics;

namespace BUS
{
    public class MessageManager
    {
        public static Message InsertMessage(Message message)
        {
            return new MessageController().Insert(message);
        }

        public static Message GetMessageById(object id)
        {
            return new Select().From(Message.Schema.TableName).Where(Message.Columns.Id).IsEqualTo(id).
                ExecuteSingle<Message>();
        }
        public static void SetMessStatusToDeleted(int messageid)
        {
            Message mess = GetMessageById(messageid);
            mess.Status = 0;
            mess.Save();

        }
        public static void DeleteMessageById(int id)
        {
            new MessageController().Delete(id);


        }
        public static List<MessageJoinUser> GetListMessageByStatus()
        {
            var query = new InlineQuery();
            var sqlquery = "SELECT dbo.Messages.*, Avatar, Email, DisplayName FROM dbo.Messages " +
                "INNER JOIN dbo.Users ON Users.Id = Messages.UserId WHERE dbo.Messages.Status = 1";
            List<MessageJoinUser> list = query.ExecuteTypedList<MessageJoinUser>(sqlquery);
            return list;
        }

        public static List<MessageJoinUser> GetListMessageByAtCreate()
        {
            var query = new InlineQuery();
            var sqlquery = "SELECT dbo.Messages.*, Avatar, Email, DisplayName FROM dbo.Messages " +
                "INNER JOIN dbo.Users ON Users.Id = Messages.UserId WHERE dbo.Messages.Status = 1  order by Messages.AtCreate ASC";
            Debug.WriteLine(sqlquery);
            List<MessageJoinUser> list = query.ExecuteTypedList<MessageJoinUser>(sqlquery);
            return list;
        }
    }
}
