using System;
using System.Data;
using System.Linq;
using System.Data.SqlClient;
using System.Configuration;
using NUnit.Framework;
using MDM.Models;
using Dapper;
using Newtonsoft.Json;

namespace MDM.Tests
{
    class ODataHelperTest
    {
        private SqlConnection _connection;

        [SetUp]
        public void Init()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MDMContext"].ConnectionString;
            _connection = new SqlConnection(connectionString);
            _connection.Open();
        }

        [TearDown]
        public void Clean()
        {
            _connection.Close();
        }

        [Test]
        public void ODataHelperProcedureGetObjectsTest()
        {
            var table = new DataTable
            {
                Columns = 
                { 
                    { "ATTRIBUTE_CODE", typeof(string) },
                    { "UNIVERSAL_VALUE", typeof(string) }
                },
                Rows = 
                { 
                    { "1", "1" },
                    { "2", "2" },
                    { "3", "3" },
                } 
            };

            ODataHelper helper = new ODataHelper();
            IQueryable query = helper.GetObjects(_connection, table);
            string res = JsonConvert.SerializeObject(query);

            Assert.IsNotNull(res);
        }

        [Test]
        public void ODataHelperProcedureSetObjectsTest()
        {
            var table = new DataTable
            {
                Columns = 
                { 
                    { "OBJECT_ID", typeof(long) },
                    { "ATTRIBUTE_CODE", typeof(string) },
                    { "VALUE_SN", typeof(long) },
                    { "UNIVERSAL_VALUE", typeof(string) }
                }
                ,
                Rows = 
                { 
                    { 1, "1", 1, "1" },
                    { 2, "2", 2, "2" },
                    { 3, "3", 3, "3" },
                }
            };

            ODataHelper helper = new ODataHelper();
            IQueryable query = helper.SetObjects(_connection, table);
            string res = JsonConvert.SerializeObject(query);

            Assert.IsNotNull(res);
        }
    }
}