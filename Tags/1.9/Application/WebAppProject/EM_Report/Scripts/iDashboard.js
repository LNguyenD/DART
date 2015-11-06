/*
    THIS FILE CONTAINS COMMON DASHBOARD METHODS USED INSIDE IFRAME ONLY
              PROVIDES STRUCTURE FOR DASHBOARD CODE
    
    New dashboard using iDashboard.js have to implement several concrete methods - refer to CONCRETE section of aspx file
*/

$(document).ready(function () {

        // detect report lost session problem
        var htmlContent = $("div[id='divViewer']").html();
        var uSess = '<%=EM_Report.Helpers.Base.LoginSession %>';
        if (htmlContent.indexOf('attempt to connect to the report server failed') >= 0 || uSess == "") {
            //parent.window.location = parent.window.g_baseUrl + '/account/login?logout=true&ssrs=lost';

            var returnUrl = document.referrer;
            parent.window.location = parent.window.g_baseUrl + '/account/login?returnUrl=' + encodeURIComponent(returnUrl);
        }
});

// ========== ADJUST LAYOUT ==========
var IFRAME_LOADING_DIV_HEIGHT = 78;

function viewerPropertyChanged(sender, e) {
    if (e.get_propertyName() == "isLoading") {
        adjustReport();
        doAdditionalWorks();
        adjustLayout();
        ShowHideBrokerGraph();
        RemoveTitle();
    }
}

function ShowHideBrokerGraph() {

    // Check current tab and hide graph of broker
    if (document.URL.toLowerCase().indexOf('eml') >= 1) {
        var currentTabType = parent.getCurrentTabType();
        if (currentTabType != "broker") {                       

            // adjust broker element
            $('#ifReport_Agency', window.parent.document).contents().find("td[alt='broker_title_graph_view_0']").closest('table').closest('td').css('display', 'none');
            $('#ifReport_Agency', window.parent.document).contents().find("td[alt='broker_title_graph_view_0']").closest('table').closest('tr').css('display', 'none');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_description_graph_view_0']").closest('td').css('display', 'none');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_raw_data_graph_view_0']").closest('td').css('display', 'none');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_print_graph_view_0']").closest('td').css('display', 'none');
        }
        else {

            var orgHeight = $('iframe#ifReport_Agency', window.parent.document).height();
            if (!$.browser.msie && !isIE11())
                var graphHeight = $('iframe#ifReport_Agency', window.parent.document).contents().find("table[alt='broker_cpr_graph_view']").height();
            else
                var graphHeight = $('iframe#ifReport_Agency', window.parent.document).contents().find("div[alt='broker_cpr_graph_view']").height();

            if (orgHeight < 800) {
                $('iframe#ifReport_Agency', window.parent.document).css({ 'height': orgHeight + graphHeight + 'px' });
                if (!$.browser.msie )
                    $('iframe#ifReport_Agency', window.parent.document).contents().find('#rvwReportViewer').removeAttr('style');
                else {                
                    $('iframe#ifReport_Agency', window.parent.document).contents().find('#divViewer').removeAttr("style");
                    $('iframe#ifReport_Agency', window.parent.document).contents().find('#rvwReportViewer').removeAttr("style");
                }                    
            }

            // Hide crp element
            if (!$.browser.msie && !isIE11())
                $('#ifReport_Agency', window.parent.document).contents().find("table[alt='cpr_graph_view']").closest('td').closest('tr').css('display', 'none');
            else
                $('#ifReport_Agency', window.parent.document).contents().find("div[alt='cpr_graph_view']").closest('td').closest('tr').css('display', 'none');

            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='description_graph_view_0']").closest('td').css('display', 'none');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='raw_data_graph_view_0']").closest('td').css('display', 'none');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='print_graph_view_0']").closest('td').css('display', 'none');
            $('#ifReport_Agency', window.parent.document).contents().find("td[alt='title_graph_view_0']").closest('td').closest('tr').css('display', 'none');

            // adjust broker element
            $('#ifReport_Agency', window.parent.document).contents().find("td[alt='broker_title_graph_view_0']").closest('table').closest('td').removeAttr('rowspan');
            $('#ifReport_Agency', window.parent.document).contents().find("td[alt='broker_title_graph_view_0']").closest('table').closest('tr').removeAttr('style');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_description_graph_view_0']").closest('td').removeAttr('style');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_raw_data_graph_view_0']").closest('td').removeAttr('style');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_print_graph_view_0']").closest('td').removeAttr('style');

            $('#ifReport_Agency', window.parent.document).contents().find("td[alt='broker_title_graph_view_0']").closest('table').closest('td').css('display', '');

        }
    }
    else if (document.URL.toLowerCase().indexOf('hem') >= 1) {
        var currentTabType = parent.getCurrentTabType();
        if (currentTabType != "broker") {            
            // adjust broker element
            if (!$.browser.msie && !isIE11())
                $('#ifReport_Agency', window.parent.document).contents().find("table[alt='broker_cpr_graph_view']").closest('td').closest('tr').css('display', 'none');
            else
                $('#ifReport_Agency', window.parent.document).contents().find("div[alt='broker_cpr_graph_view']").closest('td').closest('tr').css('display', 'none');

            $('#ifReport_Agency', window.parent.document).contents().find("td[alt='broker_title_graph_view_0']").closest('table').closest('tr').css('display', 'none');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_description_graph_view_0']").closest('td').css('display', 'none');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_raw_data_graph_view_0']").closest('td').css('display', 'none');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_print_graph_view_0']").closest('td').css('display', 'none');

        }
        else {            
            var orgHeight = $('iframe#ifReport_Agency', window.parent.document).height();
            if (!$.browser.msie && !isIE11())
                var graphHeight = $('iframe#ifReport_Agency', window.parent.document).contents().find("table[alt='broker_cpr_graph_view']").height();
            else
                var graphHeight = $('iframe#ifReport_Agency', window.parent.document).contents().find("div[alt='broker_cpr_graph_view']").height();
            
            if (orgHeight < 800) {
                $('iframe#ifReport_Agency', window.parent.document).css({ 'height': orgHeight + graphHeight + 'px' });
                if (!$.browser.msie && !isIE11())
                    $('iframe#ifReport_Agency', window.parent.document).contents().find('#rvwReportViewer').removeAttr('style');
                else {
                    $('iframe#ifReport_Agency', window.parent.document).contents().find('#divViewer').removeAttr("style");
                    $('iframe#ifReport_Agency', window.parent.document).contents().find('#rvwReportViewer').removeAttr("style");
                }
            }

            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_description_graph_view_0']").closest('td').removeAttr('rowspan');
            $('#ifReport_Agency', window.parent.document).contents().find("td[alt='broker_title_graph_view_0']").closest('table').closest('td').closest('tr').css({'position': 'absolute', 'margin-top': '-25px'});            
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_print_graph_view_0']").closest('tr').css('height', '');
            
            // Hide crp element
            if (!$.browser.msie && !isIE11())
                $('#ifReport_Agency', window.parent.document).contents().find("table[alt='cpr_graph_view']").closest('td').closest('tr').css('display', 'none');
            else
                $('#ifReport_Agency', window.parent.document).contents().find("div[alt='cpr_graph_view']").closest('td').closest('tr').css('display', 'none');
                

            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='description_graph_view_0']").closest('td').css('display', 'none');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='raw_data_graph_view_0']").closest('td').css('display', 'none');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='print_graph_view_0']").closest('td').css('display', 'none');
            $('#ifReport_Agency', window.parent.document).contents().find("td[alt='title_graph_view_0']").closest('td').closest('tr').css('display', 'none');

            // adjust broker element    
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_description_graph_view_0']").closest('td').removeAttr('style');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_raw_data_graph_view_0']").closest('td').removeAttr('style');
            $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_print_graph_view_0']").closest('td').removeAttr('style');

            $('#ifReport_Agency', window.parent.document).contents().find("td[alt='broker_title_graph_view_0']").closest('table').closest('td').css('display', '');

            if (!$.browser.msie)
                $('#ifReport_Agency', window.parent.document).contents().find("table[alt='broker_cpr_graph_view']").closest('td').closest('tr').css('display', '');
            else
                $('#ifReport_Agency', window.parent.document).contents().find("div[alt='broker_cpr_graph_view']").closest('td').closest('tr').css('display', '');

            $('#ifReport_Agency', window.parent.document).contents().find("td[alt='title_graph_view_0']").closest('table').closest('td').closest('tr').css({ 'position': 'absolute', 'margin-top': '20px' });            
       }
    }
}

