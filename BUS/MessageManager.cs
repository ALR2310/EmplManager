using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SubSonic;

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

        public static List<Message> GetListMessageByStatus(int id)
        {
            InlineQuery qry = new InlineQuery();
            List<Message> MessageList = qry.ExecuteTypedList<Message>($"Select * From Messages inner join users on users.id = messages.userid where messages.status = '{id}'");

            return MessageList;
        }

        //public static List<Message> GetListMessageById(int id)
        //{
        //    return new Select().From(Message.Schema.TableName).Where(Message.Columns.Status).IsEqualTo(id)
        //        .ExecuteTypedList<Message>();
        //}


    }
}
