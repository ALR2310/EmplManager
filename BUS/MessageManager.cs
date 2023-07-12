using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SubSonic;
using DAL.Model;
using System.Diagnostics;
using System.Web.UI;

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
        public static void SetMessStatusToDeleted(int messageid, int status)
        {
            Message mess = GetMessageById(messageid);
            mess.Status = status;
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

        public static List<MessageJoinUser> GetListMessageByAtCreate(int Page)
        {
            var query = new InlineQuery();
            var sqlquery = "SELECT * FROM ( SELECT [QuanLyRaVaoCty].[dbo].[Messages].*, Avatar, Email, DisplayName " +
                "FROM [QuanLyRaVaoCty].[dbo].[Messages] INNER JOIN dbo.Users ON Users.Id = Messages.UserId " +
                $"ORDER BY Messages.AtCreate DESC OFFSET {(Page - 1) * 25} ROWS FETCH NEXT 25 ROWS ONLY) AS Subquery " +
                "ORDER BY Subquery.AtCreate ASC;";
            Debug.WriteLine(sqlquery);
            List<MessageJoinUser> list = query.ExecuteTypedList<MessageJoinUser>(sqlquery);
            return list;
        }

        public static Like InsertLike(Like like)
        {
            return new LikeController().Insert(like);
        }
    }
}
