using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.Model
{
    public class EmpolyeeInfor
    {
        public int Id { get; set; }
        public int GoogleId { get; set; }
        public string Avatar { get; set; }
        public string Email { get; set; }
        public string DisplayName { get; set; }
        public DateTime AtCreate { get; set; }
        public int UserType { get; set; }
        public int Status { get; set; }
        public string Job { get; set; }
        public string PhoneNumber { get; set; }
        public string Department { get; set; }
        public string Gender { get; set; }
        public DateTime DateOfBirth { get; set; }
        public string Address { get; set; }
    }
}
