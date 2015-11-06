using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using System.Web.Services;
using EM_Report.EMReports.UserControls;
using System.Text;
using EM_Report.BLL.Services;
using EM_Report.Models.RS2005;

namespace EM_Report.EMReports.Popup
{
    public partial class Schedule : System.Web.UI.Page
    {
        I_ScheduleService _scdService = new ScheduleService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ScheduleDefinition scdDef = null;
                if (Request.QueryString["id"] != null)
                {
                    scdDef = _scdService.Get(Request.QueryString["id"].ToString()).Definition;
                }
                else
                {
                    scdDef = Application["DefaultSchedule"] as ScheduleDefinition;
                }

                // show start time
                ctStartTime.Hour = (scdDef.StartDateTime.Hour > 12 && scdDef.StartDateTime.Hour <= 23) ? scdDef.StartDateTime.Hour - 12 : scdDef.StartDateTime.Hour;
                ctStartTime.Minute = scdDef.StartDateTime.Minute;
                ctStartTime.Segment = scdDef.StartDateTime.ToString().IndexOf("AM") >= 0 ? CustomTime.DaySegment.AM : CustomTime.DaySegment.PM;
                // show start date, end date
                txtStartDate.Text = scdDef.StartDateTime.ToShortDateString();
                chbEndDate.Checked = scdDef.EndDateSpecified;
                txtEndDate.Text = chbEndDate.Checked ? scdDef.EndDate.ToShortDateString() : string.Empty;

