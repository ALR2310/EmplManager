using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.Model
{
    public class Notifys
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public DateTime AtCreate { get; set; }
        public string Content { get; set; }
        public int Status { get; set; }
    }
}
