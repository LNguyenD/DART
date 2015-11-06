using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Collections.Specialized;
using System.Web;
using Moq;
using System.Web.Routing;
using System.IO;
using System.Web.SessionState;

namespace EM_Report.Tests.Helpers
{
    public static class MvcMockHelpers
    {
        #region Mock for HttpContext.Current

        public static HttpContext FakeHttpContext()
        {
            var httpRequest = new HttpRequest("", "http://localhost/", "");
            var stringWriter = new StringWriter();
            var httpResponce = new HttpResponse(stringWriter);
            var httpContext = new HttpContext(httpRequest, httpResponce);

            var sessionContainer = new HttpSessionStateContainer("id", new SessionStateItemCollection(),
                                                    new HttpStaticObjectsCollection(), 10, true,
                                                    HttpCookieMode.AutoDetect,
                                                    SessionStateMode.InProc, false);

            SessionStateUtility.AddHttpSessionStateToContext(httpContext, sessionContainer);

            return httpContext;
        }

        #endregion
        
        #region Mock for ControllerContext

        public static Mock<ControllerContext> MockControllerContext(Mock<HttpRequestBase> requestMock)
        {
            var httpContextMock = new Mock<HttpContextBase>();
            httpContextMock.SetMockRequest(requestMock);

            var controllerContextMock = new Mock<ControllerContext>();
            controllerContextMock.SetMockHttpContext(httpContextMock);

            return controllerContextMock;
        }

        public static void SetMockHttpContext(this Mock<ControllerContext> controller, Mock<HttpContextBase> contextMock)
        {
            controller.SetupGet(c => c.HttpContext).Returns(contextMock.Object);
        }

        #endregion

        #region Mock for HttpContext

        public static void SetMockRequest(this Mock<HttpContextBase> httpContext, Mock<HttpRequestBase> requestMock)
        {
            httpContext.SetupGet(c => c.Request).Returns(requestMock.Object);
        }

        #endregion

        #region Mock for HttpRequest

        public static Mock<HttpRequestBase> MockAjaxRequest(this Mock<HttpRequestBase> request)
        {
            request.SetupGet(x => x.Headers).Returns(new NameValueCollection
                                                    {
                                                        {"X-Requested-With", "XMLHttpRequest"}
                                                    });

            return request;
        }

        public static Mock<HttpRequestBase> MockQueryStrings(this Mock<HttpRequestBase> request, NameValueCollection queryStrings = null)
        {
            if (queryStrings == null)
                queryStrings = new NameValueCollection();

            request.SetupGet(x => x.QueryString).Returns(queryStrings);

            return request;
        }

        public static Mock<HttpRequestBase> MockCookies(this Mock<HttpRequestBase> request, HttpCookieCollection cookies = null)
        {
            if (cookies == null)
                cookies = new HttpCookieCollection();

            request.SetupGet(x => x.Cookies).Returns(cookies);

            return request;
        }

        public static Mock<HttpRequestBase> MockFormData(this Mock<HttpRequestBase> request, NameValueCollection formData = null)
        {
            if (formData == null)
                formData = new NameValueCollection();

            request.SetupGet(x => x.Form).Returns(formData);

            return request;
        }

        #endregion

        static string GetUrlFileName(string url)
        {
            if (url.Contains("?"))
                return url.Substring(0, url.IndexOf("?"));
            else
                return url;
        }

        static NameValueCollection GetQueryStringParameters(string url)
        {
            if (url.Contains("?"))
            {
                NameValueCollection parameters = new NameValueCollection();

                string[] parts = url.Split("?".ToCharArray());
                string[] keys = parts[1].Split("&".ToCharArray());

                foreach (string key in keys)
                {
                    string[] part = key.Split("=".ToCharArray());
                    parameters.Add(part[0], part[1]);
                }

                return parameters;
            }
            else
            {
                return null;
            }
        }

        public static void SetHttpMethodResult(this HttpRequestBase request, string httpMethod)
        {
            Mock.Get(request)
                .Setup(req => req.HttpMethod)
                .Returns(httpMethod);
        }

        public static void SetupRequestUrl(this HttpRequestBase request, string url)
        {
            if (url == null)
                throw new ArgumentNullException("url");

            if (!url.StartsWith("~/"))
                throw new ArgumentException("Sorry, we expect a virtual url starting with \"~/\".");

            var mock = Mock.Get(request);

            mock.Setup(req => req.QueryString)
                .Returns(GetQueryStringParameters(url));
            mock.Setup(req => req.AppRelativeCurrentExecutionFilePath)
                .Returns(GetUrlFileName(url));
            mock.Setup(req => req.PathInfo)
                .Returns(string.Empty);
        }
    }
}
