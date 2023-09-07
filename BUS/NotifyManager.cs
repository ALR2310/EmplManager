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
        public static void InsertNotify(Notifys notifys)
        {
            var sql = new InlineQuery();
            var query = $"INSERT INTO dbo.Notifys VALUES ('{notifys.UserId}', GETDATE(), N'{notifys.Content}', {notifys.Status})";
            sql.Execute(query);
        }

        public static List<BasicUserNotify> LoadNotify()
        {
            var sql = new InlineQuery();
            var query = $"SELECT dbo.Notifys.Id, users.Id, users.DisplayName, " +
                $"users.Avatar, dbo.Notifys.AtCreate, dbo.Notifys.Content, users.Email " +
                $"FROM dbo.Notifys INNER JOIN dbo.Users ON Users.Id = Notifys.UserId";
            var result = sql.ExecuteTypedList<BasicUserNotify>(query);
            return result;
        }
    }
}
