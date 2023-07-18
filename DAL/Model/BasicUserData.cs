using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.Model
{
    [Serializable]
    public class BasicUserData
    {

        public int Id { get; set; }

        public string Avatar { get; set; }
        public string DisplayName { get; set; }
        public int UserType { get; set; }


    }
}
