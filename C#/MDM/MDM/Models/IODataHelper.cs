using System.Data;
using System.Linq;

namespace MDM.Models
{
    public interface IODataHelper
    {
        /// <summary>
        /// Получение списка контрагентов
        /// </summary>
        /// <param name="connection">SQL-подключение</param>
        /// <param name="table">Таблица со списком атрибутов и их значений (Type COM.ATTRIBUTE_VALUES). Поля: ATTRIBUTE_CODE, UNIVERSAL_VALUE</param>
        /// <returns>Таблица контрагентов (Type COM.OBJECT_VALUES). Поля: OBJECT_ID, ATTRIBUTE_CODE, VALUE_SN, UNIVERSAL_VALUE</returns>
        IQueryable<OBJECT_VALUES> GetObjects(IDbConnection connection, DataTable table);

        /// <summary>
        /// Добавление/обновление контрагента
        /// </summary>
        /// <param name="connection">SQL-подключение</param>
        /// <param name="table">Таблица данных контрагента (Type COM.OBJECT_VALUES). Поля: OBJECT_ID, ATTRIBUTE_CODE, VALUE_SN, UNIVERSAL_VALUE</param>
        /// <returns>Таблица идентификаторов контрагентов (Type COM.ID). Поля: ID</returns>
        IQueryable<ID_TAB> SetObjects(IDbConnection connection, DataTable table);
    }
}