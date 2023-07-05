using DAL;
using SubSonic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BUS
{
    public class UserManager
    {
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

        public static int CheckEmailUser(string email)
        {
            return new Select().From(User.Schema.TableName).Where(User.Columns.Email).IsEqualTo(email).ExecuteScalar<int>();
        }
    }
}
