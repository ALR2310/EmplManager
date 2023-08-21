using DAL;
using DAL.Model;
using SubSonic;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace BUS
{
    public class UserManager
    {

        public static int? checkValidCookie(HttpRequest Request)
        {
            if (Request.Cookies["AuthToken"] == null) { return null; }

            string authToken = Request.Cookies["AuthToken"].Value;
            int? isValid = getTokenUserId(authToken);

            /*
                string comment = isValid  ? "Valid " : "InValid ";
                string script = $"alert(\" {comment}Cookie!! \")";

                ScriptManager.RegisterStartupScript(this, GetType(), "AlertScript", script, true);
            */

            return isValid;


        }
        public static BasicUserData GetUserBasicDataById(int id)
        {
            InlineQuery qry = new InlineQuery();
            string query = $"select Id,Avatar,DisplayName,UserType from users where id = '{id}'";

            var UserData = qry.ExecuteTypedList<BasicUserData>(query);

            return UserData.Count != 0 ? UserData[0] : null;

        }
        public static int? getTokenUserId(string token)
        {
            InlineQuery qry = new InlineQuery();
            string query = $"Select Id From authTokens Where authToken = '{token}'";
            List<AuthTokens> LoggedTokens = qry.ExecuteTypedList<AuthTokens>(query);
            if (LoggedTokens.Count == 0) { return null; }
            return LoggedTokens[0].Id;

        }
        public static string generateAndSetToken(int id, string username, string password)
        {
            InlineQuery qry = new InlineQuery();
            string query = $"Select authToken From authTokens Where Id = {id}";


            List<AuthTokens> LoggedTokens = qry.ExecuteTypedList<AuthTokens>(query);


            if (LoggedTokens.Count == 1) { return LoggedTokens[0].authToken; }
            string currentTime = DateTime.Now.ToString("yyyyMMddHHmmss");
            string tokenData = username + password + currentTime;
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] hashBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(tokenData));

                // Convert the hashed bytes to a hexadecimal string
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < hashBytes.Length; i++)
                {
                    sb.Append(hashBytes[i].ToString("x2"));
                }
                qry.Execute($"Insert Into authTokens Values ({id},'{sb.ToString()}')");

                return sb.ToString();
            }
        }

        public static string getOrSetAuthTokenFromNewGoogleAccount(string googleName, string googleId)
        {
            InlineQuery qry = new InlineQuery();



            List<User> LoggedUsers = qry.ExecuteTypedList<User>($"Select * From Users Where GoogleId = '{googleId}'");


            if (LoggedUsers.Count == 0)
            {
                return "_failed_";
            }

            string query = $"Select authToken From authTokens Where Id = {LoggedUsers[0].Id}";

            List<AuthTokens> LoggedTokens = qry.ExecuteTypedList<AuthTokens>(query);

            if (LoggedTokens.Count == 1) { return LoggedTokens[0].authToken; }

            return generateAndSetToken(LoggedUsers[0].Id, googleName, googleId);
        }
        public static string Login(string username, string password)
        {
            InlineQuery qry = new InlineQuery();



            // Concatenate the username, password, and current time


            // Compute the hash of the token data using SHA256

            List<User> LoggedUsers = qry.ExecuteTypedList<User>($"Select * From Users Where (UserName = '{username}' or Email = '{username}') and Password = '{password}'");


            if (LoggedUsers.Count == 0)
            {
                return "_failed_";
            }

            return generateAndSetToken(LoggedUsers[0].Id, username, password);
        }
        public static User InsertUser(User user)
        {
            return new UserController().Insert(user);
        }

        public static void InsertUsers(User user)
        {
            var sql = new InlineQuery();
            string query = $"Insert Into dbo.Users(GoogleId, Avatar, Email, DisplayName, UserName, Password, UserType, Status) " +
                $"Values({user.GoogleId}, N'{user.Avatar}', N'{user.Email}', N'{user.DisplayName}', N'{user.UserName}', N'{user.Password}', {user.UserType}, {user.Status}); " +
                "SELECT SCOPE_IDENTITY();"; // Lấy Id của bản ghi chèn vào Users
            int userId = sql.ExecuteScalar<int>(query);

            query = $"Insert Into dbo.UserInfor(UserId) values({userId})";
            sql.Execute(query);
        }

        public static User UpdateUser(User user)
        {
            return new UserController().Update(user);
        }

        public static User GetUserByEmail(string email)
        {
            return new Select().From(User.Schema.TableName).Where(User.Columns.Email).IsEqualTo(email).ExecuteSingle<User>();

        }
        public static User GetUsersById(int id)
        {
            return new Select().From(User.Schema.TableName).Where(User.Columns.Id).IsEqualTo(id).ExecuteSingle<User>();
        }

        //check email is exists
        public static int CheckEmailUser(string email)
        {
            return new Select().From(User.Schema.TableName).Where(User.Columns.Email).IsEqualTo(email).ExecuteScalar<int>();
        }

        //check username is exists
        public static int CheckUserName(string userName)
        {
            return new Select().From(User.Schema.TableName).Where(User.Columns.UserName).IsEqualTo(userName).ExecuteScalar<int>();
        }

        //count day user online
        public static int CountDayUserOnline(int id)
        {
            var query = new InlineQuery();
            var sqlquery = $"SELECT COUNT(Content) AS 'total' FROM dbo.Messages WHERE UserId = {id}";

            int count = query.ExecuteScalar<int>(sqlquery);
            return count;
        }

        //Check Exists GoogleId For Users
        public static List<User> GoogleIdIsExists(string GoogleId)
        {
            var sql = new InlineQuery();
            string query = $"SELECT * FROM dbo.Users WHERE GoogleId = '{GoogleId}'";

            List<User> result = sql.ExecuteTypedList<User>(query);
            return result;
        }

        //Update Avatar Url
        public static void UpdateAvatarUrl(string avatarPath, int id)
        {
            var sql = new InlineQuery();
            var query = $"UPDATE Users SET Avatar = N'{avatarPath}' WHERE Id = {id}";
            sql.Execute(query);
        }

        //Update User And UserInfor
        public static bool UpdateUsers(EmpolyeeInfor empolyee)
        {
            var query = new InlineQuery();
            string sqlquery = $"UPDATE dbo.Users SET DisplayName = N'{empolyee.DisplayName}', Email = N'{empolyee.Email}', " +
                $"AtCreate = '{empolyee.AtCreate.ToString("yyyy-MM-dd HH:mm:ss")}' WHERE Id = {empolyee.Id}";
            query.Execute(sqlquery);

            sqlquery = $"UPDATE dbo.UserInfor SET PhoneNumber = '{empolyee.PhoneNumber}', Job = N'{empolyee.Job}', " +
                $"Department = N'{empolyee.Department}', Gender = N'{empolyee.Gender}', DateOfBirth = '{empolyee.DateOfBirth.ToString("yyyy-MM-dd")}', " +
                $"Address = N'{empolyee.Address}' WHERE UserId = {empolyee.Id}";
            query.Execute(sqlquery);
            return true;
        }

    }
}
