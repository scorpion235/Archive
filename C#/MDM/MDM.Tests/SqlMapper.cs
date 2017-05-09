using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SqlMapper
{
    static class SqlMapper
    {

        public static void IsEqualTo<T>(this T obj, T other)
        {
            if (!Equals(obj, other))
            {
                throw new ApplicationException(string.Format("{0} должно быть равно {1}", obj, other));
            }
        }

        public static void IsSequenceEqualTo<T>(this IEnumerable<T> obj, IEnumerable<T> other)
        {
            if (!(obj ?? new T[0]).SequenceEqual(other ?? new T[0]))
            {
                throw new ApplicationException(string.Format("{0} должно быть равно {1}", obj, other));
            }
        }

        public static void IsFalse(this bool b)
        {
            if (b)
            {
                throw new ApplicationException("Ожидание false");
            }
        }

        public static void IsTrue(this bool b)
        {
            if (!b)
            {
                throw new ApplicationException("Ожидание true");
            }
        }

        public static void IsNull(this object obj)
        {
            if (obj != null)
            {
                throw new ApplicationException("Ожидание null");
            }
        }

        public static void IsNotNull(this object obj)
        {
            if (obj == null)
            {
                throw new ApplicationException("Ожидание not null");
            }
        }
    }
}