using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace Synchronized
{
    public class SynchronizedDictionary<TKey, TValue> : IDictionary<TKey, TValue>
    {
        /// <summary>
        /// Словарь.
        /// </summary>
        private readonly IDictionary m_Dictionary;

        /// <summary>
        /// Ключи словаря.
        /// </summary>
        private ICollection<TKey> keys;

        /// <summary>
        /// Значения словаря.
        /// </summary>
        private ICollection<TValue> values;

        /// <summary>
        /// Инициализирует новый экземпляр класса SynchronizedDictionary {TKey, TValue}.
        /// </summary>
        public SynchronizedDictionary()
        {
            m_Dictionary = new Dictionary<TKey, TValue>();
        }

        /// <summary>
        /// Получает число элементов.
        /// </summary>
        /// <returns>
        /// Количество элементов.
        /// </returns>
        public int Count
        {
            get
            {
                return this.m_Dictionary.Count; 
            }
        }

        /// <summary>
        /// Возвращает значение, указывающее, является ли словарь открытым только на чтение.
        /// </summary>
        /// <returns>
        /// true, если только для чтения; в противном случае, false.
        /// </returns>
        public bool IsReadOnly
        {
            get
            {
                return this.m_Dictionary.IsReadOnly;
            }
        }

        /// <summary>
        /// Получает список ключей.
        /// </summary>
        /// <returns>
        /// Список ключей.
        /// </returns>
        public ICollection<TKey> Keys
        {
            get
            {
                return this.keys ?? (this.keys = this.m_Dictionary.Keys.Cast<TKey>().ToList());
            }
        }

        /// <summary>
        /// Получает список значений.
        /// </summary>
        /// <returns>
        /// Список значений.
        /// </returns>
        public ICollection<TValue> Values
        {
            get
            {
                return this.values ?? (this.values = this.m_Dictionary.Values.Cast<TValue>().ToList());
            }
        }

        /// <summary>
        /// Получает или задает элемент с указанным ключом.
        /// </summary>
        /// <returns>
        /// Элемент с указанным ключом.
        /// </returns>
        public TValue this[TKey key]
        {
            get
            {
                return (TValue)this.m_Dictionary[key];
            }

            set
            {
                lock (this.m_Dictionary)
                {
                    this.m_Dictionary[key] = value;
                }
            }
        }

        /// <summary>
        /// Возвращает перечислитель, осуществляющий перебор коллекции.
        /// </summary>
        /// <returns>
        /// Перечислятель, который может быть использован для перебора коллекции.
        /// </returns>
        public IEnumerator<KeyValuePair<TKey, TValue>> GetEnumerator()
        {
            return this.m_Dictionary.Cast<KeyValuePair<TKey, TValue>>().GetEnumerator();
        }

        /// <summary>
        /// Возвращает перечислитель, осуществляющий перебор коллекции.
        /// </summary>
        /// <returns>
        /// Объект, который может быть использован для перебора коллекции.
        /// </returns>
        IEnumerator IEnumerable.GetEnumerator()
        {
            return this.GetEnumerator();
        }

        /// <summary>
        /// Добавляет элемент.
        /// </summary>
        public void Add(KeyValuePair<TKey, TValue> item)
        {
            lock (this.m_Dictionary)
            {
                this.m_Dictionary.Add(item.Key, item.Value);
            }
        }

        /// <summary>
        /// Удаляет все элементы.
        /// </summary>
        public void Clear()
        {
            lock (this.m_Dictionary)
            {
                this.m_Dictionary.Clear();
            }
        }

        /// <summary>
        /// Определяет, содержит ли коллекция конкретное значение.
        /// </summary>
        /// <returns>
        /// true, если значение находится в коллекции; в противном случае, false.
        /// </returns>
        public bool Contains(KeyValuePair<TKey, TValue> item)
        {
            return this.m_Dictionary.Contains(item.Key) && EqualityComparer<TValue>.Default.Equals(this[item.Key], item.Value);
        }

        /// <summary>
        /// Копирует элементы в коллекцию, начиная с определенного индекса.
        /// </summary>
        public void CopyTo(KeyValuePair<TKey, TValue>[] array, int arrayIndex)
        {
            lock (this.m_Dictionary)
            {
                this.m_Dictionary.CopyTo(array, arrayIndex);
            }
        }

        /// <summary>
        /// Удаляет первое вхождение указанного объекта из коллекци
        /// </summary>
        /// <returns>
        /// true, если было успешно удалено иначе, false. Этот метод также возвращает false, если объект не найден в коллекции.
        /// </returns>
        public bool Remove(KeyValuePair<TKey, TValue> item)
        {
            lock (this.m_Dictionary)
            {
                if (this.Contains(item))
                {
                    this.m_Dictionary.Remove(item.Key);
                    return true;
                }

                return false;
            }
        }

        /// <summary>
        /// Определяет, содержит ли коллекция элемент с указанным ключом.
        /// </summary>
        /// <returns>
        /// true, если коллекция содержит элемент с ключом; в противном случае, false.
        /// </returns>
        public bool ContainsKey(TKey key)
        {
            return this.m_Dictionary.Contains(key);
        }

        /// <summary>
        /// Добавляет элемент с помощью заданного ключа и значения в коллекцию.
        /// </summary>
        public void Add(TKey key, TValue value)
        {
            lock (this.m_Dictionary)
            {
                this.m_Dictionary.Add(key, value);
            }
        }

        /// <summary>
        /// Удаляет элемент с указанным ключом из коллекции
        /// </summary>
        /// <returns>
        /// true, если элемент успешно удален из коллекции; в противном случае, false. Этот метод также возвращает false, если элемент не был найден в коллекции
        /// </returns>
        public bool Remove(TKey key)
        {
            lock (this.m_Dictionary)
            {
                if (this.ContainsKey(key))
                {
                    this.m_Dictionary.Remove(key);
                    return true;
                }

                return false;
            }   
        }

        /// <summary>
        /// Получает значение, связанное с указанным ключом.
        /// </summary>
        /// <returns>
        /// true, если объект, который реализует коллекцию содержит элемент с указанным ключом; в противном случае, false.
        /// </returns>
        public bool TryGetValue(TKey key, out TValue value)
        {
            if (typeof(TKey).IsValueType == false && key == null)
            {
                throw new ArgumentNullException("key");
            }

            if (this.ContainsKey(key))
            {
                value = this[key];
                return true;
            }

            value = default(TValue);
            return false;
        }
    }
}