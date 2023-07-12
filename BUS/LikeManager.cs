using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BUS
{
    public class LikeManager
    {
        public static Like InsertLike(Like like)
        {
            return new LikeController().Insert(like);
        }
    }
}
