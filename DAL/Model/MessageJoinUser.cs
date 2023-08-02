using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.Model
{
    [Serializable]
    public class MessageJoinUser
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string Content { get; set; }
        public DateTime AtCreate { get; set; }
        public int Status { get; set; }


        public bool Edited {
            get; set;
        }

        public Dictionary<int, List<int>> Reactions { get; set; }

      
    }
}