function adjustReport() {
    // Adjust Icon traffice light
    $("img[title*='images/']").each(function (index, value) {
        var fullTitle = $(this).attr("title");
        var url = fullTitle.substring(0, fullTitle.indexOf("]") + 1);
        $(this).attr("src", "../../" + url.replace("[", "").replace("]", ""));
        $(this).attr("title", fullTitle.replace(url, ""));
        $(this).attr("alt", fullTitle.replace(url, ""));
    });

    //adjust report layout in new version of chrome
    if (!$.browser.msie) {
        $("td[style*='WIDTH:0.00mm']").width(0.1);
        $("td:not([style])").width(1);
        $("table[alt^='projection'] > tbody >tr:eq(1)").find('td:first').width(0.1);
        $("table[alt^='portfolio'] > tbody >tr:eq(1)").find('td:first').width(0.1);
    }

    // Adjust Expand icon
    $("img[alt*='expand']").attr({ 'src': "../../images/ico_large.png" });
    $("img[alt*='expand']").width(23);
    $("img[alt*='expand']").height(19);
    $("img[alt*='expand']").closest('div').css('width', '30px');
    $("img[alt*='expand']").css('cursor', 'pointer');

    // Adjust Print icon
    $("img[alt*='print']").attr({ 'src': "../../images/ico_print.png" });
    $("img[alt*='print']").width(23);
    $("img[alt*='print']").height(19);
    $("img[alt*='print']").closest('div').css('width', '30px');
    $("img[alt*='print']").css('cursor', 'pointer');

    //Adjust Description
    $("img[alt*='description']").attr({ 'src': "../../images/ico_description_final.png" });
    $("img[alt*='description']").width(22);
    $("img[alt*='description']").height(20);
    $("img[alt*='description']").closest('div').css('width', '25px');
    $("img[alt*='description']").closest('td').css('width', '19px');

    //Adjust Graph numbers
    $("img[alt='Graph numbers']").attr({ 'src': "../../images/ico_graph_numbers.png" });
    $("img[alt='Graph numbers']").width(14);
    $("img[alt='Graph numbers']").height(14);

    // Adjust heading background
    $("div[alt='[image_header_tablix]']").parent("td").css(
        'background', 'url("../../images/thead_bg.png") repeat-x scroll 0 0 #EDECEC');
    $("td[alt='[image_header_tablix]']").css('background', 'url("../../images/thead_bg.png") repeat-x scroll 0 0 #EDECEC');

    // attach event handlers for 'Raw data' buttons
    $("img[alt*='raw_data']").attr({ 'src': "../../images/bullet_raw_data.png" });
    $("img[alt*='raw_data']").width(19);
    $("img[alt*='raw_data']").height(17);
    $("img[alt*='raw_data']").closest('div').css('width', '20px');

    // hide metric light raw data icon
    $("img[alt='Raw data']").parent("a[href*='=Metric']").parent("div").hide();

    parent.metricLightHref = $("img[alt='Raw data']:first").parent("a").attr("href");

    var viewer = document.getElementById("<%=rvwReportViewer.ClientID %>");
    var tbOwner = $("div[id*='VisibleReportContentrvwReportViewer'] table:first");

    // get height of report viewer content
    var ifHeight = tbOwner.height() + 15;

    // hide horizontal scroll
    $("div[id*='rvwReportViewer']").css("overflow", "hidden");
    //$("div[id='rvwReportViewer']").css("width", "96%");

    // change report loading panel                
    $("div[id*='rvwReportViewer_AsyncWait_Wait']").html("<img src='../../images/loading.gif' complete='complete' />");
    $("div[id*='rvwReportViewer_AsyncWait_Wait']").css({ "border": "0", "background-color": "" });

    var loading = $("#rvwReportViewer_AsyncWait_Wait").is(':visible');
    if (loading) {
        // supply a additional number for loading icon area
        ifHeight = ifHeight + IFRAME_LOADING_DIV_HEIGHT;
    }

    // implement in concrete aspx file
    adjustReport_FixHeight(ifHeight);

    $('#divViewer').height(ifHeight + 'px');
    $("td[id*='oReportCell'] > div").css("width", "100%");
    $("td[id*='oReportCell'] > div > div").css("width", "100%");
    $("td[id*='oReportCell'] > div > div > div").css("width", "100%");
    $("td[id*='oReportCell']").closest("table").css("width", "100%");
    $("td[id*='oReportCell']").find("table").css("width", "100%");
    $("td[id*='oReportCell']").find("td").attr("align", "left");

    // implement in concrete aspx file
    adjustReport_FixWidth();

    $("div[imgConImage='AutoSize']").parent("td").attr("align", "left");
    $("img[title$='width_100']").parent("div").css("width", "100%");

    // implement in concrete aspx file
    adjustReport_HideMetricLight(loading, ifHeight);

    // Show default metric light as unknow src then adjust later
    var tbMetricLight = $("table[id*='TrafficLight']");
    if (tbMetricLight.length > 0) {
        var srcUnknow = parent.$("img[src*='unknown']").first().attr("src");
        tbMetricLight.find('img').attr("src", '../' + srcUnknow);
        GetImageUrl();
    }

    // iframe complete loading
    if (ifHeight > IFRAME_LOADING_DIV_HEIGHT) {
        // implement in concrete aspx file
        adjustReport_HandleReportLoadingCompleted();
        registerRawDataButtons();
    }
}

