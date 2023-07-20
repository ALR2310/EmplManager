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
using System.Collections;

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
        public static bool SetMessStatusToDeleted(int Id, int status)
        {
            try
            {
                var query = new InlineQuery();
                var sqlquery = $"Update Messages SET Status = {status} where Id = {Id}";
                query.Execute(sqlquery);

                return true;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex);
                return false;
            }
         
        }
        public static void DeleteMessageById(int id)
        {
            new MessageController().Delete(id);


        }
        public static void InsertEmoji(int UID,int MID,int EmojiId)
        {

            var query = new InlineQuery();
            var sqlquery = $"eXEC InsertEmojiToMessage @uid = {UID}, @mid = {MID}, @emj = {EmojiId}";
            Debug.WriteLine(sqlquery);
            query.Execute(sqlquery);
        }
        public static List<int> GetReactionsByMessageId(int messageId,int emoji_id)
        {
            var query = new InlineQuery();
            var reactionQuery = $"EXEC get_reaction_id_list_by_emoji_id @MID = ${messageId}, @eid = ${emoji_id}";
            List<Reactions> reactionlist = query.ExecuteTypedList<Reactions>(reactionQuery);
            if (reactionlist.Count > 0)
            {

                return reactionlist[0].Usernames.Split(',').Select(s => int.Parse(s.Trim())).ToList();

            }

            return null;
        }
        public static Dictionary<int, MessageJoinUser> GetListMessageByAtCreate(int after_id)
        {
            var query = new InlineQuery();
            var sqlquery = $"EXECUTE dbo.GetListMessageByAtCreateAfterId @id = {after_id}";
            Debug.WriteLine(sqlquery);
            List<MessageJoinUser> list = query.ExecuteTypedList<MessageJoinUser>(sqlquery);

            foreach (MessageJoinUser mess in list)
            {

                var reactionQuery = $"EXEC get_message_reactions @MID = ${mess.Id}";
        
                List<Reactions> reactionlist = query.ExecuteTypedList<Reactions>(reactionQuery);

                if (reactionlist.Count > 0) {
            
                    Dictionary<int, List<int>> reactions = reactionlist.ToDictionary(item => item.Status, item => item.Usernames.Split(',').Select(s => int.Parse(s.Trim())).ToList());

                    mess.Reactions = reactions;
                }
             
            }

            return list.ToDictionary(item => item.Id, item => item);
        }
    }
}
