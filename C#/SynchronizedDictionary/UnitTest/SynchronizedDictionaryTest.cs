using System;
using Synchronized;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SynchronizedDictionary
{
    [TestClass]
    public class SynchronizedDictionaryTest
    {
        [TestMethod]
        public void AddCurrentElements_Success()
        {
            var dic = new SynchronizedDictionary<int, string, string>();

            dic.Add(1, "Иванов", "value_1");
            dic.Add(2, "Иванов", "value_2");
            dic.Add(5, "Иванов", "value_3");
            dic.Add(5, "Петров", "value_4");

            Assert.AreEqual(4, dic.Count);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void AddExistsIdNameElementTest_HasArgumentOutOfRangeException()
        {
            var dic = new SynchronizedDictionary<int, string, string>();

            dic.Add(1, "Иванов", "value_1");
            dic.Add(1, "Иванов", "value_2");
        }

        [TestMethod]
        public void GetByNameElements_Success()
        {
            var dic = new SynchronizedDictionary<int, string, string>();

            dic.Add(1, "Иванов", "value_1");
            dic.Add(2, "Иванов", "value_2");
            dic.Add(5, "Иванов", "value_3");
            dic.Add(5, "Петров", "value_4");

            var elementsByName = dic.GetByName("Иванов");

            Assert.AreEqual(3, elementsByName.Count);
        }

        [TestMethod]
        public void GetByIdElements_Success()
        {
            var dic = new SynchronizedDictionary<int, string, string>();

            dic.Add(1, "Иванов", "value_1");
            dic.Add(2, "Иванов", "value_2");
            dic.Add(5, "Иванов", "value_3");
            dic.Add(5, "Петров", "value_4");

            var elementsById = dic.GetById(5);

            Assert.AreEqual(2, elementsById.Count);
        }

        [TestMethod]
        public void RemoveElements_Success()
        {
            var dic = new SynchronizedDictionary<int, string, string>();

            dic.Add(1, "Иванов", "value_1");
            dic.Add(2, "Иванов", "value_2");
            dic.Add(5, "Иванов", "value_3");
            dic.Add(5, "Петров", "value_4");

            dic.Remove(5, "Иванов");
            dic.Remove(5, "Петров");

            Assert.AreEqual(2, dic.Count);
        }
    }
}