                if (scdDef.Item != null)
                {
                    switch (scdDef.Item.GetType().Name)
                    {
                        case "MinuteRecurrence":
                            MinuteRecurrence minuteRec = (MinuteRecurrence)scdDef.Item;
                            rblTimes.SelectedIndex = 0;
                            txtHH.Value = (minuteRec.MinutesInterval / 60).ToString();
                            txtHM.Value = (minuteRec.MinutesInterval % 60).ToString();
                            break;
                        case "DailyRecurrence":
                            DailyRecurrence dailyRec = (DailyRecurrence)scdDef.Item;
                            rblTimes.SelectedIndex = 1;
                            radDayRepeat.Checked = true;
                            txtDayRepeat.Text = dailyRec.DaysInterval.ToString();
                            break;
                        case "WeeklyRecurrence":
                            WeeklyRecurrence weeklyRec = (WeeklyRecurrence)scdDef.Item;
                            if (weeklyRec.WeeksInterval == 1)
                            {
                                rblTimes.SelectedIndex = 1;
                                radDayDays.Checked = true;
                                this.SetDayOfWeekSelector(weeklyRec.DaysOfWeek, cblDayDays);
                            }
                            else
                            {
                                rblTimes.SelectedIndex = 2;
                                radDayRepeat.Checked = true;
                                txtReapeatWeek.Text = weeklyRec.WeeksInterval.ToString();
                                this.SetDayOfWeekSelector(weeklyRec.DaysOfWeek, cblWeekDays);
                            }
                            break;
                        case "MonthlyDOWRecurrence":
                            MonthlyDOWRecurrence monthlyDOWRec = (MonthlyDOWRecurrence)scdDef.Item;
                            rblTimes.SelectedIndex = 3;
                            radWOM.Checked = true;
                            this.SetWeekOfMonth(monthlyDOWRec.WhichWeek, drlWOM);
                            this.SetDayOfWeekSelector(monthlyDOWRec.DaysOfWeek, cblMonthDays);
                            this.SetMonthOfYear(monthlyDOWRec.MonthsOfYear, cblMonthsOfYear);
                            break;
                        case "MonthlyRecurrent":
                            MonthlyRecurrence monthlyRec = new MonthlyRecurrence();
                            rblTimes.SelectedIndex = 3;
                            radOnCalDays.Checked = true;
                            txtOnCalDays.Text = monthlyRec.Days;
                            this.SetMonthOfYear(monthlyRec.MonthsOfYear, cblMonthsOfYear);
                            break;
                    }
                }
                else
                {
                    rblTimes.SelectedIndex = 4;
                }
                RadioButtonList1_SelectedIndexChanged(rblTimes, new EventArgs());
            }
        }

        protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            mvwSchedule.ActiveViewIndex = rblTimes.SelectedIndex;
        }


        protected void btnOK_Click(object sender, EventArgs e)
        {
            SetScheduleFromUI();

            StringBuilder script = new StringBuilder();
            script.Append("<script type=\"text/javascript\">");
            script.Append("window.close();");
            script.Append("</script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(object), "JavaScriptBlock", script.ToString());
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            // Response.Redirect("Subscription.aspx");
        }

        private void SetScheduleFromUI()
        {
            ScheduleDefinition schedule = new ScheduleDefinition();
            schedule.StartDateTime = DateTime.Parse(txtStartDate.Text);
            schedule.EndDate = txtEndDate.Text != string.Empty ? DateTime.Parse(txtEndDate.Text) : DateTime.MaxValue;
            schedule.EndDateSpecified = chbEndDate.Checked;
            schedule.Item = GetPattern();
            Session["ScheduleDefinition"] = schedule;
        }

        private RecurrencePattern GetPattern()
        {
            switch (rblTimes.SelectedIndex)
            {
                case 0: return GetHourlyPattern();
                case 1: return GetDailyPattern();
                case 2: return GetWeeklyPattern();
                case 3: return GetMonthlyPattern();
            }
            return null;
        }

        private RecurrencePattern GetHourlyPattern()
        {
            MinuteRecurrence minuteRec = null;
            if (rblTimes.SelectedIndex == 0)
            {
                minuteRec = new MinuteRecurrence();
                minuteRec.MinutesInterval = 0;
                minuteRec.MinutesInterval += txtHH.Value != string.Empty ? int.Parse(txtHH.Value) * 60 : 0;
                minuteRec.MinutesInterval += txtHM.Value != string.Empty ? int.Parse(txtHM.Value) : 0;
            }
            return minuteRec;
        }

        private RecurrencePattern GetDailyPattern()
        {
            if (rblTimes.SelectedIndex == 1)
            {
                if (radDayDays.Checked)
                {
                    WeeklyRecurrence weekRec = new WeeklyRecurrence();
                    weekRec.DaysOfWeek = GetDayOfWeekSelector(cblDayDays);
                    weekRec.WeeksIntervalSpecified = true;
                    weekRec.WeeksInterval = 1;
                    return weekRec;
                }
                //else if (radEveryWeekDay.Checked)
                //{
                //    WeeklyRecurrence weekRec = new WeeklyRecurrence();
                //    weekRec.DaysOfWeek.Sunday = true;
                //    weekRec.DaysOfWeek.Monday = true;
                //    weekRec.DaysOfWeek.Tuesday = true;
                //    weekRec.DaysOfWeek.Wednesday = true;
                //    weekRec.DaysOfWeek.Thursday = true;
                //    weekRec.DaysOfWeek.Friday = true;
                //    weekRec.DaysOfWeek.Saturday = true;
                //    return weekRec;
                //}
                else if (radDayRepeat.Checked)
                {
                    DailyRecurrence dailyRec = new DailyRecurrence();
                    dailyRec.DaysInterval = txtDayRepeat.Text != string.Empty ? int.Parse(txtDayRepeat.Text) : 0;
                    return dailyRec;
                }
            }
            return null;
        }

        private RecurrencePattern GetWeeklyPattern()
        {
            if (rblTimes.SelectedIndex == 2)
            {
                WeeklyRecurrence weeklyRec = new WeeklyRecurrence();
                weeklyRec.WeeksInterval = int.Parse(txtReapeatWeek.Text);
                weeklyRec.WeeksIntervalSpecified = true;
                weeklyRec.DaysOfWeek = GetDayOfWeekSelector(cblWeekDays);
                return weeklyRec;
            }
            return null;
        }

        private RecurrencePattern GetMonthlyPattern()
        {
            if (radWOM.Checked)
            {
                MonthlyDOWRecurrence monthlyDOWRec = new MonthlyDOWRecurrence();
                monthlyDOWRec.MonthsOfYear = this.GetMonthOfYear(cblMonthsOfYear);
                monthlyDOWRec.WhichWeek = this.GetWeekOfMonth(drlWOM);
                monthlyDOWRec.WhichWeekSpecified = true;
                monthlyDOWRec.DaysOfWeek = this.GetDayOfWeekSelector(cblMonthDays);
                return monthlyDOWRec;
            }
            else if (radOnCalDays.Checked)
            {
                MonthlyRecurrence monthlyRec = new MonthlyRecurrence();
                monthlyRec.MonthsOfYear = this.GetMonthOfYear(cblMonthsOfYear);
                monthlyRec.Days = txtOnCalDays.Text;
                return monthlyRec;
            }
            return null;
        }

        private DaysOfWeekSelector GetDayOfWeekSelector(CheckBoxList cblDayOfWeek)
        {
            DaysOfWeekSelector dayOfWeek = new DaysOfWeekSelector();
            int i = 0;
            foreach (ListItem cb in cblDayOfWeek.Items)
            {
                if (cb.Selected)
                {
                    switch (i)
                    {
                        case 0: dayOfWeek.Sunday = true; break;
                        case 1: dayOfWeek.Monday = true; break;
                        case 2: dayOfWeek.Tuesday = true; break;
                        case 3: dayOfWeek.Wednesday = true; break;
                        case 4: dayOfWeek.Thursday = true; break;
                        case 5: dayOfWeek.Friday = true; break;
                        case 6: dayOfWeek.Saturday = true; break;
                    }
                }
                i++;
            }
            return dayOfWeek;
        }
       
        private void SetDayOfWeekSelector(DaysOfWeekSelector dayOfWeek, CheckBoxList cblDays)
        {
            cblDays.Items[0].Selected = dayOfWeek.Sunday;
            cblDays.Items[1].Selected = dayOfWeek.Monday;
            cblDays.Items[2].Selected = dayOfWeek.Tuesday;
            cblDays.Items[3].Selected = dayOfWeek.Wednesday;
            cblDays.Items[4].Selected = dayOfWeek.Thursday;
            cblDays.Items[5].Selected = dayOfWeek.Friday;
            cblDays.Items[6].Selected = dayOfWeek.Saturday;
        }

        private WeekNumberEnum GetWeekOfMonth(DropDownList drlWeekOfMonth)
        {
            switch (drlWeekOfMonth.SelectedIndex)
            {
                case 0: return WeekNumberEnum.FirstWeek;
                case 1: return WeekNumberEnum.SecondWeek;
                case 2: return WeekNumberEnum.ThirdWeek;
                case 3: return WeekNumberEnum.FourthWeek;
                case 4: return WeekNumberEnum.LastWeek;
            }
            return WeekNumberEnum.FirstWeek;
        }

        private void SetWeekOfMonth(WeekNumberEnum weekOfMonth, DropDownList drlWeekOfMonth)
        {
            switch (weekOfMonth)
            {
                case WeekNumberEnum.FirstWeek: drlWeekOfMonth.SelectedIndex = 0; break;
                case WeekNumberEnum.SecondWeek: drlWeekOfMonth.SelectedIndex = 1; break;
                case WeekNumberEnum.ThirdWeek: drlWeekOfMonth.SelectedIndex = 2; break;
                case WeekNumberEnum.FourthWeek: drlWeekOfMonth.SelectedIndex = 3; break;
                case WeekNumberEnum.LastWeek: drlWeekOfMonth.SelectedIndex = 4; break;
            }
        }

        private MonthsOfYearSelector GetMonthOfYear(CheckBoxList cblMOY)
        {
            MonthsOfYearSelector moySelector = new MonthsOfYearSelector();
            moySelector.January = cblMOY.Items[0].Selected;
            moySelector.January = cblMOY.Items[1].Selected;
            moySelector.January = cblMOY.Items[2].Selected;
            moySelector.January = cblMOY.Items[3].Selected;
            moySelector.January = cblMOY.Items[4].Selected;
            moySelector.January = cblMOY.Items[5].Selected;
            moySelector.January = cblMOY.Items[6].Selected;
            moySelector.January = cblMOY.Items[7].Selected;
            moySelector.January = cblMOY.Items[8].Selected;
            moySelector.January = cblMOY.Items[9].Selected;
            moySelector.January = cblMOY.Items[10].Selected;
            moySelector.January = cblMOY.Items[11].Selected;
            return moySelector;
        }

        private void SetMonthOfYear(MonthsOfYearSelector moySelector, CheckBoxList cblMOY)
        {
            cblMOY.Items[0].Selected = moySelector.January;
            cblMOY.Items[1].Selected = moySelector.February;
            cblMOY.Items[2].Selected = moySelector.March;
            cblMOY.Items[3].Selected = moySelector.April;
            cblMOY.Items[4].Selected = moySelector.May;
            cblMOY.Items[5].Selected = moySelector.June;
            cblMOY.Items[6].Selected = moySelector.July;
            cblMOY.Items[7].Selected = moySelector.August;
            cblMOY.Items[8].Selected = moySelector.September;
            cblMOY.Items[9].Selected = moySelector.October;
            cblMOY.Items[10].Selected = moySelector.November;
            cblMOY.Items[11].Selected = moySelector.December;
        }

        public XmlDocument GetScheduleAsXml(ScheduleDefinition schedule)
        {
            MemoryStream buffer = new MemoryStream();
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(ScheduleDefinition));
            xmlSerializer.Serialize(buffer, schedule);
            buffer.Seek(0, SeekOrigin.Begin);

            XmlDocument doc = new XmlDocument();
            doc.Load(buffer);
            // patch up WhichWeek
            XmlNamespaceManager ns = new XmlNamespaceManager(doc.NameTable);
            ns.AddNamespace("rs",
                    "http://schemas.microsoft.com/sqlserver/2003/12/reporting/reportingservices");

            XmlNode node =
                doc.SelectSingleNode(
                     "/ScheduleDefinition/rs:MonthlyDOWRecurrence/rs:WhichWeek", ns
                );
            if (node != null)
            {
                switch (node.InnerXml)
                {
                    case "FirstWeek":
                        node.InnerXml = "FIRST_WEEK"; break;
                    case "SecondWeek":
                        node.InnerXml = "SECOND_WEEK"; break;
                    case "ThirdWeek":
                        node.InnerXml = "THIRD_WEEK"; break;
                    case "FourthWeek":
                        node.InnerXml = "FOURTH_WEEK"; break;
                    case "LastWeek":
                        node.InnerXml = "LAST_WEEK"; break;
                }
            }

            return doc;
        }
    }
}