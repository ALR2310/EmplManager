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
    public class EmpolyeeManager
    {
        //Lấy tất cả dữ liệu người dùng
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

        //Lấy dữ liệu người dùng bằng Id
        public static EmpolyeeInfor GetEmpolyeeById(int Id)
        {
            var query = new InlineQuery();
            string sqlquery = $@"SELECT users.Id, users.GoogleId, users.Avatar, users.Email, users.DisplayName, users.AtCreate, 
                        users.UserType, users.Status, dbo.UserInfor.Job, dbo.UserInfor.PhoneNumber, dbo.UserInfor.Department, 
                        dbo.UserInfor.Gender, dbo.UserInfor.DateOfBirth, dbo.UserInfor.Address 
                        FROM dbo.Users INNER JOIN dbo.UserInfor ON UserInfor.UserId = Users.Id WHERE users.Id = {Id}";

            var result = query.ExecuteTypedList<EmpolyeeInfor>(sqlquery);
            return result.FirstOrDefault();
        }

        //Lấy dữ liệu người dùng bằng Tên, công việc và Id
        public static List<EmpolyeeInfor> SearchEmpolyee(string SearchContent)
        {
            var query = new InlineQuery();
            string sqlquery = $"SELECT users.Id, users.GoogleId, users.Avatar, users.Email, users.DisplayName, users.AtCreate, " +
                        $"users.UserType, users.Status, dbo.UserInfor.Job, dbo.UserInfor.PhoneNumber, dbo.UserInfor.Department, " +
                        $"dbo.UserInfor.Gender, dbo.UserInfor.DateOfBirth, dbo.UserInfor.Address FROM dbo.Users INNER JOIN " +
                        $"dbo.UserInfor ON UserInfor.UserId = Users.Id WHERE DisplayName LIKE N'%{SearchContent}%'";


            var result = query.ExecuteTypedList<EmpolyeeInfor>(sqlquery);
            return result;
        }

        //Thay đổi trạng thái tài khoản
        public static void ChangeStatusUer(int Status, int Id)
        {
            var query = new InlineQuery();
            string sqlquery = $"UPDATE dbo.Users SET Status = {Status} WHERE Id = {Id}";
            query.Execute(sqlquery);
        }

        //Thay đổi quyền tài khoản
        public static void ChangeUserType(int UserType, int UserId)
        {
            var query = new InlineQuery();
            string sqlquery = $"UPDATE dbo.Users SET UserType = {UserType} WHERE Id = {UserId}";
            query.Execute(sqlquery);
        }


        //Xoá tài khoản
        public static bool DeleteUser(int UserId)
        {
            var query = new InlineQuery();
            string sqleury = $"DELETE FROM dbo.UserInfor WHERE UserId = {UserId}";
            query.Execute(sqleury);
            sqleury = $"DELETE FROM Users WHERE Id = {UserId}";
            query.Execute(sqleury);
            return true;
        }

        //Đếm tổng số tài khoản
        public static int CountEmpolyee()
        {
            var qry = new InlineQuery();
            string sqlquery = "SELECT COUNT(dbo.Users.Id) FROM dbo.Users";
            int result = qry.ExecuteScalar<int>(sqlquery);
            return result;
        }
    }
}
