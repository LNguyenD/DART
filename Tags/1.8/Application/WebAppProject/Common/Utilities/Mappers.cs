using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Linq;
using System.Web;
using EM_Report.Common.Utilities;
using Microsoft.Reporting.WebForms;
using System.Net;
using System.Xml;
using System.Data;
using System.Globalization;
using System.Security.Cryptography.X509Certificates;
using AutoMapper;

namespace EM_Report.Common.Utilities
{
    public class Mappers
    {        
        ///Using of two types as parameters
        public static TReturn MapTo<TInput, TReturn>(TInput model)
        {
            Mapper.CreateMap<TInput, TReturn>();
            return Mapper.Map<TInput, TReturn>(model);
        }

        ///Using of two types as parameters
        public static List<TReturn> MapTo<TInput, TReturn>(List<TInput> LTInput)
        {
            Mapper.CreateMap<TInput, TReturn>();
            return Mapper.Map<List<TInput>, List<TReturn>>(LTInput);
        }

        ///Using of two types as parameters
        public static IList<TReturn> MapTo<TInput, TReturn>(IList<TInput> LTInput)
        {
            Mapper.CreateMap<TInput, TReturn>();
            return Mapper.Map<IList<TInput>, IList<TReturn>>(LTInput);
        }
    }
}