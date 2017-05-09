using System;

namespace MDM.Models
{
    public partial class OBJECT
    {
        public long OBJECT_ID { get; set; }
        public long MAIN_OBJECT_ID { get; set; }
        public long CREATE_OBJECT_ID { get; set; }
        public Nullable<long> DELETE_OBJECT_ID { get; set; }
    }
}
