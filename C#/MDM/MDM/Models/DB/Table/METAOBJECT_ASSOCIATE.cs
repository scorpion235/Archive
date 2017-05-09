namespace MDM.Models
{
    public partial class METAOBJECT_ASSOCIATE
    {
        public long MAIN_METAOBJECT_ID { get; set; }
        public long MAIN_VERSION_METAOBJECT_ID { get; set; }
        public long SUB_METAOBJECT_ID { get; set; }
        public long SUB_VERSION_METAOBJECT_ID { get; set; }
    }
}