// Under line and Under double line for sub total and total
function UnderlineSubTotalAndTotal() {
        
    if (document.URL.toLowerCase().indexOf("_level1") >= 1) {
        // HEM              
        $("table[alt*='level1_table1']").find("> tbody > tr > td > div:contains('Hotel')").css("text-decoration", "underline");
        $("table[alt*='level1_table1']").find("> tbody > tr > td > div:contains('Other')").css("text-decoration", "underline");
        $("table[alt*='level1_table1']").find("> tbody > tr > td > div").filter(function () {
            return $(this).text() === "Clubs (Hospitality)";
        }).css({ "text-decoration": "underline" });
        $("table[alt*='level1_table1']").find("> tbody > tr > td > div").filter(function () {
            return $(this).text() === "Hospitality";
        }).css({ 'border-bottom': 'double 3pt', 'display': 'inline' });
        // EML
        $("table[alt*='level1_table1']").find("> tbody > tr > td > div").filter(function () {
            return $(this).text() === "WCNSW";
        }).css({ 'border-bottom': 'double 3pt', 'display': 'inline' });
        // TMF

        if (document.URL.toLowerCase().indexOf("tmf") >= 1) {
            $("table[alt*='level1_table1']").find("> tbody > tr > td > div:contains('HEALTH & OTHER')").css("text-decoration", "underline");
            $("table[alt*='level1_table1']").find("> tbody > tr > td > div:contains('Miscellaneous')").css("text-decoration", "underline");
            $("table[alt*='level1_table1']").find("> tbody > tr > td > div").filter(function () {
                return $(this).text() === "TMF";
            }).css({ 'border-bottom': 'double 3pt', 'display': 'inline' });

            $("table[alt*='level1_table1']").find("> tbody > tr > td > div:contains('POLICE & EMERGENCY SERVICES')").css("text-decoration", "underline");
            $("table[alt*='level1_table1']").find("> tbody > tr > td > div").filter(function () {
                return $(this).text() === "TMF";
            }).css({ 'border-bottom': 'double 3pt', 'display': 'inline' });
        }        
    }
    else if (document.URL.toLowerCase().indexOf("_level2") >= 1) {
        // HEM              
        $("table[id*='tbMetric_TrafficLight']").find("> tbody > tr > td > div:contains('Hotel')").css("text-decoration", "underline");
        $("table[id*='tbMetric_TrafficLight']").find("> tbody > tr > td > div:contains('Other')").css("text-decoration", "underline");
        $("table[id*='tbMetric_TrafficLight']").find("> tbody > tr > td > div").filter(function () {
            return $(this).text() === "Clubs (Hospitality)";
        }).css({ "text-decoration": "underline" });
        $("table[id*='tbMetric_TrafficLight']").find("> tbody > tr > td > div").filter(function () {
            return $(this).text() === "Hospitality";
        }).css({ 'border-bottom': 'double 3pt', 'display': 'inline' });
        // EML
        $("table[id*='tbMetric_TrafficLight']").find("> tbody > tr > td > div").filter(function () {
            return $(this).text() === "WCNSW";
        }).css({ 'border-bottom': 'double 3pt', 'display': 'inline' });
        // TMF
        if (document.URL.toLowerCase().indexOf("tmf") >= 1) {
            $("table[id*='tbMetric_TrafficLight']").find("> tbody > tr > td > div:contains('HEALTH & OTHER')").css("text-decoration", "underline");            

            // get current tab
            var currentTabType = parent.getCurrentTabType();            
            
            if (currentTabType == "agencies") {
                $("table[id*='tbMetric_TrafficLight']").find("> tbody > tr > td > div:contains('Miscellaneous')").css("text-decoration", "underline");                
            }            

            $("table[alt*='metric_table_agency']").find("> tbody > tr > td > div:contains('Miscellaneous')").css("text-decoration", "underline");

            $("table[id*='tbMetric_TrafficLight']").find("> tbody > tr > td > div").filter(function () {
                return $(this).text() === "TMF";
            }).css({ 'border-bottom': 'double 3pt', 'display': 'inline' });

            $("table[id*='tbMetric_TrafficLight']").find("> tbody > tr > td > div:contains('POLICE & EMERGENCY SERVICES')").css("text-decoration", "underline");
            $("table[id*='tbMetric_TrafficLight']").find("> tbody > tr > td > div").filter(function () {
                return $(this).text() === "TMF";
            }).css({ 'border-bottom': 'double 3pt', 'display': 'inline' });
        }
    }
    else if (document.URL.toLowerCase().indexOf("cpr") >= 1) {
        // Last 2 week
        // HEM
        $("table[alt*='portfolio_week_portfolio']").find("> tbody > tr > td > div:contains('Clubs (Hospitality)')").css("text-decoration", "underline");        
        $("table[alt*='portfolio_week_portfolio']").find("> tbody > tr > td > div:contains('Hotel')").css("text-decoration", "underline");
        $("table[alt*='portfolio_week_portfolio']").find("> tbody > tr > td > div:contains('Other')").css("text-decoration", "underline");
        
        // TMF        
        $("table[alt*='portfolio_week_agency']").find("> tbody > tr > td > div:contains('HEALTH & OTHER')").css("text-decoration", "underline");
        $("table[alt*='portfolio_week_agency']").find("> tbody > tr > td > div:contains('POLICE & EMERGENCY SERVICES')").css("text-decoration", "underline");
        $("table[alt*='portfolio_week_agency']").find("> tbody > tr > td > div:contains('Miscellaneous')").css("text-decoration", "underline");

        // Last month
        // HEM
        $("table[alt*='portfolio_month_portfolio']").find("> tbody > tr > td > div:contains('Clubs (Hospitality)')").css("text-decoration", "underline");
        $("table[alt*='portfolio_month_portfolio']").find("> tbody > tr > td > div:contains('Hotel')").css("text-decoration", "underline");
        $("table[alt*='portfolio_month_portfolio']").find("> tbody > tr > td > div:contains('Other')").css("text-decoration", "underline");
        
        // TMF        
        $("table[alt*='portfolio_month_agency']").find("> tbody > tr > td > div:contains('HEALTH & OTHER')").css("text-decoration", "underline");
        $("table[alt*='portfolio_month_agency']").find("> tbody > tr > td > div:contains('POLICE & EMERGENCY SERVICES')").css("text-decoration", "underline");
        $("table[alt*='portfolio_month_agency']").find("> tbody > tr > td > div:contains('Miscellaneous')").css("text-decoration", "underline");

        // Advance option
        // HEM
        $("table[alt*='portfolio_advance_agency']").find("> tbody > tr > td > div:contains('Clubs (Hospitality)')").css("text-decoration", "underline");
        $("table[alt*='portfolio_advance_agency']").find("> tbody > tr > td > div:contains('Hotel')").css("text-decoration", "underline");
        $("table[alt*='portfolio_advance_agency']").find("> tbody > tr > td > div:contains('Other')").css("text-decoration", "underline");
        
        // TMF        
        $("table[alt*='portfolio_advance_agency']").find("> tbody > tr > td > div:contains('HEALTH & OTHER')").css("text-decoration", "underline");
        $("table[alt*='portfolio_advance_agency']").find("> tbody > tr > td > div:contains('POLICE & EMERGENCY SERVICES')").css("text-decoration", "underline");
        $("table[alt*='portfolio_advance_agency']").find("> tbody > tr > td > div:contains('Miscellaneous')").css("text-decoration", "underline");

    }
}

function getCurrentTabType() {
    var currentTab = $('.tab .tab_current');
    if (currentTab.length == 0) {
        return '';
    }
    
    var currentTabType = currentTab.attr('id').replace('tab_', '');
    return currentTabType;
}

