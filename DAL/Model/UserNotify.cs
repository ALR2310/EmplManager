using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.Model
{
    public class UserNotify
    {
        public int Id { get; set; }
        public int NotifyId { get; set; }
        public int UserId { get; set; }
        public bool IsRead { get; set; }
    }
}
