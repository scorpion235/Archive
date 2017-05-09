using System;
using System.Collections.Generic;

namespace MDM.Models
{
    public partial class OBJECT_ASSOCIATE
    {
        public long OBJECT_ID { get; set; }
        public long METAOBJECT_ID { get; set; }
        public long VERSION_METAOBJECT_ID { get; set; }
        public long CREATE_OBJECT_ASSOCIATE_ID { get; set; }
        public Nullable<long> DELETE_OBJECT_ASSOCIATE_ID { get; set; }
    }
}
