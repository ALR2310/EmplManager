using DAL;
using DAL.Model;
using SubSonic;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Configuration;

namespace BUS
{
    public class LikeManager
    {
        public static Like InsertLike(Like like)
        {
            return new LikeController().Insert(like);
        }

        public static List<LikeJoinUser> GetAllUserAndEmoji(int messageId)
        {
            var query = new InlineQuery();
            var sqlquery = $"SELECT likes.*, users.Avatar, users.DisplayName " +
                $"FROM dbo.Likes INNER JOIN dbo.Users ON Users.Id = Likes.UserId " +
                $"WHERE Likes.Status = 1 AND MessageId = {messageId}";
            List<LikeJoinUser> list = query.ExecuteTypedList<LikeJoinUser>(sqlquery);
            return list;
        }

        public static Like UpdateLike(Like like)
        {
            return new LikeController().Update(like);
        }

        public static void ChangeStatusLike(int id)
        {
            var query = new InlineQuery();
            string sqlquery = $"UPDATE dbo.Likes SET Status = 0 WHERE Id = {id}";

            query.Execute(sqlquery);
        }

        public static int CountEmoji()
        {
            var query = new InlineQuery();
            string sqlquery = "select like";

            int result = query.ExecuteScalar<int>(sqlquery);

            return result;
        }
    }
}
