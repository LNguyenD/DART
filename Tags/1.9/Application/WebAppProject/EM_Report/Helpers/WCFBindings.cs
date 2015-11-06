using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel.Channels;
using System.Web;

namespace EM_Report.Helpers
{
    public class CustomHttpBinding : CustomBinding
    {
        private readonly bool _useHttps;
        private readonly HttpTransportBindingElement _transport;

        public long MaxMessageSize
        {
            set
            {
                _transport.MaxReceivedMessageSize = value;
                _transport.MaxBufferSize = (int)value;
                _transport.MaxBufferPoolSize = value;
            }
        }

        public CustomHttpBinding(bool useHttps)
        {
            _useHttps = useHttps;
            _transport = useHttps ? new HttpsTransportBindingElement() : new HttpTransportBindingElement();
        }

        public override BindingElementCollection CreateBindingElements()
        {
            var reliableSession = new ReliableSessionBindingElement();
       
            return new BindingElementCollection(new BindingElement[]
            {
                reliableSession,
                _transport,
            });
        }
    }
}