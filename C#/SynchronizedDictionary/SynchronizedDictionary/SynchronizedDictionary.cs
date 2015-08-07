using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace Synchronized
{
    public class SynchronizedDictionary<TId, TName, T>
    {
        private int count;
        private readonly Dictionary<TId, Dictionary<TName, T>> dicById;
        private readonly Dictionary<TName, Dictionary<TId, T>> dicByName;
        private readonly object dictionaryLock = new object();

        public SynchronizedDictionary()
        {
            dicById = new Dictionary<TId, Dictionary<TName, T>>();
            dicByName = new Dictionary<TName, Dictionary<TId, T>>();
        }

        /// <summary>
        /// Получить элементы по Id
        /// </summary>
        public IList<T> GetById(TId id)
        {
            Dictionary<TName, T> dicName;

            if (!dicById.TryGetValue(id, out dicName))
            {
                return new List<T>();
            }

            return dicName.Values.ToList();
        }

        /// <summary>
        /// Получить элементы по Name
        /// </summary>
        public IList<T> GetByName(TName name)
        {
            Dictionary<TId, T> dicId;

            if (!dicByName.TryGetValue(name, out dicId))
            {
                return new List<T>();
            }

            return dicId.Values.ToList();
        }

        /// <summary>
        /// Получить элемент по ключу
        /// </summary>
        public T Get(TId id, TName name)
        {
            Dictionary<TName, T> dicName;
            if (!dicById.TryGetValue(id, out dicName))
            {
                return default(T);
            }

            T value;
            if (dicName.TryGetValue(name, out value))
            {
                return value;
            }

            return default(T);
        }

        /// <summary>
        /// Добавить элемент
        /// </summary>
        public void Add(TId id, TName name, T value)
        {
            lock (dictionaryLock)
            {
                Dictionary<TName, T> dicName;

                if (!dicById.TryGetValue(id, out dicName))
                {
                    dicName = new Dictionary<TName, T>();
                    dicById.Add(id, dicName);
                }

                if (dicName.ContainsKey(name))
                {
                    throw new ArgumentOutOfRangeException("name", "Element with given (Id, Name) already exists");
                }

                Dictionary<TId, T> dicId;
                if (!dicByName.TryGetValue(name, out dicId))
                {
                    dicId = new Dictionary<TId, T>();
                    dicByName.Add(name, dicId);
                }

                if (dicId.ContainsKey(id))
                {
                    throw new ArgumentOutOfRangeException("name", "Element with given (Id, Name) already exists");
                }

                dicId.Add(id, value);
                dicName.Add(name, value);
                count++;
            }
        }

        /// <summary>
        /// Удалить элемент
        /// </summary>
        public void Remove(TId id, TName name)
        {
            lock (dictionaryLock)
            {
                Dictionary<TName, T> dicName;
                if (!dicById.TryGetValue(id, out dicName))
                {
                    return;
                }

                Dictionary<TId, T> dicId;
                if (!dicByName.TryGetValue(name, out dicId))
                {
                    return;
                }

                dicId.Remove(id);
                dicName.Remove(name);
                count--;
            }
        }

        public int Count
        {
            get
            {
                return count;
            }
        }
    }
}