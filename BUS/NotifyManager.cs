using DAL.Model;
using SubSonic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace BUS
{
    public class NotifyManager
    {
        //Thêm một bảng ghi mới vào bảng notify
        public static void InsertNotify(Notifys notifys)
        {
            var sql = new InlineQuery();
            var query = $"EXEC AddNotificationAndUserNotify @UserId = {notifys.UserId}, @Content = N'{notifys.Content}', @Status = {notifys.Status}";
            sql.Execute(query);
        }

        //Lấy ra tất cả bảng ghi của bảng notify
        public static List<BasicUserNotify> LoadNotify()
        {
            var sql = new InlineQuery();
            var query = $"SELECT dbo.Notifys.Id, users.Id AS UserId, users.DisplayName, " +
                $"users.Avatar, dbo.Notifys.AtCreate, dbo.Notifys.Content, users.Email " +
                $"FROM dbo.Notifys INNER JOIN dbo.Users ON Users.Id = Notifys.UserId ORDER BY Notifys.AtCreate DESC";
            var result = sql.ExecuteTypedList<BasicUserNotify>(query);
            return result;
        }

        //Lấy ra tất cả bảng ghi của bảng notify với isRead=false
        public static List<BasicUserNotify> LoadNotifyUnRead(int UserId)
        {
            var sql = new InlineQuery();
            var query = $"SELECT n.Id, n.UserId, u.DisplayName, u.Avatar, n.AtCreate, n.Content, u.Email " +
                $"FROM dbo.Notifys AS n INNER JOIN dbo.Users AS u ON u.Id = n.UserId INNER JOIN dbo.UserNotify " +
                $"AS un ON un.NotifyId = n.Id WHERE un.UserId = {UserId} AND un.IsRead = {0} ORDER BY n.AtCreate DESC";
            var result = sql.ExecuteTypedList<BasicUserNotify>(query);
            return result;
        }

        //Lấy ra thông tin usernotify đầu tiên hoặc id user được truyền vào
        public static BasicUserNotify FirstDataNotify(int NotifyId)
        {
            var sql = new InlineQuery();

            string query;

            if (NotifyId <= 0)
            {
                query = $"SELECT dbo.Notifys.Id, users.Id AS UserId, users.DisplayName, " +
                $"users.Avatar, dbo.Notifys.AtCreate, dbo.Notifys.Content, users.Email " +
                $"FROM dbo.Notifys INNER JOIN dbo.Users ON Users.Id = Notifys.UserId ORDER BY Notifys.AtCreate DESC";
                var result = sql.ExecuteTypedList<BasicUserNotify>(query).FirstOrDefault();
                return result;
            }
            else
            {
                query = $"SELECT dbo.Notifys.Id, users.Id AS UserId, users.DisplayName, " +
                $"users.Avatar, dbo.Notifys.AtCreate, dbo.Notifys.Content, users.Email " +
                $"FROM dbo.Notifys INNER JOIN dbo.Users ON Users.Id = Notifys.UserId WHERE Notifys.Id = {NotifyId}";
                var result = sql.ExecuteTypedList<BasicUserNotify>(query).FirstOrDefault();
                return result;
            }
        }

        //cập nhật bảng usernotify, đánh dấu là đã xem
        public static bool InsertUserIsRead(UserNotify userNotify)
        {
            var sql = new InlineQuery();
            string query = $"SELECT * FROM dbo.UserNotify WHERE NotifyId = {userNotify.NotifyId} AND UserId = {userNotify.UserId} AND IsRead = {0}";
            List<UserNotify> result = sql.ExecuteTypedList<UserNotify>(query);
            if (result.Count > 0)
            {
                query = $"UPDATE dbo.UserNotify SET IsRead = {1} WHERE NotifyId = {userNotify.NotifyId} AND UserId = {userNotify.UserId}";
                sql.Execute(query);
                return true;
            }
            return false;
        }

        //lấy các bảng ghi của bảng usernotify
        public static List<UserNotify> GetDataUserNotify(int UserId)
        {
            var sql = new InlineQuery();
            string query = $"SELECT * FROM dbo.UserNotify Where UserId = {UserId}";
            var result = sql.ExecuteTypedList<UserNotify>(query);
            return result;
        }
    }
}