function GetImageUrl() {
    var arrRTW = [];
    var arrAWC = [];
    parent.$("div[class=trafficContents]").find('img').each(function () {
        if ($(this).attr("name").toLowerCase().indexOf("rtw") >= 0) {
            arrRTW.push({
                name: $(this).attr("name")
                , url: $(this).attr("src")
                , fromVal: $(this).attr("fromVal")
                , toVal: $(this).attr("toVal")
            });
        }
        else {
            arrAWC.push({
                name: $(this).attr("name")
                , url: $(this).attr("src")
                , fromVal: $(this).attr("fromVal")
                , toVal: $(this).attr("toVal")
            });
        }
    });

    // find traffic light unknow image
    var unknowImageUrl = "";
    var unknowImage = parent.$("div[class=trafficContents]").find("img[name$='_Unknown']");
    if (unknowImage.length > 0) {
        unknowImageUrl = unknowImage.attr("src");
    }

    $("table[id*=TrafficLight]").find('img').each(function () {
        var imgCurent = $(this);
        var refixTooltip = "";

        if (imgCurent.attr('alt') != null) {
            var arrTraffic = $(this).attr('alt').replace("[", "").replace("]", "");
            arrTraffic = arrTraffic.split('_');
            var arrCompare = [];

            if (arrTraffic[0].toLowerCase().indexOf("rtw") >= 0) {
                arrCompare = arrRTW;
                refixTooltip = "Current RTW measure: " + arrTraffic[1];
            }
            else if (arrTraffic[0].toLowerCase().indexOf("awc") >= 0) {
                //arrCompare = arrAWC;                
                imgCurent.attr({ "src": "../../images/light_gray.png" });
                refixTooltip = "Number of claims: " + arrTraffic[1];
            }
            else {
                imgCurent.attr({ "src": "../../images/light_violet.png" });
                
                if (document.URL.toLowerCase().indexOf('level0') < 0 && document.URL.toLowerCase().indexOf('level1') < 0) {
                    //refixTooltip = "Number of claims: " + arrTraffic[1];                    
                }
                
                //refixTooltip = "Number of claims: " + arrTraffic[1];
            }
            //imgCurent.attr('alt', refixTooltip);
            imgCurent.attr('title', refixTooltip);

            $.each(arrCompare, function (index) {
                // For RTW: Measure/ For AWC: Number of claims
                var value1 = parseFloat(arrTraffic[1]);

                // For RTW: Target/ For AWC: Projection
                var value2 = parseFloat(arrTraffic[2]);                

                if (value1 == NaN || value2 == NaN || (value1 == 0 && value2 == 0)) {                
                    imgCurent.attr("src", '../' + unknowImageUrl);
                }
                else if (value2 >= parseFloat(arrCompare[index].fromVal)
                    && value2 <= parseFloat(arrCompare[index].toVal)) {
                    imgCurent.attr("src", '../' + arrCompare[index].url);
                }
            });
        }
    });
}

function registerRawDataButtons() {
    $("img[alt*='raw_data']").each(function () {
        
        //// if cpr then don't need this function
        //if (document.referrer.toLowerCase().indexOf('cpr') < 0)
        //{
        //    var href = $(this).parent('a').attr('href');
        //    var onclick = $(this).parent('a').attr('onclick');
        //    if (typeof (onclick) === 'undefined') {
        //        onclick = href.replace('javascript:', '');
        //        $(this).parent('a').attr('href', 'javascript:void(0)');
        //        $(this).parent('a').attr('onclick', onclick);
        //    }
        //}         

        if ($.browser.msie || isIE11()) {
            var href = $(this).parent('a').attr('href');
            var onclick = $(this).parent('a').attr('onclick');
            if (typeof (onclick) === 'undefined') {
                onclick = href.replace('javascript:', '');
                $(this).parent('a').attr('href', 'javascript:void(0)');
                $(this).parent('a').attr('onclick', onclick);
            }
        }
        else {
            if (document.referrer.toLowerCase().indexOf('cpr') < 0) {
                var href = $(this).parent('a').attr('href');
                var onclick = $(this).parent('a').attr('onclick');
                if (typeof (onclick) === 'undefined') {
                    onclick = href.replace('javascript:', '');
                    $(this).parent('a').attr('href', 'javascript:void(0)');
                    $(this).parent('a').attr('onclick', onclick);
                }
            }           
        }

    });
}

function isIE11() {
    if (!!navigator.userAgent.match(/Trident\/7\./))
        return true;

    return false;
}

// =========== END ADJUST LAYOUT =========



// ======== METRIC LIGHT =============
function AdjustMetricLightLevel0() {
    // Adjust odd & event background
    $("table[alt='level0_tmf']").attr("id", "tbTrafficLight_TMF");
    $("table[alt='level0_eml']").attr("id", "tbTrafficLight_EML");
    $("table[alt='level0_hem']").attr("id", "tbTrafficLight_HEM");
    $("table[alt='level0_wow']").attr("id", "tbTrafficLight_WOW");

    $("table[alt*='level0_']").each(function () {
        var trafficLightTable = $(this);
        trafficLightTable.css("width", "100%");
        trafficLightTable.parents('table').css("width", "100%");
        trafficLightTable.parents('table').parents("div").css("width", "100%");

        trafficLightTable.find("td").css({ 'width': 'auto', 'min-width': '0', 'vertical-align': 'middle' });
        trafficLightTable.find("td").attr('align', 'center');

        trafficLightTable.find("tr[height=0]").next().children("td:not(:first)").css("width", "14.29%");  

        //fix metriclight position in IE8 compat
        if ($.browser.msie && $.browser.version < 8 && document.documentMode < 8) {
            var marginLeft = screen.width <= 1024 ? -13 : -24;
            trafficLightTable.css({ "width": "auto", "margin-left": marginLeft + "px" });
        }

        // Hide metric light of RTW and AWC of WOW
        trafficLightTable.find("td").find("img[alt*='hidden']").css('display', 'none');
    });
}

function AdjustMetricLightLevel1() {
    $('#divViewer').css("background", "url(../../images/pattern.png) repeat 0 0");

    // Adjust odd & event background                    
    $("table[alt='level1_table1']").attr("id", "tbTrafficLight_Table1");
    $("table[alt='level1_table2']").attr("id", "tbTrafficLight_Table2");
    $("table[alt='level1_table3']").attr("id", "tbTrafficLight_Table3");

    $("table[id*='tbTrafficLight_']").each(function () {
        var trafficLightTable = $(this);
        trafficLightTable.css("width", "99.95%");
        trafficLightTable.parents('table').css("width", "100%");
        trafficLightTable.parents('table').parents("div").css("width", "100%");
        trafficLightTable.find("td").css({ 'width': 'auto', 'min-width': '0', 'vertical-align': 'middle' });
        trafficLightTable.find("td").attr('align', 'center');

        // Adjust header background   
        var backgroundWidth;
        if (document.URL.toLowerCase().indexOf("tmf_level1") > 0) {
            backgroundWidth = 14.28;
        }
        else {
            backgroundWidth = 16.66;
        }

        if (document.URL.toLowerCase().indexOf('wow') >= 1) {
            trafficLightTable.find("tr[height=0]").next().children("td:not(:first)").css("width", "50%");
        }
        else {
            trafficLightTable.find("tr[height=0]").next().children("td:not(:first)").css("width", backgroundWidth + "%");
        }

        // Hide metric light of RTW and AWC of WOW
        trafficLightTable.find("img[alt*='hidden']").css('display', 'none');
    });
    //fix metriclight position in IE8 compat
    if ($.browser.msie && $.browser.version < 8 && document.documentMode < 8) {

        var marginLeft = 0;
        if (document.URL.toLowerCase().indexOf("tmf_level1") >= 0) {
            marginLeft = screen.width <= 1024 ? -5 : -25;
        }
        else {
            marginLeft = screen.width <= 1024 ? -35 : -50;
        }

        $("table[id*='tbTrafficLight']").css({ "width": "auto", "margin-left": marginLeft + "px" });

        var ifHeight = $('#VisibleReportContentrvwReportViewer_ctl09').height();
        $('#VisibleReportContentrvwReportViewer_ctl09').height(ifHeight + 3);
    }    
}

