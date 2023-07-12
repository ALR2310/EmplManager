using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.Model
{
    public class LikeJoinUser
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int MessageId { get; set; }
        public int Status { get; set; }
        public string Avatar { get; set; }
        public string DisplayName { get; set; }
    }
}
