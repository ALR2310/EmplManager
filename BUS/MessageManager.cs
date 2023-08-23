using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SubSonic;
using DAL.Model;
using System.Diagnostics;

using System.Text.Json;
using System.Data;
using System.Web.UI.WebControls;

namespace BUS
{
    public class MessageManager
    {
        private static Dictionary<string, string> file_format_to_str = new Dictionary<string, string>()
        {
            {"video","%mp4%,%mov%,%wmv%,%webm%,%avi%,%flv%,%mkv%" },
            {"image","%jpg%,%png%,%gif%,%apng%,%jfif%,%jpeg%" }
        };
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
        public static void InsertEmoji(int UID, int MID, int EmojiId)
        {

            var query = new InlineQuery();
            var sqlquery = $"eXEC InsertEmojiToMessage @uid = {UID}, @mid = {MID}, @emj = {EmojiId}";
            Debug.WriteLine(sqlquery);
            query.Execute(sqlquery);
        }
        public static List<int> GetReactionsByMessageId(int messageId, int emoji_id)
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
        public static string SearchMessage(Dictionary<string, object> option, string search_str, int page)
        {
            string querystr = $"EXECUTE dbo.search_messages_by_content @search_str = N'{search_str}', @page = {page}";


            Debug.WriteLine(option);
            InlineQuery query = new InlineQuery();
            if (option.Keys.Contains("from"))
            {

                List<string> from_params = ((object[])option["from"]).OfType<string>().ToList();
                StringBuilder combinedString = new StringBuilder();
                foreach (string id in from_params)
                {
                    combinedString.Append(id);
                }
                querystr = querystr + ", @id_list = '" + combinedString.ToString() + "'";
                Debug.WriteLine(querystr);
            }
         
            if (option.Keys.Contains("has"))
            {
                Debug.Write(JsonSerializer.Serialize(option["has"]));
                object[] object_list = (object[])option["has"];
                List<string> has_params = object_list.OfType<string>().ToList();
                if (has_params.Contains("link"))
                {
                    querystr = querystr + ", @search_link = 1";
                    has_params.Remove("link");
                }

                if (has_params.Count != 0)
                {
                    StringBuilder combinedString = new StringBuilder();

                    foreach (string key in has_params)
                    {
                        if (file_format_to_str.TryGetValue(key, out string value))
                        {
                            combinedString.Append(value);
                        }
                    }

                    string result = combinedString.ToString();

                    Console.WriteLine(result);
                    querystr = querystr + ", @has_file = '" + result + "'";
                }
            }

            Debug.WriteLine(querystr);
            List<SearchingMessage> list = query.ExecuteTypedList<SearchingMessage>(querystr);
            Dictionary<object, object> dict = list.ToDictionary(item => (object)item.Id, item => (object)item);



            IDataReader reader = query.ExecuteReader(querystr + ",@count_only = 1;");



            if (reader.Read())
            {

                dict["Results"] = Convert.ToString(reader[0]);
            }

            reader.Close();




            return JsonSerializer.Serialize(dict);
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

                if (reactionlist.Count > 0)
                {

                    Dictionary<int, List<int>> reactions = reactionlist.ToDictionary(item => item.Status, item => item.Usernames.Split(',').Select(s => int.Parse(s.Trim())).ToList());

                    mess.Reactions = reactions;
                }

            }

            return list.ToDictionary(item => item.Id, item => item);
        }
    }
}