function ShowHideVisibleTooltip() {
    $('input[type=checkbox]').click(function () {
        if ($(this).attr("id") == "chkAll_Unit") {
            if ($(this).attr("checked")) {
                $("input[type=checkbox]").attr("checked", true);
            }
            else {
                $("input[type=checkbox]").attr("checked", false);
            }
        }
        else {

        }
        if ($('input:checked[id!=chkAll_Unit]').length > 0) {
            parent.$(".serverContent").fadeIn("slow");
        }
        else {
            parent.$(".serverContent").fadeOut("slow");
        }
    });
}

function RemoveTitle() {
    // remove heading tooltips
    $("div[title='[image_header_tablix]']").attr("title", '');
    $("div[alt='[image_header_tablix]']").removeAttr("alt");
    $("td[title='[image_header_tablix]']").attr("title", '');
    $("td[alt='[image_header_tablix]']").removeAttr("alt");

    // remove the tooltip on metric light tables
    $("table[title='level1_table1']").attr("title", '');
    $("table[title='level1_table2']").attr("title", '');
    $("table[title='level1_table3']").attr("title", '');
    $("table[title='level0_tmf']").attr("title", '');
    $("table[title='level0_eml']").attr("title", '');
    $("table[title='level0_hem']").attr("title", '');

    // remove other tooltips
    $("div[title*='width_100']").attr("title", '');
    $("img[title*='width_100']").attr("title", '');
    $("table[title*='width_100']").attr("title", '');
    $("div[title*='width_30']").attr("title", '');
    $("table[title*='width_30']").attr("title", '');

    // IE8 compat
    if ($.browser.msie && $.browser.version < 8 && document.documentMode < 8) {
        //TODO
    }
    else {
        // remove desciption icon title
        $("img[title*='description']").attr("title", '');
    }

    // raw data
    $("img[title*='raw_data']").attr("title", '');

    // expand large graph
    $("img[title*='expand']").attr("title", '');

    // remove portfolio report icon title
    $("img[title='PortIcon']").attr("title", '');

    // remove tooltips relating printing function
    $("img[title*='graph_']").attr("title", '');
    $("td[title*='title_graph_']").attr("title", '');
    $("table[title='projection_table']").attr("title", '');

    // adjust tooltips for print button
    $("img[alt*='print_graph_']").attr("title", "Print graph");
    $("img[alt*='raw_data']").attr("title", "Raw data");
    $("img[alt*='expand_graph']").attr("title", "View large graph");
}

function AdjustMetricLightLevel2_Up() {
    var tableMetric;

    if (window.location.href.toLowerCase().indexOf('_cpr_') < 0) {
        tableMetric = $("table > tbody > tr[height=0]").first().closest("table");
    }
    else {
        tableMetric = $("table[alt*=metric_table]");
    }
    tableMetric.attr("id", "tbMetric_TrafficLight");
    tableMetric.parents('table').css("width", "100%");
    tableMetric.parents('table').parents("div").css("width", "100%");

    tableMetric.css("width", "100%");

    $("table#tbMetric_TrafficLight td").css('width', 'auto');
    $("table#tbMetric_TrafficLight td").css('min-width', '0');
    $("table#tbMetric_TrafficLight td").attr('align', 'center');
    $("table#tbMetric_TrafficLight td").css('vertical-align', 'middle');

    if ($.browser.msie && $.browser.version < 8 && document.documentMode < 8) {
        //tableMetric.css("width", "99.2%");       
    }
    //if (document.URL.toLowerCase().indexOf("_rtw_level2") >= 0)
    //{       
    //$("table#tbMetric_TrafficLight tr[height=0]").next().children("td:not(:first)").css("width", 100 / 7.25 + "%");        
    //}    
}

function AdjustTitlteHeight() {
    var maxHeight = 0;
    $("td[alt^='title_graph_']").each(function () {
        if ($(this).attr("alt").indexOf("view_") < 0) {
            var height = $(this).height();
            if (height > maxHeight)
                maxHeight = height;
        }
    })

    // make graph titles consistent about height
    $("td[alt^='title_graph_']").each(function () {
        if ($(this).attr("alt").indexOf("view_") < 0) {
            $(this).height(maxHeight + 5);
        }
    })
}

function getParameterByName(key) {
    if (key != null) {
        key = key.replace(/[*+?^$.\[\]{}()|\\\/]/g, "\\$&"); // escape RegEx meta chars
        var match = location.search.toLowerCase().match(new RegExp("[?&]" + key.toLowerCase() + "=([^&]+)(&|$)"));
        if (match != null)
            return match && decodeURIComponent(match[1].replace(/\+/g, " "));
    }

    return "";
}
// ======== END METRIC LIGHT ===========



// ======== DESCRIPTION TOOLTIP ========
function registerDescriptionButtonHover() {    
    removeNoDataDescriptionButtons();
    $(document).tooltip({
        items: "img[alt*='description_graph']",
        content: function () {
            var content = parent.$(".viewDescContent");
            var href = $(this).parent("a").attr('href');
            filterDescriptionContent(href);
            return content.html();
        },
        tooltipClass: "viewDescContent",
        show: { effect: "blind", duration: 300 }
    });
}

function removeNoDataDescriptionButtons() {
    $("img[alt*='description']").each(function (index) {
        var i = 0;
        var icon = $(this);
        var href = $(this).parent("a").attr('href');
        href = href.replace("javascript:ShowDescription('", "");
        href = href.replace("')", "");
        href = href.replace("','", "");

        // prevent click event on description icons
        $(this).parent("a").click(function (e) {
            e.preventDefault();
        });

        $(".viewDescContent", window.parent.document).find("input").each(function () {
            var desc = $(this).val();
            var dbHref = $(this).attr('id');
            var systemName = $(this).attr('title');

            //check if there is no description
            if (desc == "") {
                if (href == dbHref) {
                    icon.parent().remove();
                }
            }

            //check if there is no record
            if (document.URL.toLowerCase().indexOf("level0") < 0) {
                if (href.indexOf(dbHref) >= 0) i++;
            }
            else {
                if (href.indexOf(dbHref) >= 0 && href.indexOf(systemName) >= 0) i++;
            }
        });

        if (i <= 0) icon.parent().remove();
    });
}

