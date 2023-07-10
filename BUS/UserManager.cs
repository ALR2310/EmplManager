using DAL;
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

        public static bool checkValidCookie(HttpRequest Request)
        {
            if (Request.Cookies["AuthToken"] == null) { return false; }

            string authToken = Request.Cookies["AuthToken"].Value;
            bool isValid = getTokenUser(authToken) != null;

            /*
                string comment = isValid  ? "Valid " : "InValid ";
                string script = $"alert(\" {comment}Cookie!! \")";

                ScriptManager.RegisterStartupScript(this, GetType(), "AlertScript", script, true);
            */

            return isValid;


        }
        public static User getTokenUser(string token)
        {
            InlineQuery qry = new InlineQuery();
            string query = $"Select Id From authTokens Where authToken = '{token}'";
            List<AuthTokens> LoggedTokens = qry.ExecuteTypedList<AuthTokens>(query);
            if (LoggedTokens.Count == 0) { return null; }
            return GetUsersById(LoggedTokens[0].Id);
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

        public static User UpdateUser(User user)
        {
            return new UserController().Update(user);
        }

        public static bool DeleteUser(int id)
        {
            return new UserController().Delete(id);
        }

        public static List<User> GetAllUsers()
        {
            return new Select().From(User.Schema.TableName).ExecuteTypedList<User>();
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
            var sql = new InlineQuery();
            var sqlquery = "";

        }
    }
}
