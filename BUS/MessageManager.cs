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
using System.Security.Cryptography;

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
        public static void SetMessStatusToDeleted(MessageJoinUser message, int status)
        {
            var query = new InlineQuery();
            var sqlquery = $"Update Messages SET Status = {status} where Id = {message.Id}";
            query.Execute(sqlquery);

            message.Status = status;
        }
        public static void DeleteMessageById(int id)
        {
            new MessageController().Delete(id);


        }
        public static void InsertEmoji(int UID,int MID,int EmojiId)
        {

            var query = new InlineQuery();
            var sqlquery = $"InsertEmojiToMessage @uid = {UID}, @mid {MID}, @emj = {EmojiId}";
            query.Execute(sqlquery);
        }

        public static Dictionary<int, MessageJoinUser> GetListMessageByAtCreate(int Page)
        {
            var query = new InlineQuery();
            var sqlquery = $"EXECUTE dbo.GetListMessageByAtCreate @page = {Page}";
            Debug.WriteLine(sqlquery);
            List<MessageJoinUser> list = query.ExecuteTypedList<MessageJoinUser>(sqlquery);

            foreach (MessageJoinUser mess in list)
            {
                var reactionQuery = $"EXEC get_message_reactions @MID = ${mess.Id}";


                Dictionary<int, List<int>> reactions = query.ExecuteTypedList<(int Status, string UserIds)>(reactionQuery)
                    .ToDictionary(item => item.Status, item => item.UserIds.Split(',').Select(int.Parse).ToList());

                mess.Reactions = reactions;
            }

            return list.ToDictionary(item => item.Id, item => item);
        }
    }
}
