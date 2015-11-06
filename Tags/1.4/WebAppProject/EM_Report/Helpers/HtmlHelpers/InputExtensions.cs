using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using System.Web.Routing;

namespace EM_Report.Helpers
{
    public static class InputExtensions
    {
        public static MvcHtmlString CheckBoxListDropDown(this HtmlHelper htmlHelper, string name, IEnumerable<SelectListItem> listInfo)
        {
            return htmlHelper.CheckBoxListDropDown(name, listInfo,
                ((IDictionary<string, object>) null));
        }

        public static MvcHtmlString CheckBoxListDropDown(this HtmlHelper htmlHelper, string name, IEnumerable<SelectListItem> listInfo,
           object htmlAttributes)
       {
           return htmlHelper.CheckBoxListDropDown(name, listInfo, 
               ((IDictionary<string, object>)new RouteValueDictionary(htmlAttributes)));
       }

        public static MvcHtmlString CheckBoxListDropDown(this HtmlHelper htmlHelper, string name, IEnumerable<SelectListItem> listInfo,
           IDictionary<string, object> htmlAttributes)
        {
            if (String.IsNullOrEmpty(name))
                throw new ArgumentException("The argument must have a value", "name");
            StringBuilder sb = new StringBuilder();
            TagBuilder selectTag = new TagBuilder("select");
            selectTag.MergeAttributes<string, object>(htmlAttributes);
            selectTag.MergeAttribute("id", name);
            selectTag.MergeAttribute("name", name);
            selectTag.MergeAttribute("multiple", "multiple");

            foreach (SelectListItem info in listInfo)
            {
                TagBuilder option = new TagBuilder("option");
                if (info.Selected)
                    option.MergeAttribute("selected", "true");
                option.MergeAttribute("value", info.Value);
                option.SetInnerText(info.Text);
                sb.Append(option.ToString(TagRenderMode.Normal));
            }
            selectTag.InnerHtml = sb.ToString();
            MvcHtmlString mvcStr = new MvcHtmlString(selectTag.ToString(TagRenderMode.Normal));
            return mvcStr;
        }

        public static MvcHtmlString RadioButtonListFor<TModel, TProperty>(
            this HtmlHelper<TModel> htmlHelper,
            Expression<Func<TModel, TProperty>> expression,
            IEnumerable<SelectListItem> listOfValues)
        {
            var metaData = ModelMetadata.FromLambdaExpression(expression, htmlHelper.ViewData);
            var sb = new StringBuilder();

            if (listOfValues != null)
            {
                // Create a radio button for each item in the list 
                foreach (SelectListItem item in listOfValues)
                {
                    // Generate an id to be given to the radio button field 
                    var id = string.Format("{0}_{1}", metaData.PropertyName, item.Value);

                    // Create and populate a radio button using the existing html helpers 
                    var label = htmlHelper.Label(id, HttpUtility.HtmlEncode(item.Text));
                    var radio = htmlHelper.RadioButtonFor(expression, item.Value, new { id = id }).ToHtmlString();

                    // Create the html string that will be returned to the client 
                    // e.g. <input data-val="true" data-val-required="You must select an option" id="TestRadio_1" name="TestRadio" type="radio" value="1" /><label for="TestRadio_1">Line1</label> 
                    sb.AppendFormat("<div class=\"RadioButton\">{0}{1}</div>", radio, label);
                }
            }

            return MvcHtmlString.Create(sb.ToString());
        } 
    }

}