function filterDescriptionContent(href) {
    href = href.replace("javascript:ShowDescription('", "");
    href = href.replace("')", "");
    href = href.replace("','", " ");
    var content = parent.$(".viewDescContent");
    var h1 = content.find('h1');
    var p = content.find('p');
    var flag = false;
    content.find("input").each(function () {
        var desc = $(this).val();
        var dbHref = $(this).attr('id');
        var systemName = $(this).attr('title');
        if (href.indexOf(dbHref) >= 0) {
            flag = true;
        }
        else if (href.indexOf(dbHref) >= 0 && href.indexOf(systemName) >= 0) {
            flag = true;
        }

        if (flag == true) {
            p.html(desc);
            if (href == "1-2" || href == "3-5") {
                h1.html("Weekly open " + href + " years post-injury");
            }
            else if (href == "5-plus") {
                h1.html("Weekly open 5 + years post-injury");
            }
            else if (href == "Whole_HEM") {
                h1.html("No. of active weekly claims by accident year Hospitality");
            }
            else if (href == "Whole_TMF") {
                h1.html("No. of active weekly claims by accident year TMF");
            }
            else if (href == "Whole_EML") {
                h1.html("No. of active weekly claims by accident year WCNSW");
            }
            else {
                href = href.replace(/-/g, " ");
                href = href.replace(/_/g, " ");
                href = href.replace("HEM", "Hospitality");
                href = href.replace("EML", "WCNSW");                
                //href = href.replace("TMF CPR", "Claims portfolio report last 12 months");
                //href = href.replace("WCNSW CPR", "Claims portfolio report last 12 months");
                //href = href.replace("Hospitality CPR", "Claims portfolio report last 12 months");
                //href = href.replace("WOW CPR", "Claims portfolio report last 12 months");
                href = href.replace("TMF CPR", "");
                href = href.replace("WCNSW CPR", "");
                href = href.replace("Hospitality CPR", "");
                href = href.replace("WOW CPR", "");
                h1.html(href);
            }
        }
        flag = false;
    });

}

// ======== END DESCRIPTION TOOLTIP =========



// ======== PRINTING ===============

function registerPrintButtonClick() {
    $("img[alt*='print_graph_']").click(function () {
        var graphViewName = $(this).attr('alt').replace('print_', '');
        previewGraphBeforePrint(graphViewName);
    });
}

function formatProjectionTable(projectionTable) {   
    projectionTable.css('font-size', '11px');
    projectionTable.css('font-family', '"lato_regular", Arial, Helvetica, sans-serif');
    projectionTable.find('tr:gt(0):lt(3)').each(function (index) {
        var rowIndex = index;
        $(this).children('td:gt(1)').each(function (index) {
            $(this).css('text-align', 'center');            
            $(this).css('vertical-align', 'middle');           
            $(this).css('padding', '2px');
            $(this).css('border-style', 'solid');
            $(this).css('border-width', '1px');
            $(this).css('border-color', '#e1e1e1');            

            if (index == 0) {
                $(this).css('color', '#037baf');                                                
            }
        });

        // set color for table header
        if (index == 0) {
            $(this).css('color', '#037baf');            
        }

        // set color for table row 1
        $(this).children('td:gt(1)').each(function (index) {
            if (rowIndex == 1) {
                $(this).css('background-color', '#edf2f6');                                
            }
        });
    });    
}

