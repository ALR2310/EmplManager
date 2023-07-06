using SubSonic;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace DAL
{
    public class AuthTokens : ActiveRecord<User>, IActiveRecord
    {

        public struct Columns
        {
            public static string Id = @"Id";
            public static string authToken = @"authToken";

        }

        [XmlAttribute("Id")]
        [Bindable(true)]
        public int Id
        {
            get { return GetColumnValue<int>(Columns.Id); }
            set { SetColumnValue(Columns.Id, value); }
        }


        [XmlAttribute("authToken")]
        [Bindable(true)]
        public string authToken
        {
            get { return GetColumnValue<string>(Columns.authToken); }
            set { SetColumnValue(Columns.authToken, value); }
        }
    }
}
