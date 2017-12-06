using System;
using System.Collections.Generic;

namespace JG_Prospect.Common.modal
{
    public enum ActionStatus
    {
        Successfull = 200,
        Error = 400,
        LoggedOut = 201,
        Unauthorized = 202
    }
    public class ActionOutputBase
    {
        public ActionStatus Status { get; set; }
        public String Message { get; set; }
        //public List<String> Results { get; set; }
    }

    public class ActionOutput<T> : ActionOutputBase
    {
        public T Object { get; set; }
        public List<T> Results { get; set; }
    }

    public class ActionOutput : ActionOutputBase
    {
        public long ID { get; set; }
    }

    public class PagingResultBase : ActionOutputBase
    {
        public long TotalResults { get; set; }
    }

    public class PagingResult<T> : PagingResultBase
    {
        public List<T> Data { get; set; }
    }
}
