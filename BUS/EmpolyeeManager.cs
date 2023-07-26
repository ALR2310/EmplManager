using DAL.Model;
using SubSonic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BUS
{
    public class EmpolyeeManager
    {
        public static List<EmpolyeeInfor> GetAllEmpolyee()
        {
            var query = new InlineQuery();
            string sqlquery = "SELECT users.Id, users.GoogleId, users.Avatar, users.Email, users.DisplayName, users.AtCreate, " +
                "users.UserType, users.Status, dbo.UserInfor.Job, dbo.UserInfor.PhoneNumber, dbo.UserInfor.Department, " +
                "dbo.UserInfor.Gender, dbo.UserInfor.DateOfBirth, dbo.UserInfor.Address " +
                "FROM dbo.Users INNER JOIN dbo.UserInfor ON UserInfor.UserId = Users.Id ";
            var result = query.ExecuteTypedList<EmpolyeeInfor>(sqlquery);
            return result;
        }

        public static EmpolyeeInfor GetEmpolyeeById(int Id)
        {
            var query = new InlineQuery();
            string sqlquery = $@"SELECT users.Id, users.GoogleId, users.Avatar, users.Email, users.DisplayName, users.AtCreate, 
                        users.UserType, users.Status, dbo.UserInfor.Job, dbo.UserInfor.PhoneNumber, dbo.UserInfor.Department, 
                        dbo.UserInfor.Gender, dbo.UserInfor.DateOfBirth, dbo.UserInfor.Address 
                        FROM dbo.Users 
                        INNER JOIN dbo.UserInfor ON UserInfor.UserId = Users.Id 
                        WHERE users.Id = {Id}";

            var result = query.ExecuteTypedList<EmpolyeeInfor>(sqlquery);
            return result.FirstOrDefault();
        }

        public static int CountEmpolyee()
        {
            var qry = new InlineQuery();
            string sqlquery = "SELECT COUNT(dbo.Users.Id) FROM dbo.Users";
            int result = qry.ExecuteScalar<int>(sqlquery);
            return result;
        }
    }
}
