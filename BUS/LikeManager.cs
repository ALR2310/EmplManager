using DAL;
using DAL.Model;
using SubSonic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BUS
{
    public class LikeManager
    {
        public static Like InsertLike(Like like)
        {
            return new LikeController().Insert(like);
        }

        public static List<LikeJoinUser> GetAllUserAndEmoji()
        {
            var query = new InlineQuery();
            var sqlquery = "SELECT likes.*, users.Avatar, users.DisplayName FROM dbo.Likes INNER JOIN dbo.Users ON Users.Id = Likes.UserId";
            List<LikeJoinUser> list = query.ExecuteTypedList<LikeJoinUser>(sqlquery);
            return list;
        }
    }
}
