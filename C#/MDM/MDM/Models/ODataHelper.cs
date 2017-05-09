using System;
using System.Data;
using System.Linq;
using System.Data.SqlClient;
using MDM.Models;
using Dapper;

namespace MDM.Models
{
    public class ODataHelper : IODataHelper
    {
        /// <summary>
        /// Проверка корректности структуры таблицы для вызова хранимой процедуры GetObjects
        /// </summary>
        /// <param name="table">Таблица входных параметров</param>
        /// <returns>Возвращает true в случае корректной структуры таблицы</returns>
        private bool CheckGetObjectsTable(DataTable table)
        {
            ProcedureInputParam.ATTRIBUTE_VALUESDataTable etalonTable = new ProcedureInputParam.ATTRIBUTE_VALUESDataTable();

            if (table.Columns.Count != etalonTable.Columns.Count)
            {
                return false;
            }

            for (int i = 0; i < table.Columns.Count; i++)
            {
                string colName = table.Columns[i].ColumnName;
                Type colType = table.Columns[i].DataType;
                bool findColumn = false;

                for (int j = 0; j < etalonTable.Columns.Count; j++)
                {
                    if (String.Equals(colName.Trim(), etalonTable.Columns[j].ColumnName.Trim()) && Type.Equals(colType, etalonTable.Columns[j].DataType))
                    {
                        findColumn = true;
                        continue;
                    }
                }

                if (!findColumn)
                {
                    return false;
                }
            }

            return true;
        }

        /// <summary>
        /// Проверка корректности структуры таблицы для вызова хранимой процедуры SetObjects
        /// </summary>
        /// <param name="table">Таблица входных параметров</param>
        /// <returns>Возвращает true в случае корректной структуры таблицы</returns>
        private bool CheckSetObjectsTable(DataTable table)
        {
            ProcedureInputParam.OBJECT_VALUESDataTable etalonTable = new ProcedureInputParam.OBJECT_VALUESDataTable();

            if (table.Columns.Count != etalonTable.Columns.Count)
            {
                return false;
            }

            for (int i = 0; i < table.Columns.Count; i++)
            {
                string colName = table.Columns[i].ColumnName;
                Type colType = table.Columns[i].DataType;
                bool findColumn = false;

                for (int j = 0; j < etalonTable.Columns.Count; j++)
                {
                    if (String.Equals(colName.Trim(), etalonTable.Columns[j].ColumnName.Trim()) && Type.Equals(colType, etalonTable.Columns[j].DataType))
                    {
                        findColumn = true;
                        continue;
                    }
                }

                if (!findColumn)
                {
                    return false;
                }
            }

            return true;
        }

        /// <summary>
        /// Получение списка контрагентов
        /// </summary>
        /// <param name="connection">SQL-подключение</param>
        /// <param name="table">Таблица со списком атрибутов и их значений (Type COM.ATTRIBUTE_VALUES). Поля: ATTRIBUTE_CODE, UNIVERSAL_VALUE</param>
        /// <returns>Таблица контрагентов (Type COM.OBJECT_VALUES). Поля: OBJECT_ID, ATTRIBUTE_CODE, VALUE_SN, UNIVERSAL_VALUE</returns>
        public IQueryable<OBJECT_VALUES> GetObjects(IDbConnection connection, DataTable table)
        {
            if (connection.State == ConnectionState.Closed)
            {
                throw new Exception("Подключение закрыто");
            }

            if (table.Rows.Count == 0)
            {
                throw new Exception("Таблица входящих параметров пуста");
            }

            if (!CheckGetObjectsTable(table))
            {
                throw new Exception("Таблица входящих параметров имеет некорректную структуру");
            }

            return connection.Query<OBJECT_VALUES>
            (
                "API.CDI_GET_OBJECTS",
                new { ATTRIBUTE_VALUES = table.AsTableValuedParameter() },
                commandType: CommandType.StoredProcedure
            )
            .AsQueryable();
        }

        /// <summary>
        /// Добавление/обновление контрагента
        /// </summary>
        /// <param name="connection">SQL-подключение</param>
        /// <param name="table">Таблица данных контрагента (Type COM.OBJECT_VALUES). Поля: OBJECT_ID, ATTRIBUTE_CODE, VALUE_SN, UNIVERSAL_VALUE</param>
        /// <returns>Таблица идентификаторов контрагентов (Type COM.ID). Поля: ID</returns>
        public IQueryable<ID_TAB> SetObjects(IDbConnection connection, DataTable table)
        {
            if (connection.State == ConnectionState.Closed)
            {
                throw new Exception("Подключение закрыто");
            }

            if (table.Rows.Count == 0)
            {
                throw new Exception("Таблица входящих параметров пуста");
            }

            if (!CheckSetObjectsTable(table))
            {
                throw new Exception("Таблица входящих параметров имеет некорректную структуру");
            }

            return connection.Query<ID_TAB>
            (
                "API.CDI_SET_OBJECTS",
                new { OBJECT_VALUES = table.AsTableValuedParameter() },
                commandType: CommandType.StoredProcedure
            )
            .AsQueryable();
        }
    }
}