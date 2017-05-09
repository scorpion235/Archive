namespace MDM.Models
{
    public partial class OBJECT_VALUES
    {
        /// <summary>
        /// идентификатор объекта (контрагента)
        /// </summary>
        public long OBJECT_ID { get; set; }

        /// <summary>
        /// код атрибута 
        /// </summary>
        public string ATTRIBUTE_CODE { get; set; }

        /// <summary>
        /// порядковый номер атрибута (при нескольких значениях атрибута)
        /// </summary>
        public long VALUE_SN { get; set; }

        /// <summary>
        /// значение атрибута
        /// </summary>
        public string UNIVERSAL_VALUE { get; set; }
    }
}