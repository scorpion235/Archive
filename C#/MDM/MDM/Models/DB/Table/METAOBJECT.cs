using System;
using System.Collections.Generic;

namespace MDM.Models
{
    public class METAOBJECT
    {
        public long METAOBJECT_ID { get; set; }
        public string CODE { get; set; }
        public string CCODE { get; set; }
        public string NAME { get; set; }
        public string DESCRIPT { get; set; }
        public Nullable<long> MAIN_METAOBJECT_ID { get; set; }
    }
}