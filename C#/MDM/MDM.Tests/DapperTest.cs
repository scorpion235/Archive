using System;
using System.Data;
using System.Linq;
using System.Data.SqlClient;
using System.Configuration;
using NUnit.Framework;
using MDM.Models;
using Dapper;
using SqlMapper;

namespace MDM.Tests
{
    [TestFixture]
    public class SendDataTaskTest
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
        public void MetaobjectSelectCodeNameTest()
        {
            var metaobject = _connection.Query<METAOBJECT>
            (
                @"SELECT CODE = @CODE, 
                         NAME = @NAME", 
                new { CODE = "Role", NAME = "Роль" }
            );

            metaobject.Count().IsEqualTo(1);
            metaobject.First().CODE.IsEqualTo("Role");
            metaobject.First().NAME.IsEqualTo("Роль");
        }

        [Test]
        public void MetaobjectSelectAllFieldsTest()
        {
            var rows = _connection.Query
            (
                @"SELECT METAOBJECT_ID,
                         CODE,
                         CCODE,
                         NAME,
                         DESCRIPT,
                         MAIN_METAOBJECT_ID
                    FROM METAOBJECT"
            ).ToList();

            ((long)rows[0].METAOBJECT_ID).IsEqualTo(-1212);
            ((int)rows[0].MAIN_METAOBJECT_ID).IsEqualTo(-121);
        }

        [Test]
        public void MultipleResultsTest()
        {
            var sql = @"SELECT CODE FROM METAOBJECT WHERE METAOBJECT_ID = @id1
                        SELECT CODE FROM METAOBJECT WHERE METAOBJECT_ID = @id2";

            using (var multi = _connection.QueryMultiple(sql, new { id1 = -1212, id2 = -1211 }))
            {
                var metaobject1 = multi.Read<METAOBJECT>().ToList();
                var metaobject2 = multi.Read<METAOBJECT>().ToList();

                Assert.IsNotEmpty(metaobject1);
                Assert.IsNotEmpty(metaobject2);
            }
        }

        [Test]
        public void ExecStoreProcedureMetGetObjectTreeTest()
        {
            var rows = _connection.Query
            (
                "DEV.MET_GET_OBJECT_TREE", 
                null, 
                commandType: CommandType.StoredProcedure
            )
            .ToList();

           rows.Count.IsEqualTo(15);
        }

        [Test]
        public void MetaobjectWhereSelectAllFieldsTest()
        {
            var rows = _connection.Query<METAOBJECT>
            (
                @"SELECT METAOBJECT_ID,
                         CODE,
                         CCODE,
                         NAME,
                         DESCRIPT,
                         MAIN_METAOBJECT_ID
                    FROM METAOBJECT
                   WHERE METAOBJECT_ID = @METAOBJECT_ID", 
                new { METAOBJECT_ID = new[] { -1 } }
            )
            .ToList();

            ((long)rows[0].METAOBJECT_ID).IsEqualTo(-1);
        }

        [Test]
        public void ProcedureGetObjectsTest()
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

            var rows = _connection.Query<OBJECT_VALUES>
            (
                "API.CDI_GET_OBJECTS", 
                new { ATTRIBUTE_VALUES = table.AsTableValuedParameter() }, 
                commandType: CommandType.StoredProcedure
            )
            .ToList();

            rows.Count.IsEqualTo(3);
        }

        [Test]
        public void ProcedureSetObjectsTest()
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

            var rows = _connection.Query<ID_TAB>
            (
                "API.CDI_SET_OBJECTS",
                new { OBJECT_VALUES = table.AsTableValuedParameter() },
                commandType: CommandType.StoredProcedure
            )
            .ToList();

            rows.Count.IsEqualTo(3);
        }
    }
}