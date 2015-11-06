using System.Text;
using System.Web;
using System.Configuration;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Resources;
using EM_Report.BLL.Services;

namespace EM_Report.Helpers
{
    public class LeftNavigationReportHelper
    {        
        public LeftNavigationReportHelper()
        {
        }        

        public static string GetLeftNavigationReport()
        {
            I_ReportService qReportService = new ReportService(null);
            StringBuilder strMenu = new StringBuilder();
            if (HttpContext.Current.Session["LeftNavigationReportSession"] == null)
            {
                strMenu.Append("<div  class='leftnavigation_clearfix'>");
                strMenu.Append("<aside>");
                strMenu.Append("<nav>");
                strMenu.Append("<ul id='leftnavigation_menu'>");
                //Display categories
                var objCategories = Base.LoginSession.objCategories;
                
                strMenu.Append("<li>");
                strMenu.Append("<a class='expandable expanded'>Report categories <span>(" + objCategories.Count() + ")</span></a>");
                strMenu.Append("<ul>");
                
                if (!objCategories.IsNullOrEmpty())
                {                        
                    int i = 1;
                    foreach (var item in  objCategories)
                    {
                        strMenu.Append("<li  title='" + item.Name + "' " + (i <= Base.GetIntByConfigKey("Top_Category") ? "" : "class='leaf_none'") + "><a href='" + VirtualPathUtility.ToAbsolute("~/report?cId=" + item.CategoryId + "") + "'>" + Base.GetStringByMaxLength(Base.GetIntByConfigKey("LeftNavigation_MaxLength"), item.Name) + " <span> (" + qReportService.CountReportByCategoryUserCanAccess(Base.LoginSession.intUserId, item.CategoryId) + ")</span></a></li>");
                        i++;
                    }
                    if (objCategories.Count() >  Base.GetIntByConfigKey("Top_Category"))
                    {                            
                        strMenu.Append("<li class='leaf_more'><a>More...</a></li>"); 
                    }                                            
                }
                strMenu.Append("</ul>");
                strMenu.Append("</li>");   
                    
                //Display favorite report
                var objFavoriteReport = Base.LoginSession.objFavoriteReports;
                    
                strMenu.Append("<li>");
                strMenu.Append("<a class='expandable expanded'>Favorite reports <span>(" + objFavoriteReport.Count() + ")</span></a>");
                strMenu.Append("<ul>");
                
                if (!objFavoriteReport.IsNullOrEmpty())
                {                        
                    int i = 1;
                    foreach (var item in objFavoriteReport)
                    {
                        strMenu.Append("<li title='" + item.Name + "' " + (i <= Base.GetIntByConfigKey("Top_Favorite") ? "" : "class='leaf_none'") + "><a href='" + VirtualPathUtility.ToAbsolute("~/report/viewinfo?reportpath=" + item.UrlFullPath + "&rId" + item.ReportId + "") + "'>" + Base.GetStringByMaxLength(Base.GetIntByConfigKey("LeftNavigation_MaxLength"), item.Name) + "</a></li>");
                        i++;
                    }
                    if (objFavoriteReport.Count() > Base.GetIntByConfigKey("Top_Favorite"))
                    {
                        strMenu.Append("<li class='leaf_more'><a>More...</a></li>");
                    }                        
                }
                strMenu.Append("</ul>");
                strMenu.Append("</li>");   
                
                //Display recently report
                var objRecentlyReport = Base.LoginSession.objRecentlyReports;
                    
                strMenu.Append("<li>");
                strMenu.Append("<a class='expandable expanded'>Recently reports <span>(" + objRecentlyReport.Count() + ")</span></a>");
                strMenu.Append("<ul>");
                    
                if (!objRecentlyReport.IsNullOrEmpty())
                {                       
                    int i = 1;
                    foreach (var item in objRecentlyReport)
                    {
                        strMenu.Append("<li title='" + item.Name + "' " + (i <= Base.GetIntByConfigKey("Top_Recently") ? "" : "class='leaf_none'") + "><a href='" + VirtualPathUtility.ToAbsolute("~/report/viewinfo?reportpath=" + item.UrlFullPath + "&rId" + item.ReportId + "") + "'>" + Base.GetStringByMaxLength(Base.GetIntByConfigKey("LeftNavigation_MaxLength"), item.Name) + "</a></li>");
                        i++;
                    }
                    if (objRecentlyReport.Count() > Base.GetIntByConfigKey("Top_Recently"))
                    {
                        strMenu.Append("<li class='leaf_more'><a>More...</a></li>");
                    }                        
                }
                strMenu.Append("</ul>");
                strMenu.Append("</li>");
                
                strMenu.Append("</ul>");
                strMenu.Append("</nav>");
                strMenu.Append("</aside>");
                strMenu.Append("</div>");
                HttpContext.Current.Session["LeftNavigationReportSession"] = strMenu;
            }            
           
            return HttpContext.Current.Session["LeftNavigationReportSession"].ToString();           
        }
    }
}
