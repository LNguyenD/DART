
using EM_Report.Helpers;
using EM_Report.Service.ServiceContracts;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.ServiceModel;
using System.Web;

namespace EM_Report.Repositories
{
    public abstract class RepositoryBase
    {
        private CustomHttpBinding _binding;
        private EndpointAddress _endpoint;
        private ChannelFactory<IActionService> _channelFactory;

        protected IClientChannel Client { get { return CreateWCFProxy(); } }

        protected RepositoryBase()
        {
            _binding = new CustomHttpBinding(true);
            _binding.MaxMessageSize = 2097152;
            _binding.CloseTimeout = TimeSpan.FromHours(24);
            _binding.OpenTimeout = TimeSpan.FromHours(24);
            _binding.ReceiveTimeout = TimeSpan.FromHours(24);
            _binding.SendTimeout = TimeSpan.FromHours(24);

            var address = ConfigurationManager.AppSettings["WCFEndpointAddress"];
            _endpoint = new EndpointAddress(address);
        }

        private IClientChannel CreateWCFProxy()
        {
            if(_channelFactory == null || _channelFactory.State == CommunicationState.Closed || _channelFactory.State == CommunicationState.Faulted)
            {
                _channelFactory = new ChannelFactory<IActionService>(_binding, _endpoint);
            }

            var pClient = _channelFactory.CreateChannel();
            return (IClientChannel)pClient;
        }
    }
}