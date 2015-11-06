using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;

namespace EM_Report.Common.Logger
{
    public interface I_Logger
    {
        void Info(string strMessage);
        void Error(string strMessage);
        void Debug(string strMessage);
        void Warning(string strMessage);

        void Info(string strMessage, Exception ex);
        void Error(string strMessage, Exception ex);
        void Debug(string strMessage, Exception ex);
        void Warning(string strMessage, Exception ex);
    }

    public class Log4Net : I_Logger
    {
        private static ILog _logger;

        public ILog Logger
        {
            get { return _logger; }
            set { _logger = value; }
        }

        public Log4Net()
        {
            if (_logger == null)
                _logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        }

        public void Info(string strMessage)
        {
            _logger.Info(strMessage);
        }

        public void Error(string strMessage)
        {
            _logger.Error(strMessage);
        }

        public void Debug(string strMessage)
        {
            _logger.Debug(strMessage);
        }

        public void Warning(string strMessage)
        {
            _logger.Warn(strMessage);
        }

        public void Info(string strMessage, Exception ex)
        {
            _logger.Info(strMessage, ex);
        }

        public void Error(string strMessage, Exception ex)
        {
            _logger.Error(strMessage, ex);
        }

        public void Debug(string strMessage, Exception ex)
        {
            _logger.Debug(strMessage, ex);
        }

        public void Warning(string strMessage, Exception ex)
        {
            _logger.Warn(strMessage, ex);
        }
    }
}