function previewGraphBeforePrint(graphViewName) {
    var graphContainer;
    var table;    
    if (window.location.href.toLowerCase().indexOf('level1') < 0
            && window.location.href.toLowerCase().indexOf('level0') < 0) {
        if (window.location.href.toLowerCase().indexOf('cpr') < 0) {
            graphContainer = graphViewName == "graph_view_1" ?
                ($.browser.msie || isIE11() ?
                    $("div[alt^='" + graphViewName + "']").first().children('table')
                    : $("table[alt^='" + graphViewName + "']").first())
                    //: $('#' + graphViewName).find("img").parent();  
                    : $('#' + graphViewName);
                
            
            //table = graphViewName == "graph_view_1" ?
            //    ($.browser.msie ?
            //        $("div[alt^='" + graphViewName + "']").first().children('table')
            //        : $("table[alt^='" + graphViewName + "']").first())
            //        //: $('#' + graphViewName).find("img").parent();
            //        : $("table[alt^='projection_table']").first();          
        }
        else {
            // CPR
            graphContainer = $('img[alt="' + graphViewName + '"]').parent();
        }
    }
    else {
        var largeGraphContainer = $('[alt*="graph_large_width_100"]');
        graphContainer = largeGraphContainer.find('img[alt="' + graphViewName + '"]').parent();
    }    

    //var graphContainer = $("table[alt='" + graphViewName + "']");
    var graphContainerClone = graphContainer.clone()/*.css({'width': ''})*/;

    //var tableclone = table.clone();

    validateGraphSession(graphContainerClone);

    clipGraphs(graphContainer, graphContainerClone);

    var graphTitle = $('td[alt="title_' + graphViewName + '"]').text();

    // FIXED: losting CSS in projection table (AWC) when user open print preview popup (Chrome only)
    graphContainerClone.find("table[alt='projection_table'] > tbody div").each(function () {
        $(this).removeAttr("class");        
    });
    graphContainerClone.find("table[alt='projection_table']").attr("alt", "projection_table_clone");
      
    
    if ($.browser.msie && (document.documentMode == 8 || document.documentMode == 7)) {
        // FOR IE8 AND EARLIER VERSION: Use CSS Clipping on graph        
        $("#overlay", window.parent.document).fadeIn('fast', function () {
            //fix indicator image
            graphContainerClone.find("img[id*='imgIndicator']").each(function () {
                var src = $(this).attr('src').replace('../../', '../');
                $(this).attr('src', src);
            });

            var printContentIframe = $("#printContent", window.parent.document);
            printContentIframe.contents().find('body').empty();
            printContentIframe.contents().find('body').append('<div id="content" align="center" style="position: relative"><div id="graphTitle"></div></div>');
            printContentIframe.contents().find('body div#graphTitle').html(graphTitle);
            printContentIframe.contents().find('body div#graphTitle').css({ 'font-family': 'arial', 'font-size': '12pt', 'color': '#037baf', 'font-weight': '700' });
            printContentIframe.contents().find('body div#content').append(graphContainerClone);
            printContentIframe.contents().find("body").css({ "width": "99%", "margin-bottom": "20px" });
            printContentIframe.contents().find("html").css("overflow", "auto");

            // hide the text
            $("#printInstruction", window.parent.document).hide();


            var selfPopup = $(".viewPrintContent", window.parent.document);
            selfPopup.css("top", ($(window).height() - selfPopup.height()) / 2 + $(window).scrollTop() + "px");

            var popupWidth = $(window.parent).width() - 200;
            var popupHeight = $(window.parent).height() - 110;
            //selfPopup.css("cssText", "width: " + (graphViewName.indexOf('width_100') >= 0 ? graph.width() + 20 : graphContainer.width() + 20) + "px !important; height: " + (graphContainer.height() + 40) + "px !important");
            selfPopup.css("cssText", "width: " + popupWidth + "px !important; height:" + popupHeight + "px !important;");

            selfPopup.css("left", "15px");
            selfPopup.fadeIn('slow');
            selfPopup.css("margin", "auto");

            graphContainerClone.css("margin-left", "-10px");

            selfPopup.css('overflow', 'hidden');

            //  vertical center graph
            printContentIframe.height(popupHeight - 2);

            var projectionTable = graphContainerClone.find('table[alt="projection_table_clone"]');                         
            if (projectionTable.length > 0) {
                formatProjectionTable(projectionTable);
            }            

        });
    }
    else {        
        graphContainer.css('background', '#fff');
        if (window.location.href.toLowerCase().indexOf('rtw') > -1)
        {            
            //var imgOnly = graphContainer.find('img').parent('div');
            //// FOR OTHER BROWSERS: Use Html5 & Canvas to render graph to image
            html2canvas(graphContainer, {
                onrendered: function (canvas) {
                    var img = canvas.toDataURL();
                    $("#overlay", window.parent.document).fadeIn('fast', function () {                    

                        var printContentIframe = $("#printContent", window.parent.document);
                        printContentIframe.contents().find('body').empty();
                        //printContentIframe.contents().find('body').append('<span align="center" style="line-height: 1; position: absolute; top: 8px; right : 80px; font-family: arial; font-size: 12; color: #ff0000">To copy or save <br /> please right click on the graph</span>');
                        printContentIframe.contents().find('body').append('<div id="content" align="center"><div id="graphTitle"></div></div>');
                        printContentIframe.contents().find('body div#graphTitle').html(graphTitle);
                        printContentIframe.contents().find('body div#graphTitle').css({ 'font-family': 'arial', 'font-size': '12pt', 'color': '#037baf', 'font-weight': '700' });
                      
                        printContentIframe.contents().find('body div#content').append("<img style='width: auto;height: auto' src=" + img + "></img>");                       

                        printContentIframe.contents().find("body").css({ "width": "99%", "margin-bottom": "20px" });
                        printContentIframe.contents().find("html").css("overflow", "auto");                   

                        var selfPopup = $(".viewPrintContent", window.parent.document);
                        selfPopup.css("top", ($(window).height() - selfPopup.height()) / 2 + $(window).scrollTop() + "px");

                        var popupWidth = $(window.parent).width() - 200;
                        var popupHeight = $(window.parent).height() - 110;
                        selfPopup.css("cssText", "width: " + popupWidth + "px !important; height:" + popupHeight + "px !important;");
                        selfPopup.css("left", "15px");
                        selfPopup.fadeIn('slow');
                        selfPopup.css("margin", "auto");                        

                        graphContainerClone.css("margin-left", "-10px");

                        selfPopup.css('overflow', 'hidden');

                        //  vertical center graph
                        printContentIframe.contents().find('body div#content').css("top", (printContentIframe.height() - graphContainer.height()) / 2 + "px");

                        var projectionTable = graphContainerClone.find('table[alt="projection_table_clone"]');
                        if (projectionTable.length > 0) {
                            formatProjectionTable(projectionTable);
                        }                                 
                    });                
                }
            });     
        }
        else
        {
            $("#overlay", window.parent.document).fadeIn('fast', function () {
                graphContainerClone.css('width', '100%');

                //fix indicator image
                graphContainerClone.find("img[id*='imgIndicator']").each(function () {
                    var src = $(this).attr('src').replace('../../', '../');
                    $(this).attr('src', src);
                });

                graphContainerClone.find('img').remove();
                var imgOnly = graphContainer.find('img').parent();

                html2canvas(imgOnly, {
                    onrendered: function (canvas) {
                        var imgURL = canvas.toDataURL();                        
                        graphContainerClone.find('map').before("<img style='width: auto;height: auto' src=" + imgURL + "></img>");
                    }
                });

                var printContentIframe = $("#printContent", window.parent.document);
                printContentIframe.contents().find('body').empty();                
                printContentIframe.contents().find('body').append('<div id="content" style="position: relative"><div align="center" id="graphTitle"></div></div>');
                printContentIframe.contents().find('body div#graphTitle').html(graphTitle);
                printContentIframe.contents().find('body div#graphTitle').css({ 'font-family': 'arial', 'font-size': '12pt', 'color': '#037baf', 'font-weight': '700' });
                //printContentIframe.contents().find('body').append('<span align="center" style="line-height: 1; position: absolute; top: 8px; right : 80px; font-family: arial; font-size: 12px; color: #ff0000">To copy or save <br /> please right click on the graph</span>');
                printContentIframe.contents().find('body div#content').append(graphContainerClone);
                printContentIframe.contents().find("body").css({ "width": "99%", "margin-bottom": "20px" });
                printContentIframe.contents().find("html").css("overflow", "auto");

                if (document.URL.toLowerCase().indexOf('hem') >= 0) {
                    printContentIframe.contents().find('div:last').removeAttr('style');
                }

                var selfPopup = $(".viewPrintContent", window.parent.document);
                selfPopup.css("top", ($(window).height() - selfPopup.height()) / 2 + $(window).scrollTop() + "px");

                var popupWidth = $(window.parent).width() - 200;
                var popupHeight = $(window.parent).height() - 110;                
                selfPopup.css("cssText", "width: " + popupWidth + "px !important; height:" + popupHeight + "px !important;");

                selfPopup.css("left", "15px");
                selfPopup.fadeIn('slow');
                selfPopup.css("margin", "auto");

                graphContainerClone.css("margin-left", "-10px");

                selfPopup.css('overflow', 'hidden');                

                //  vertical center graph
                //printContentIframe.height(popupHeight - 2);
                printContentIframe.contents().find('body div#content').css("top", (printContentIframe.height() - graphContainer.height()) / 2 + "px");

                var projectionTable = graphContainerClone.find('table[alt="projection_table_clone"]');
                if (projectionTable.length > 0) {
                    formatProjectionTable(projectionTable);
                }
            });
        }

        $("#printInstruction", window.parent.document).show();
        //alert($("#printInstruction", window.parent.document).length);

    }
}

function clipGraphs(graphContainer, graphContainerClone) {
    graphContainer.find('img[alt*="graph"]').each(function () {
        var graphImg = $(this);
        var graphInfo = {};
        graphInfo.graphSrc = graphImg.attr('src');
        graphInfo.graphName = graphImg.attr('alt');
        graphInfo.graphWidth = graphImg.width() < graphImg.parent().width() || graphImg.parent().width() == 0 ? graphImg.width() : graphImg.parent().width();
        graphInfo.graphHeight = graphImg.parent().height();

        if (graphInfo.graphWidth != 0 && graphInfo.graphHeight != 0) {
            var graphLeft = parseInt(graphImg.css('left').replace('-', '').replace('px', ''));
            if (isNaN(graphLeft))
                graphLeft = 0;
            graphInfo.graphLeft = graphLeft;

            var graphTop = parseInt(graphImg.css('top').replace('-', '').replace('px', ''));
            if (isNaN(graphTop))
                graphTop = 0;
            graphInfo.graphTop = graphTop;
            graphInfo.graphBottom = graphInfo.graphTop + graphInfo.graphHeight;

            var graph = graphContainerClone.find('img[alt="' + graphInfo.graphName + '"]');
            graph.css('clip', 'rect(' + graphInfo.graphTop + 'px,' + graphInfo.graphWidth + 'px,' + graphInfo.graphBottom + 'px,' + graphInfo.graphLeft + 'px' + ')');            
            graph.css('position', 'absolute');
            graph.css('left', '0px');
            graphContainerClone.width(graphInfo.graphWidth);

            if (window.location.href.toLowerCase().indexOf('rtw') > -1) {
                graphContainer.width(graphInfo.graphWidth);                
            }
            
            //graphContainerClone.css('height', graphContainer.find('img').parent().height() + 'px');

            graphContainerClone.css('position', 'relative');
        }
    });
}

function hidePrintingIconOfSmallGraphs() {
    $("img[alt*='print_graph_']").each(function () {
        if ($(this).attr('alt').toLowerCase().indexOf('print_graph_view') < 0) {
            $(this).hide();
        }
    });
}

function hideLargeGraph() {
    // hide large graph
    var largeGraphContainer = $('[alt*="graph_large_width_100"]');
    largeGraphContainer.css('visibility', 'hidden');;

    // adjust height
    if (largeGraphContainer.length > 0) {
        var containerheight = largeGraphContainer.height();
        var iframe;

        // currently, we have changed all tabs into 1 rdl file for cpr/awc, just remains rtw that needs to detect correct iframe
        if (window.location.href.toLowerCase().indexOf('rtw') > -1
            && window.location.href.toLowerCase().indexOf('level2') > -1) { // just have tabs on level 2
            var type = largeGraphContainer.attr('alt').replace('_graph_large_width_100', '');
            iframe = $('iframe', window.parent.document).filter(function () {
                return $(this).attr('id').toLowerCase().indexOf(type.toLowerCase()) > -1;
            });
        }
        else {
            iframe = $('iframe[id*="ifReport"]', window.parent.document);
        }

        var iframeHeight = iframe.height();
        iframe.height(iframeHeight - containerheight);
    }
}

// ========= END PRINTING ==========



// ======== VIEW LARGE GRAPH =======

function registerLargeGraphButtonClick() {
    $("img[alt*='expand']").click(function () {
        var graphInfo = $(this).attr('alt').split('_');
        var graphName = graphInfo[1] + '_' + graphInfo[2];
        var graphViewType = typeof (graphInfo[3]) == 'undefined' ? "" : graphInfo[3];

        viewLargeGraph(graphName, graphViewType);

        // auto scroll
        var graphViewName = 'graph_view';
        if (graphViewType != "") {
            graphViewName = graphViewName + '_' + graphViewType;
        }
        var $target = $('#' + graphViewName);
        $('html, body', window.parent.document).stop().animate({
            'scrollTop': $target.offset().top + 50
        }, 300, 'swing');
    });
}

function viewLargeGraph(graphName, graphViewType) {
    var graphName = graphName;
    var graphViewName = 'graph_view';
    var graphViewTitleName = 'title_graph_view';
    var rawDataBtnName = 'raw_data_graph_view';
    var descriptionBtnName = 'description_graph_view';

    if (graphViewType != "") {
        graphName = graphName + '_' + graphViewType;
        graphViewName = graphViewName + '_' + graphViewType;
        graphViewTitleName = graphViewTitleName + '_' + graphViewType;
        rawDataBtnName = rawDataBtnName + '_' + graphViewType;
        descriptionBtnName = descriptionBtnName + '_' + graphViewType;
    }

    // replace graph
    var largeGraphContainer = $('[alt*="graph_large_width_100"]');
    var graphView = $('#' + graphViewName);

    if (document.URL.toLowerCase().indexOf('awc') > -1) {
        var graph = largeGraphContainer.find('img[alt="' + graphName + '"]').parent().closest('table').clone();
        graph.attr('id', graphView.attr('id')); // retain ID of graph view
        graphView.replaceWith(graph);
    }
    else {
        var graph = largeGraphContainer.find('img[alt="' + graphName + '"]').parent().clone();
        graphView.html(graph);
    }

    validateGraphSession(graphView);

    // replace graph title
    var graphTitle = $('td[alt="title_' + graphName + '"]').text();
    var graphViewTitle = $('td[alt="' + graphViewTitleName + '"]');
    graphViewTitle.html("<div></div>");
    graphViewTitle.find('div:eq(0)').css({ 'font-family': 'arial', 'font-size': '10pt', 'color': '#037baf', 'font-weight': '700' });
    graphViewTitle.find('div:eq(0)').html(graphTitle);

    // replace buttons function
    var rawDataBtn = $('img[alt="raw_data_' + graphName + '"]').parent();
    $('img[alt="' + rawDataBtnName + '"]').parent().attr('onclick', rawDataBtn.attr('onclick'));

    var descriptionBtn = $('img[alt="description_' + graphName + '"]').parent();
    var graphViewDescBtn = $('img[alt="' + descriptionBtnName + '"]').parent();
    graphViewDescBtn.attr('href', descriptionBtn.attr('href'));
}

function setupGraphView() {
    $('img[alt*="graph_view"]').each(function () {
        if (document.URL.toLowerCase().indexOf('awc') > -1) {
            $(this).closest('table').attr('id', $(this).attr('alt'));
        }
        else {
            $(this).parent().attr('id', $(this).attr('alt'));
            $(this).parent().parent().attr('align', 'center');
        }
    });
}

// ======== END VIEW LARGE GRAPH ============   



// ========= DETECT LOST SESSION ========
function validateGraphSession(graphView) {
    var graph = graphView.find('img');
    graph.error(function () {
        parent.window.location = parent.window.g_baseUrl + '/account/login?logout=true&ssrs=lost';
    });
}
// ========= END DETECT LOST SESSION ========

// ========= RAW DATA =========
function openRawDataPopup(strHref) {
    var rawDataSource = getRawDataSource();
    parent.openRawDataPopup(rawDataSource, strHref);
    
    // For RTW/ AWC dashboards: keep track start time, end time of each page/tab
    var currentTab = $('.tab .tab_current', parent);
    parent.submitTimeInfo(currentTab);
    parent.saveStartTime();
}
// ======= END RAW DATA ============

// ======= HELPERS =========
function isIE11() {
    return parent.isIE11();
}

function isLevel(level) {
    if (document.referrer.toLowerCase().indexOf(level) > -1)
        return true;

    return false;
}
// ======= END HELPERS ======

// DRAW GRAPH USING CANVAS
//function drawAllGraphs(graphContainer, graphContainerClone) {
//    //var largeGraphContainer = $('[alt*="graph_large_width_100"]');
//    graphContainer.find('img[alt*="graph"]').each(function () {
//        var graphImg = $(this);
//        var graphInfo = {};
//        graphInfo.graphSrc = graphImg.attr('src');
//        graphInfo.graphName = graphImg.attr('alt');
//        graphInfo.graphWidth = graphImg.width();
//        graphInfo.graphHeight = graphImg.parent().height();
//        var graphLeft = parseInt(graphImg.css('left').replace('-', '').replace('px', ''));
//        if (graphLeft === 'NaN')
//            graphLeft = 0;
//        graphInfo.graphLeft = graphLeft;

//        var graphTop = parseInt(graphImg.css('top').replace('-', '').replace('px', ''));
//        if (graphTop === 'NaN')
//            graphTop = 0;
//        graphInfo.graphTop = graphTop;

//        drawGraph(graphContainerClone, graphInfo);
//    });
//}

//function drawGraph(graphContainerClone, graphInfo) {
//    var graphImg = graphContainerClone.find('img[alt="' + graphInfo.graphName + '"]');
//    var graphSrc = graphInfo.graphSrc;
//    var graphName = graphInfo.graphName;
//    var graphWidth = graphInfo.graphWidth;
//    var graphHeight = graphInfo.graphHeight;
//    var graphLeft = graphInfo.graphLeft;
//    var graphTop = graphInfo.graphTop;

//    //$(this).parent().after('<canvas id="' + graphName + '" width="' + graphWidth + '" height="' + graphHeight + '"></canvas>');
//    var canvasId = 'canvas_' + graphName;
//    graphImg.replaceWith('<canvas id="' + canvasId + '" width="' + graphWidth + '" height="' + graphHeight + '"></canvas>');
//    var canvas = graphContainerClone.find('#' + canvasId)[0];
//    var context = canvas.getContext('2d');
//    var imageObj = new Image();

//    imageObj.onload = function () {
//        context.drawImage(imageObj, 0, 0, graphWidth, graphHeight, 0, 0, graphWidth, graphHeight);
//    };
//    imageObj.src = graphSrc;
//}
