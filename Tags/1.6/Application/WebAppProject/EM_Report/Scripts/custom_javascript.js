/***************************************************************
TRAFFIC LIGHT
****************************************************************/
$(".trafficSelect img").click(function () {
    $(".trafficSelectContent").slideDown();
})

$(".trafficIcon").click(function () {
    var isShow = $(".traffic").is(':visible');
    if (isShow) {
        $(this).text("Show traffic light");
        $(".traffic").hide('slow');
    }
    else {
        $(this).text("Hide traffic light");
        $(".traffic").show('slow');
    }
});

$(".trafficSelect").click(function () {
    $(".trafficSelectContent").toggle('slow');
});

/***************************************************************
FAVOUR
****************************************************************/
$(document).ready(function () {
    $("#btnOkModalFavour").hide();
});

$("#cmdfCancel").click(function () {
    $(".bookmarkContent").hide('slow');
});

$(".bookmarkContent .show").click(function () {
    ChangeShowListButtonText();
    var isShow = $(".showBookmark").is(':visible');
    if (isShow) {
        $(".showBookmark").slideUp('slow');
        $(".link").show();
        $(".bookmarkEditContent").hide();
    }
    else {
        $(".showBookmark").slideDown('slow');
    }
});

$(".bookmark").click(function () {
    ChangeShowListButtonText();
    var isShow = $(".bookmarkContent").is(':visible');
    if (isShow) {
        $(this).text("Show bookmark");
        $(".bookmarkContent").hide('slow');
        $(".link").show();
        $(".bookmarkEditContent").hide();
        $(".showBookmark").show('slow');
        $(".bookmarkSave").hide();
        $(".bookmarkEdit").show();
    }
    else {
        $(this).text("Hide bookmark");
        $(".bookmarkContent").show('slow');
    }
});

function ChangeShowListButtonText() {
    var isShow = $(".showBookmark").is(':visible');
    if (isShow) {
        $(".show").text("Show bookmark list");
    }
    else {
        $(".show").text("Hide bookmark list");
    }
}

$(".showBookmarkItems .bookmarkFunc .bookmarkEdit").click(function () {
    var seParent = $(this).parent(".bookmarkFunc");
    seParent.nextAll(".textbox").toggle('slow');
});
/***************************************************************
ORGANIZATION LEVEL
****************************************************************/
$(".organizationLevelContent .show").click(function () {
    ChangeShowOrgList();
    var isShow = $(".showOrg").is(':visible');
    if (isShow) {
        $(".showOrg").slideUp('slow');
    }
    else {
        $(".showOrg").slideDown('slow');
    }
});

function ChangeShowOrgList() {
    var isShow = $(".showOrg").is(':visible');
    if (isShow) {
        $(".organizationLevelContent .show").text("Show Organizatin by Dashboard Level list");
    }
    else {
        $(".organizationLevelContent .show").text("Hide Organizatin by Dashboard Level list");
    }
}
/***************************************************************
VIEW RAW DATA
****************************************************************/
$(".viewrawdata img").click(function () {
    if ($(this).next(".viewrawdatacontent").length)
        $(this).next(".viewrawdatacontent").toggle('slow');
});

/***************************************************************
TAB
****************************************************************/
if ($(".tab").length && window.location.href.toLowerCase().indexOf("awc") < 0 && window.location.href.toLowerCase().indexOf("cpr") < 0 && window.location.href.toLowerCase().indexOf("rtw") < 0) {
    $(".formBox").not(".formBox:first").hide();
    $('ul [id^="tab_"]').each(function (index) {
        $(this).click(function () {

            // in portfolio page => repopulate input parameters after users switch between tabs
            if (window.location.href.toLowerCase().indexOf('viewinfo') > -1) {
                //Prevent clicking when the first tab is loading. CHANGE THEN LENGTH IF ADD MORE IFRAME
                if ($(this).attr("class") == "tab_current" || $('iframe').length <= 1 || !parent.canTabClick)
                    return false;

                PortfolioTabChanged(this, index);
                
            }
            else {
                //Prevent clicking when the first tab is loading. CHANGE THEN LENGTH IF ADD MORE IFRAME
                if (($(this).attr("class") == "tab_current" || $('iframe').length <= 2 || !parent.canTabClick) && window.location.href.toLowerCase().indexOf('awc') < 0)
                    return false;

                // IE 8 Compat
                if ($.browser.msie && ($.browser.version.substr(0, 1) == 7) && document.documentMode == 8) {
                    var tabName = $(this).attr('id').replace('tab_', '');
                    if (tabName == 'agencies')
                        tabName = 'agency';
                    else if (tabName == 'account_manager')
                        tabName = 'accountmanager';

                    var iframe = $('iframe').filter(function () {
                        return $(this).attr('id').toLowerCase().indexOf(tabName.toLowerCase()) > -1;
                    });

                    iframe.contents().find('#rvwReportViewer').css('width', '100%');
                }
            }

            var id_name = $(this).attr('id');
            var systemName = $('#wrapper .breadcrum_01 a:eq(0)').html().trim();
            var AgencyTabContent = $('#ifReport_Agency').contents().find('table#tbMetric_TrafficLight').html() || $('#ifReport_Agency').contents().find("table[alt*='portfolio']").html();
            var GroupTabContent = $('#ifReport_Group').contents().find('table#tbMetric_TrafficLight').html() || $('#ifReport_Group').contents().find("table[alt*='portfolio']").html();
            var AccountManagerTabContent = $('#ifReport_AccountManager').contents().find('table#tbMetric_TrafficLight').html() || $('#ifReport_AccountManager').contents().find("table[alt*='portfolio']").html();

            // RTW
            var level2CrumbtrailsRTW = $("#level2CrumbtrailsRTW").html();
            var lookaheadLevel3Crumbtrails = $("#lookaheadLevel3CrumbtrailsRTW").html();
            var lookaheadLevel4Crumbtrails = $("#lookaheadLevel4CrumbtrailsRTW").html();
            var lookaheadLevel5Crumbtrails = $("#lookaheadLevel5CrumbtrailsRTW").html();

            // AWC
            var level2CrumbtrailsAWC = $("#level2CrumbtrailsAWC").html();
            var lookaheadLevel3CrumbtrailsAWC = $("#lookaheadLevel3CrumbtrailsAWC").html();
            var lookaheadLevel4CrumbtrailsAWC = $("#lookaheadLevel4CrumbtrailsAWC").html();

            // CPR
            var level2CrumbtrailsCPR = $("#level2CrumbtrailsCPR").html();
            var lookaheadLevel3CrumbtrailsCPR = $("#lookaheadLevel3CrumbtrailsCPR").html();
            var lookaheadLevel4CrumbtrailsCPR = $("#lookaheadLevel4CrumbtrailsCPR").html();
            var lookaheadLevel5CrumbtrailsCPR = $("#lookaheadLevel5CrumbtrailsCPR").html();

            var portfolioURL = $("#portfolioURLCrumbtrails");

            //Prevent clicking when the first tab is loading. CHANGE THEN LENGTH IF ADD MORE IFRAME
            //if ($(this).attr("class") == "tab_current" || $('iframe').length <= 1 || !parent.canTabClick)
            //    return false;

            //Prevent click Tab3 as Tab2 is not loaded fully
            if (id_name == "tab_account_manager" && (GroupTabContent == null || AgencyTabContent == null) && AccountManagerTabContent == null)
                return false;
            if (id_name == "tab_agencies" && GroupTabContent == null)
                return false;

            $(".tab li").removeClass("tab_current");
            $(this).addClass("tab_current");

            $(".formBox").hide();
            $('div.' + id_name).fadeIn("slow");

            if (id_name == "tab_agencies") {
                if (AgencyTabContent == null) {
                    parent.canTabClick = false;
                }
                //show tab 1
                $("#ifReportCover_Agency").css("height", "auto");
                $("#ifReportCover_Agency").css("display", "");
                $("#ifReport_Agency").css("visibility", "visible");

                //hide tab 2
                $("#ifReportCover_Group").css("height", "0px");
                $("#ifReportCover_Group").css("display", "none");
                $("#ifReport_Group").css("visibility", "hidden");

                //hide tab 3
                $("#ifReportCover_AccountManager").css("height", "0px");
                $("#ifReportCover_AccountManager").css("display", "none");
                $("#ifReport_AccountManager").css("visibility", "visible");

                // change crumbtrail text when change tab to agency/employer size

                // RTW
                if (level2CrumbtrailsRTW != null) {
                    if (systemName == "TMF") {
                        $("#level2CrumbtrailsRTW").html($("#level2CrumbtrailsRTW").html().replace("group", "agency"));
                        $("#lookaheadLevel3CrumbtrailsRTW").html($("#lookaheadLevel3CrumbtrailsRTW").html().replace("group", "agency"));

                        //show level 4 5 lookahead crumtrails for agency
                        $("#lookaheadLevel4CrumbtrailsRTW").show();
                        $("#lookaheadLevel5CrumbtrailsRTW").show();

                        if (lookaheadLevel4Crumbtrails.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsRTW").html(lookaheadLevel4Crumbtrails.replace("team", "subcategory"));
                        }

                        if (lookaheadLevel5Crumbtrails.indexOf('team') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsRTW").html(lookaheadLevel5Crumbtrails.replace("team", "subcategory"));
                        }

                        // change Portfolio URL when user switch tabs
                        if (typeof portfolioURL.attr("href") != typeof undefined) {
                            portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "agency"));
                        }
                    }
                    else if (systemName == "WCNSW") {

                        if (level2CrumbtrailsRTW.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('group', "employer size"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "employer_size"));
                            }
                        }
                        else if (level2CrumbtrailsRTW.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('account manager', "employer size"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("account_manager", "employer_size"));
                            }
                        }

                        if (lookaheadLevel3Crumbtrails.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsRTW").html(lookaheadLevel3Crumbtrails.replace('group', "employer size"));
                        }
                        else if (lookaheadLevel3Crumbtrails.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsRTW").html(lookaheadLevel3Crumbtrails.replace('account manager', "employer size"));
                        }

                        //hide level 4 5 lookahead crumtrails for employer size
                        $("#lookaheadLevel4CrumbtrailsRTW").hide();
                        $("#lookaheadLevel5CrumbtrailsRTW").hide();
                    }
                    else if (systemName == "Hospitality") {

                        if (level2CrumbtrailsRTW.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('group', "portfolio"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "portfolio"));
                            }
                        }
                        else if (level2CrumbtrailsRTW.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('account manager', "portfolio"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("account_manager", "portfolio"));
                            }
                        }

                        if (lookaheadLevel3Crumbtrails.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsRTW").html(lookaheadLevel3Crumbtrails.replace('group', "portfolio"));
                        }
                        else if (lookaheadLevel3Crumbtrails.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsRTW").html(lookaheadLevel3Crumbtrails.replace('account manager', "portfolio"));
                        }

                        //show level 4 5 lookahead crumtrails for porfolio
                        $("#lookaheadLevel4CrumbtrailsRTW").show();
                        $("#lookaheadLevel5CrumbtrailsRTW").show();

                        if (lookaheadLevel4Crumbtrails.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsRTW").html(lookaheadLevel4Crumbtrails.replace("team", "employer size"));
                        }

                        if (lookaheadLevel5Crumbtrails.indexOf('team') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsRTW").html(lookaheadLevel5Crumbtrails.replace("team", "employer size"));
                        }
                    }
                }

                // AWC
                if (level2CrumbtrailsAWC != null) {
                    if (systemName == "TMF") {

                        $("#level2CrumbtrailsAWC").html($("#level2CrumbtrailsAWC").html().replace("group", "agency"));
                        $("#lookaheadLevel3CrumbtrailsAWC").html($("#lookaheadLevel3CrumbtrailsAWC").html().replace("group", "agency"));

                        //show level 4 5 lookahead crumtrails for agency
                        $("#lookaheadLevel4CrumbtrailsAWC").show();

                        if (lookaheadLevel4CrumbtrailsAWC.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsAWC").html($("#lookaheadLevel4CrumbtrailsAWC").html().replace("team", "subcategory"));
                        }

                        // change Portfolio URL when user switch tabs
                        if (typeof portfolioURL.attr("href") != typeof undefined) {
                            portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "agency"));
                        }
                    }
                    else if (systemName == "WCNSW") {

                        if (level2CrumbtrailsAWC.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("group", "employer size"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "employer_size"));
                            }
                        }
                        else if (level2CrumbtrailsAWC.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("account manager", "employer size"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("account_manager", "employer_size"));
                            }
                        }

                        if (lookaheadLevel3CrumbtrailsAWC.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsAWC").html(lookaheadLevel3CrumbtrailsAWC.replace("group", "employer size"));
                        }
                        else if (lookaheadLevel3CrumbtrailsAWC.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsAWC").html(lookaheadLevel3CrumbtrailsAWC.replace("account manager", "employer size"));
                        }

                        //hide level 4 lookahead crumtrails for employer size
                        $("#lookaheadLevel4CrumbtrailsAWC").hide();
                    }
                    else if (systemName == "Hospitality") {

                        if (level2CrumbtrailsAWC.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("group", "portfolio"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "portfolio"));
                            }
                        }
                        else if (level2CrumbtrailsAWC.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("account manager", "portfolio"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("account_manager", "portfolio"));
                            }
                        }

                        if (lookaheadLevel3CrumbtrailsAWC.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsAWC").html(lookaheadLevel3CrumbtrailsAWC.replace("group", "portfolio"));
                        }
                        else if (lookaheadLevel3CrumbtrailsAWC.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsAWC").html(lookaheadLevel3CrumbtrailsAWC.replace("account manager", "portfolio"));
                        }

                        //show level 4 lookahead crumtrails for portfolio
                        $("#lookaheadLevel4CrumbtrailsAWC").show();

                        if (lookaheadLevel4CrumbtrailsAWC.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsAWC").html($("#lookaheadLevel4CrumbtrailsAWC").html().replace("team", "employer size"));
                        }
                    }
                }

                // CPR
                if (level2CrumbtrailsCPR != null) {
                   
                    if (systemName == "TMF") {
                        
                        $("#level2CrumbtrailsCPR").html($("#level2CrumbtrailsCPR").html().replace("group", "agency"));
                        $("#lookaheadLevel3CrumbtrailsCPR").html($("#lookaheadLevel3CrumbtrailsCPR").html().replace("group", "agency"));

                        //hide levels 6, 7 lookahead crumtrails for agency
                        $("#lookaheadLevel6CrumbtrailsCPR").hide();
                        $("#lookaheadLevel7CrumbtrailsCPR").hide();
                        
                        if (lookaheadLevel4CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsCPR").html(lookaheadLevel4CrumbtrailsCPR.replace("team", "subcategory"));
                        }

                        if (lookaheadLevel5CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsCPR").html(lookaheadLevel5CrumbtrailsCPR.replace("team", "subcategory"));
                        }

                        // change Portfolio URL when user switch tabs
                        if (typeof portfolioURL.attr("href") != typeof undefined) {
                            portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "agency"));
                        }
                    }
                    else if (systemName == "WCNSW") {

                        if (level2CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('group', "employer size"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "employer_size"));
                            }
                        }
                        else if (level2CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('account manager', "employer size"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("account_manager", "employer_size"));
                            }
                        }

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('group', "employer size"));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('account manager', "employer size"));
                        }

                        //hide levels 4, 5, 6, 7 lookahead crumtrails for employer size
                        $("#lookaheadLevel4CrumbtrailsCPR").hide();
                        $("#lookaheadLevel5CrumbtrailsCPR").hide();
                        $("#lookaheadLevel6CrumbtrailsCPR").hide();
                        $("#lookaheadLevel7CrumbtrailsCPR").hide();
                    }
                    else if (systemName == "Hospitality") {

                        if (level2CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('group', "portfolio"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "portfolio"));
                            }
                        }
                        else if (level2CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('account manager', "portfolio"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("account_manager", "portfolio"));
                            }
                        }

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('group', "portfolio"));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('account manager', "portfolio"));
                        }

                        //show level 4 5 lookahead crumtrails for porfolio
                        $("#lookaheadLevel4CrumbtrailsCPR").show();
                        $("#lookaheadLevel5CrumbtrailsCPR").show();

                        if (lookaheadLevel4CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsCPR").html(lookaheadLevel4CrumbtrailsCPR.replace("team", "employer size"));
                        }

                        if (lookaheadLevel5CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsCPR").html(lookaheadLevel5CrumbtrailsCPR.replace("team", "employer size"));
                        }

                        //hide levels 6, 7 lookahead crumtrails for portfolio
                        $("#lookaheadLevel6CrumbtrailsCPR").hide();
                        $("#lookaheadLevel7CrumbtrailsCPR").hide();
                    }
                }
            }

            else if (id_name == "tab_group") {
                if (GroupTabContent == null) {
                    parent.canTabClick = false;
                }

                //show tab 2
                $("#ifReportCover_Group").css("height", "auto");
                $("#ifReportCover_Group").css("display", "");
                $("#ifReport_Group").css("visibility", "visible");

                //hide tab 1
                $("#ifReportCover_Agency").css("height", "0px");
                $("#ifReportCover_Agency").css("display", "none");
                $("#ifReport_Agency").css("visibility", "hidden");

                //hide tab 3
                $("#ifReportCover_AccountManager").css("height", "0px");
                $("#ifReportCover_AccountManager").css("display", "none");
                $("#ifReport_AccountManager").css("visibility", "visible");

                //change crumbtrail text when change tab Group
                // RTW
                if (level2CrumbtrailsRTW != null) {
                    if (systemName == "TMF") {
                        $("#level2CrumbtrailsRTW").html($("#level2CrumbtrailsRTW").html().replace("agency", "group"));
                        $("#lookaheadLevel3CrumbtrailsRTW").html($("#lookaheadLevel3CrumbtrailsRTW").html().replace("agency", "group"));

                        //hide level 4 5 lookahead crumtrails for group
                        $("#lookaheadLevel4CrumbtrailsRTW").hide();
                        $("#lookaheadLevel5CrumbtrailsRTW").hide();

                        // change Portfolio URL when user switch tabs
                        if (typeof portfolioURL.attr("href") != typeof undefined) {
                            portfolioURL.attr("href", portfolioURL.attr("href").replace("agency", "group"));
                        }
                    }
                    else if (systemName == "WCNSW") {

                        if (level2CrumbtrailsRTW.indexOf('employer size') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('employer size', "group"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("employer_size", "group"));
                            }
                        }
                        else if (level2CrumbtrailsRTW.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('account manager', "group"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("account_manager", "group"));
                            }
                        }

                        if (lookaheadLevel3Crumbtrails.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsRTW").html(lookaheadLevel3Crumbtrails.replace('employer size', "group"));
                        }
                        else if (lookaheadLevel3Crumbtrails.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsRTW").html(lookaheadLevel3Crumbtrails.replace('account manager', "group"));
                        }

                        //show level 4 5 lookahead crumtrails for Group
                        $("#lookaheadLevel4CrumbtrailsRTW").show();
                        $("#lookaheadLevel5CrumbtrailsRTW").show();

                        if (lookaheadLevel4Crumbtrails.indexOf('subcategory') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsRTW").html($("#lookaheadLevel4CrumbtrailsRTW").html().replace("subcategory", "team"));
                        }
                        else if (lookaheadLevel4Crumbtrails.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsRTW").html($("#lookaheadLevel4CrumbtrailsRTW").html().replace("employer size", "team"));
                        }

                        if (lookaheadLevel5Crumbtrails.indexOf('subcategory') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsRTW").html($("#lookaheadLevel5CrumbtrailsRTW").html().replace("subcategory", "team"));
                        }
                        else if (lookaheadLevel5Crumbtrails.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsRTW").html($("#lookaheadLevel5CrumbtrailsRTW").html().replace("employer size", "team"));
                        }
                    }
                    else if (systemName == "Hospitality") {

                        if (level2CrumbtrailsRTW.indexOf('portfolio') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('portfolio', "group"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("portfolio", "group"));
                            }
                        }
                        else if (level2CrumbtrailsRTW.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('account manager', "group"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("account_manager", "group"));
                            }
                        }

                        if (lookaheadLevel3Crumbtrails.indexOf('portfolio') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsRTW").html(lookaheadLevel3Crumbtrails.replace('portfolio', "group"));
                        }
                        else if (lookaheadLevel3Crumbtrails.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsRTW").html(lookaheadLevel3Crumbtrails.replace('account manager', "group"));
                        }

                        //hide level 4 5 lookahead crumtrails for Group
                        $("#lookaheadLevel4CrumbtrailsRTW").hide();
                        $("#lookaheadLevel5CrumbtrailsRTW").hide();

                        if (lookaheadLevel4Crumbtrails.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsRTW").html($("#lookaheadLevel4CrumbtrailsRTW").html().replace("employer size", "team"));
                        }

                        if (lookaheadLevel5Crumbtrails.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsRTW").html($("#lookaheadLevel5CrumbtrailsRTW").html().replace("employer size", "team"));
                        }
                    }
                }

                // AWC
                if (level2CrumbtrailsAWC != null) {
                    if (systemName == "TMF") {
                        $("#level2CrumbtrailsAWC").html($("#level2CrumbtrailsAWC").html().replace("agency", "group"));
                        $("#lookaheadLevel3CrumbtrailsAWC").html($("#lookaheadLevel3CrumbtrailsAWC").html().replace("agency", "group"));

                        //hide level 4 5 lookahead crumtrails for group
                        $("#lookaheadLevel4CrumbtrailsAWC").hide();

                        // change Portfolio URL when user switch tabs
                        if (typeof portfolioURL.attr("href") != typeof undefined) {
                            portfolioURL.attr("href", portfolioURL.attr("href").replace("agency", "group"));
                        }
                    }
                    else if (systemName == "WCNSW") {

                        if (level2CrumbtrailsAWC.indexOf('employer size') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("employer size", "group"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("employer_size", "group"));
                            }
                        }
                        else if (level2CrumbtrailsAWC.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("account manager", "group"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("account_manager", "group"));
                            }
                        }

                        if (lookaheadLevel3CrumbtrailsAWC.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsAWC").html(lookaheadLevel3CrumbtrailsAWC.replace("employer size", "group"));
                        }
                        else if (lookaheadLevel3CrumbtrailsAWC.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsAWC").html(lookaheadLevel3CrumbtrailsAWC.replace("account manager", "group"));
                        }

                        //show level 4 lookahead crumtrails for Group
                        $("#lookaheadLevel4CrumbtrailsAWC").show();

                        if (lookaheadLevel4CrumbtrailsAWC.indexOf('subcategory') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsAWC").html(lookaheadLevel4CrumbtrailsAWC.replace("subcategory", "team"));
                        }
                        else if (lookaheadLevel4CrumbtrailsAWC.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsAWC").html(lookaheadLevel4CrumbtrailsAWC.replace("employer size", "team"));
                        }
                    }
                    else if (systemName == "Hospitality") {

                        if (level2CrumbtrailsAWC.indexOf('portfolio') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("portfolio", "group"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("portfolio", "group"));
                            }
                        }
                        else if (level2CrumbtrailsAWC.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("account manager", "group"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("account_manager", "group"));
                            }
                        }

                        if (lookaheadLevel3CrumbtrailsAWC.indexOf('portfolio') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsAWC").html(lookaheadLevel3CrumbtrailsAWC.replace("portfolio", "group"));
                        }
                        else if (lookaheadLevel3CrumbtrailsAWC.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsAWC").html(lookaheadLevel3CrumbtrailsAWC.replace("account manager", "group"));
                        }

                        //hide level 4 lookahead crumtrails for Group
                        $("#lookaheadLevel4CrumbtrailsAWC").hide();

                        if (lookaheadLevel4CrumbtrailsAWC.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsAWC").html(lookaheadLevel4CrumbtrailsAWC.replace("employer size", "team"));
                        }
                    }
                }

                // CPR
                if (level2CrumbtrailsCPR != null) {
                    if (systemName == "TMF") {

                        $("#level2CrumbtrailsCPR").html($("#level2CrumbtrailsCPR").html().replace("agency", "group"));
                        $("#lookaheadLevel3CrumbtrailsCPR").html($("#lookaheadLevel3CrumbtrailsCPR").html().replace("agency", "group"));
                        
                        //show levels 6 ,7 lookahead crumtrails for group
                        $("#lookaheadLevel6CrumbtrailsCPR").show();
                        $("#lookaheadLevel7CrumbtrailsCPR").show();

                        // change Portfolio URL when user switch tabs
                        if (typeof portfolioURL.attr("href") != typeof undefined) {
                            portfolioURL.attr("href", portfolioURL.attr("href").replace("agency", "group"));
                        }
                    }
                    else if (systemName == "WCNSW") {

                        if (level2CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('employer size', "group"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("employer_size", "group"));
                            }

                            //show levels 4, 5 lookahead crumtrails for Group
                            $("#lookaheadLevel4CrumbtrailsCPR").show();
                            $("#lookaheadLevel5CrumbtrailsCPR").show();
                        }
                        else if (level2CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('account manager', "group"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("account_manager", "group"));
                            }
                        }

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('employer size', "group"));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('account manager', "group"));
                        }

                        //show levels 6, 7 lookahead crumtrails for Group
                        $("#lookaheadLevel6CrumbtrailsCPR").show();
                        $("#lookaheadLevel7CrumbtrailsCPR").show();

                        if (lookaheadLevel4CrumbtrailsCPR.indexOf('subcategory') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsCPR").html($("#lookaheadLevel4CrumbtrailsCPR").html().replace("subcategory", "team"));
                        }
                        else if (lookaheadLevel4CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsCPR").html($("#lookaheadLevel4CrumbtrailsCPR").html().replace("employer size", "team"));
                        }

                        if (lookaheadLevel5CrumbtrailsCPR.indexOf('subcategory') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsCPR").html($("#lookaheadLevel5CrumbtrailsCPR").html().replace("subcategory", "team"));
                        }
                        else if (lookaheadLevel5CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsCPR").html($("#lookaheadLevel5CrumbtrailsCPR").html().replace("employer size", "team"));
                        }
                    }
                    else if (systemName == "Hospitality") {
                        
                        if (level2CrumbtrailsCPR.indexOf('portfolio') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('portfolio view', "group view"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("portfolio", "group"));
                            }
                        }
                        else if (level2CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('account manager', "group"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("account_manager", "group"));
                            }
                        }
                        
                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('portfolio') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('for portfolio', "for group"));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('account manager', "group"));
                        }
                        
                        //show levels 6, 7 lookahead crumtrails for Group
                        $("#lookaheadLevel6CrumbtrailsCPR").show();
                        $("#lookaheadLevel7CrumbtrailsCPR").show();

                        if (lookaheadLevel4CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsCPR").html($("#lookaheadLevel4CrumbtrailsCPR").html().replace("employer size", "team"));
                        }

                        if (lookaheadLevel5CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsCPR").html($("#lookaheadLevel5CrumbtrailsCPR").html().replace("employer size", "team"));
                        }
                    }
                }
            }
            else if (id_name == "tab_account_manager") {

                if (AccountManagerTabContent == null) {
                    parent.canTabClick = false;
                }

                //show tab 3
                $("#ifReportCover_AccountManager").css("height", "auto");
                $("#ifReportCover_AccountManager").css("display", "");
                $("#ifReport_AccountManager").css("visibility", "visible");

                //hide tab 2
                $("#ifReportCover_Group").css("height", "0px");
                $("#ifReportCover_Group").css("display", "none");
                $("#ifReport_Group").css("visibility", "hidden");

                //hide tab 1
                $("#ifReportCover_Agency").css("height", "0px");
                $("#ifReportCover_Agency").css("display", "none");
                $("#ifReport_Agency").css("visibility", "hidden");

                //Change Crumbtrail text when change tab Account Manager
                // RTW
                if (level2CrumbtrailsRTW != null) {
                    if (systemName == "WCNSW") {

                        if (level2CrumbtrailsRTW.indexOf('employer size') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('employer size', "account manager"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("employer_size", "account_manager"));
                            }
                        }
                        else if (level2CrumbtrailsRTW.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('group', "account manager"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "account_manager"));
                            }
                        }

                        if (lookaheadLevel3Crumbtrails.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsRTW").html(lookaheadLevel3Crumbtrails.replace('employer size', "account manager"));
                        }
                        else if (lookaheadLevel3Crumbtrails.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsRTW").html(lookaheadLevel3Crumbtrails.replace('group', "account manager"));
                        }

                        //show level 4, 5 lookahead crumtrails for Account Manager
                        $("#lookaheadLevel4CrumbtrailsRTW").show();
                        $("#lookaheadLevel5CrumbtrailsRTW").show();

                        if (lookaheadLevel4Crumbtrails.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsRTW").html(lookaheadLevel4Crumbtrails.replace('team', 'employer size'));
                        }

                        if (lookaheadLevel5Crumbtrails.indexOf('team') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsRTW").html(lookaheadLevel5Crumbtrails.replace('team', 'employer size'));
                        }
                    }
                    if (systemName == "Hospitality") {

                        if (level2CrumbtrailsRTW.indexOf('portfolio') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('portfolio', "account manager"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("portfolio", "account_manager"));
                            }
                        }
                        else if (level2CrumbtrailsRTW.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('group', "account manager"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "account_manager"));
                            }
                        }

                        if (lookaheadLevel3Crumbtrails.indexOf('portfolio') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsRTW").html(lookaheadLevel3Crumbtrails.replace('portfolio', "account manager"));
                        }
                        else if (lookaheadLevel3Crumbtrails.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsRTW").html(lookaheadLevel3Crumbtrails.replace('group', "account manager"));
                        }

                        //show level 4, 5 lookahead crumtrails for Account Manager
                        $("#lookaheadLevel4CrumbtrailsRTW").show();
                        $("#lookaheadLevel5CrumbtrailsRTW").show();

                        if (lookaheadLevel4Crumbtrails.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsRTW").html(lookaheadLevel4Crumbtrails.replace('team', 'employer size'));
                        }

                        if (lookaheadLevel5Crumbtrails.indexOf('team') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsRTW").html(lookaheadLevel5Crumbtrails.replace('team', 'employer size'));
                        }
                    }
                }

                // AWC
                if (level2CrumbtrailsAWC != null) {
                    if (systemName == "WCNSW") {
                        if (level2CrumbtrailsAWC.indexOf('employer size') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("employer size", "account manager"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("employer_size", "account_manager"));
                            }
                        }
                        else if (level2CrumbtrailsAWC.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("group", "account manager"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "account_manager"));
                            }
                        }

                        if (lookaheadLevel3CrumbtrailsAWC.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsAWC").html(lookaheadLevel3CrumbtrailsAWC.replace("employer size", "account manager"));
                        }
                        else if (lookaheadLevel3CrumbtrailsAWC.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsAWC").html(lookaheadLevel3CrumbtrailsAWC.replace("group", "account manager"));
                        }

                        //show level 4 lookahead crumtrails for Account Manager
                        $("#lookaheadLevel4CrumbtrailsAWC").show();

                        if (lookaheadLevel4CrumbtrailsAWC.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsAWC").html(lookaheadLevel4CrumbtrailsAWC.replace("team", "employer size"));
                        }
                        else if (lookaheadLevel4CrumbtrailsAWC.indexOf('subcategory') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsAWC").html(lookaheadLevel4CrumbtrailsAWC.replace("subcategory", "employer size"));
                        }
                    }
                    if (systemName == "Hospitality") {
                        if (level2CrumbtrailsAWC.indexOf('portfolio') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("portfolio", "account manager"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("portfolio", "account_manager"));
                            }
                        }
                        else if (level2CrumbtrailsAWC.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("group", "account manager"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "account_manager"));
                            }
                        }

                        if (lookaheadLevel3CrumbtrailsAWC.indexOf('portfolio') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsAWC").html(lookaheadLevel3CrumbtrailsAWC.replace("portfolio", "account manager"));
                        }
                        else if (lookaheadLevel3CrumbtrailsAWC.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsAWC").html(lookaheadLevel3CrumbtrailsAWC.replace("group", "account manager"));
                        }

                        //show level 4 lookahead crumtrails for Account Manager
                        $("#lookaheadLevel4CrumbtrailsAWC").show();

                        if (lookaheadLevel4CrumbtrailsAWC.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsAWC").html(lookaheadLevel4CrumbtrailsAWC.replace("team", "employer size"));
                        }
                        else if (lookaheadLevel4CrumbtrailsAWC.indexOf('subcategory') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsAWC").html(lookaheadLevel4CrumbtrailsAWC.replace("subcategory", "employer size"));
                        }
                    }
                }

                // CPR
                if (level2CrumbtrailsCPR != null) {
                    if (systemName == "WCNSW") {

                        if (level2CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('employer size', "account manager"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("employer_size", "account_manager"));
                            }
                        }
                        else if (level2CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('group', "account manager"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "account_manager"));
                            }
                        }

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('employer size', "account manager"));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('group', "account manager"));
                        }

                        //show level 4, 5 lookahead crumtrails for Account Manager
                        $("#lookaheadLevel4CrumbtrailsCPR").show();
                        $("#lookaheadLevel5CrumbtrailsCPR").show();

                        if (lookaheadLevel4CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsCPR").html(lookaheadLevel4CrumbtrailsCPR.replace('team', 'employer size'));
                        }

                        if (lookaheadLevel5CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsCPR").html(lookaheadLevel5CrumbtrailsCPR.replace('team', 'employer size'));
                        }

                        //hide levels 6, 7 lookahead crumtrails for account manager
                        $("#lookaheadLevel6CrumbtrailsCPR").hide();
                        $("#lookaheadLevel7CrumbtrailsCPR").hide();
                    }
                    if (systemName == "Hospitality") {

                        if (level2CrumbtrailsCPR.indexOf('portfolio') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('portfolio view', "account manager view"));
                            
                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("portfolio", "account_manager"));
                            }
                        }
                        else if (level2CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('group', "account manager"));

                            // change Portfolio URL when user switch tabs
                            if (typeof portfolioURL.attr("href") != typeof undefined) {
                                portfolioURL.attr("href", portfolioURL.attr("href").replace("group", "account_manager"));
                            }
                        }

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('portfolio') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('for portfolio', "for account manager"));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('group', "account manager"));
                        }

                        //show level 4, 5 lookahead crumtrails for Account Manager
                        $("#lookaheadLevel4CrumbtrailsCPR").show();
                        $("#lookaheadLevel5CrumbtrailsCPR").show();

                        if (lookaheadLevel4CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsCPR").html(lookaheadLevel4CrumbtrailsCPR.replace('team', 'employer size'));
                        }

                        if (lookaheadLevel5CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsCPR").html(lookaheadLevel5CrumbtrailsCPR.replace('team', 'employer size'));
                        }

                        //hide levels 6, 7 lookahead crumtrails for account manager
                        $("#lookaheadLevel6CrumbtrailsCPR").hide();
                        $("#lookaheadLevel7CrumbtrailsCPR").hide();
                    }
                }
            }

            if (window.location.href.toLowerCase().indexOf('viewinfo') == -1) {
                adjustGuideBar();
            }

            // for CPR only
            //if (document.URL.toLowerCase().indexOf('_cpr') > 0) {
            //    fixIE8Height($(this));
            //}
        });
    });
}

/***************************************************************
EQUAL HEIGHT
****************************************************************/
$(window).load(function () {
    if ($("#leftSide").height() < $("#rightSide").height()) {
        $("#leftSide").height($("#rightSide").height())
    }
    else if ($("#leftSide").height() > $("#rightSide").height()) {
        $("#rightSide").height($("#leftSide").height())
    }
});
/***************************************************************
SELECT BOX
****************************************************************/
$("select option").not("#searchType option").each(function (index, element) {
    var current_val = $(this).val();
    $(this).val(current_val);
});

$(function () {
    $("select").selectbox();
});
prettyForms();

/************************************************************************
Z-INDEX DIV
*************************************************************************/
$(function () {
    var zIndexNumber = 5000;
    $('div').each(function () {
        $(this).css('zIndex', zIndexNumber);
        zIndexNumber -= 10;
    });
});

/***************************************************************
CUSTOM: ADDED BY DEVELOPERS
****************************************************************/
$(".dashboardTypeSelect").each(function (index) {
    $(this).click(function () {
        var self = this;
        var dashboardTypeItemId = $(this).attr("id");

        // set focused color on item
        $(".dashboardTypeSelect").each(function (index) {
            var _dashboardTypeItemId = $(this).attr("id");
            if (dashboardTypeItemId == _dashboardTypeItemId) {
                $(this).css("background", "#DFD6D6");
            } else {
                $(this).css("background", "#FFFFFF");
            }
        });

        $(".dashboardType").each(function (index) {
            var dashboardTypeId = $(this).attr("id");
            if (dashboardTypeId == ("dashboardType" + dashboardTypeItemId)) {
                $(this).css("display", "inline");
            } else {
                $(this).css("display", "none");
            }
        });
    });
});

function closedPopup() {
    $(".viewRawDataContent").fadeOut('slow', function () {
        $("#overlay").fadeOut('fast');
    });
}

function openRawDataPopup(rawDataSource, queryString) {
    var selfPopup = $(".viewRawDataContent");
    if (selfPopup.css("display") == "none") {
        var url = window.g_baseUrl + rawDataSource + "?" + queryString + "&rdr=" + Math.random();
        $.ajax({
            type: 'GET',
            url: url,
            async: false,
            success: function (data) {
                $(".viewRawDataContent").html(data);
            },
            statusCode: {
                403: function () {
                    // forbidden (when users lost session) -> redirect to login page
                    window.location.href = window.g_baseUrl + "/account/login";
                }
            }
        });

        // set position to center
        selfPopup.css("top", ($(window).height() - selfPopup.height()) / 2 + $(window).scrollTop() + "px");

        var marginLeft = ($(window).width() - selfPopup.width()) / 2;
        marginLeft -= 10;
        selfPopup.css("left", marginLeft + "px");

        $("#overlay").fadeIn('fast', function () {
            selfPopup.fadeIn('slow');
        });
    }
}

/***************************************************************
IMPORTING TEMPLATE
****************************************************************/
$(".linkImport").mouseover(function () {
    var screenWidth = $(window).width();
    var screenHeight = $(window).height();

    $(".viewImportContent").width(screenWidth - 80);
    $(".viewImportContent").height(screenHeight - 260);
    $(".viewImportContent").slideDown();
});

$(".linkImport").mouseleave(function () {
    $(".viewImportContent").slideUp();
});


/***************************************************************
PORTFOLIO PAGE
****************************************************************/
$(".portfolioParameterSection .show").click(function () {
    ChangeShowOrHideText();
    var isShow = $(".showOrg").is(':visible');
    if (isShow) {
        $(".showOrg").slideUp('slow');
    }
    else {
        $(".showOrg").slideDown('slow');
    }
});

function ChangeShowOrHideText() {
    var isShow = $(".showOrg").is(':visible');
    var $btnShow = $(".portfolioParameterSection .show");
    var btnShowText = $btnShow.text();

    if (isShow) {
        btnShowText = btnShowText.replace("Hide", "Show");        
    }
    else {
        btnShowText = btnShowText.replace("Show", "Hide");
    }

    $btnShow.text(btnShowText);
}

/***************************************************************
FRIENDLY PRINTING
****************************************************************/
function openPrintPopup(isRawData) {
    // initial
    initPrintPageLayout();

    var ifContent;
    var port_key;
    var isLoading;

    if (isRawData == true) {
        // For Raw Data popup

        if (window.location.href.toLowerCase().indexOf('viewinfo') > -1) {
            // For Portfolio

            ifContent = $("#ifRaw").contents();
        }
        else {
            // For Dashboard

            if ($("#tab_graph").hasClass("tab_current")) {
                ifContent = $("#ifRaw").contents();
            }
            else if ($("#tab_claim").hasClass("tab_current")) {
                ifContent = $("#ifRaw2").contents();
            }
            else {
                ifContent = $("#ifRaw3").contents();
            }
        }

        isLoading = ifContent.find("#rvwReportViewerRawData_AsyncWait_Wait").is(':visible');
    }
    else {
        // For Dashboard and Portfolio

        if ($("#tab_agencies").hasClass("tab_current")) {
            // with tab one

            ifContent = $("#ifReport_Agency").contents();
            port_key = "agency";
        }
        else if ($("#tab_group").hasClass("tab_current")) {
            // with tab two

            ifContent = $("#ifReport_Group").contents();
            port_key = "group";
        }
        else if ($("#tab_account_manager").hasClass("tab_current")) {
            // with tab three

            ifContent = $("#ifReport_AccountManager").contents();
            port_key = "accountmanager";
        }
        else {
            // without tabs

            if (window.location.href.toLowerCase().indexOf('viewinfo') > -1) {
                // For Portfolio

                ifContent = $("#ifReport_Agency").contents();
                port_key = "agency";
            }
            else {
                // For Dashboard

                ifContent = $("#ifReport").contents();
            }
        }

        isLoading = ifContent.find("#rvwReportViewer_AsyncWait_Wait").is(':visible');
    }

    if (isLoading == false) {
        $("#overlay").fadeIn('fast', function () {
            if (window.location.href.toLowerCase().indexOf('viewinfo') > -1) {
                // For Portfolio

                if (isRawData == true) {
                    // For Raw Data

                    getPrintRawDataContent(ifContent);
                }
                else {
                    getPrintContent(ifContent.find("table[alt='portfolio_" + port_key + "']"));

                    // change styles before printing
                    var className = ifContent.find("table[alt='portfolio_" + port_key + "']").attr("class").substring(0, 33);
                    ifContent.find("a[class^=" + className + "]").css("font-weight", "bold");
                    ifContent.find("div[alt*=DetailedPortfolio]").css({ "color": "#000", "font-weight": "bold" });
                    ifContent.find("div[alt=PortfolioHeader]").css({ "color": "#000", "font-weight": "bold" });

                    // to fix rendering full of hidden part in 'overflow:auto' div
                    ifContent.find("div[id^=rvwReportViewer_ctl]").css("overflow", "visible");
                }
            }
            else {
                // For Dashboard

                if (isRawData == true) {
                    // For Raw Data

                    getPrintRawDataContent(ifContent);
                }
                else {
                    getPrintContent(ifContent.find('body'));
                }
            }

            // remove all of hrefs
            $("#printContent").contents().find('a').removeAttr("href");
        });
    }
}

function initPrintPageLayout() {
    // append styles
    var headElement = $("#printContent").contents().find('html > head');
    if (headElement.length > 0 && headElement.html() == "") {
        $("#printContent").contents().find('head').append("<link href='" + window.g_baseUrl + "/css/main.css' rel='stylesheet' type='text/css'>");
        $("#printContent").contents().find('head').append("<link href='" + window.g_baseUrl + "/css/custom_main.css' rel='stylesheet' type='text/css'>");
    }

    // append logo from parent
    if ($("#printContent").contents().find('body > .logo').length == 0) {
        var parentLogo = $(".logo").clone();
        parentLogo.css("float", "none");
        $("#printContent").contents().find('body').append(parentLogo.get(0).outerHTML);
    }

    // add a cover around the images
    if ($("#printContent").contents().find('body > .printPage').length == 0) {
        $("#printContent").contents().find('body').append("<div class='printPage'></div>");
    }    
}

function adjustPreviewPopupAfterBeforePrint () {
    var beforePrint = function () {
        $("#printContent").contents().find("body").css("overflow", "visible");
        $("#printContent").contents().find("html").css("overflow", "visible");        
    };

    var afterPrint = function () {
        $("#printContent").contents().find("body").css("overflow", "auto");
        $("#printContent").contents().find("html").css("overflow", "auto");
    };

    var browserVersion;
    if ($.browser.msie || isIE11()) {
           browserVersion = window.frames["printContent"];
        }
    else {
        browserVersion = window.frames["printContent"].contentWindow;
    }
    
    if (browserVersion.matchMedia) {
        var mediaQueryList = browserVersion.matchMedia('print');
        mediaQueryList.addListener(function (mql) {
            if (mql.matches) {
                beforePrint();
            } else {
                afterPrint();
            }
        });
    }

    browserVersion.onbeforeprint = beforePrint;
    browserVersion.onafterprint = afterPrint;    
}

function printFriendly() {
    adjustPreviewPopupAfterBeforePrint();
    if ($.browser.msie || isIE11()) {
        window.frames["printContent"].focus();
        window.frames["printContent"].print();
    }
    else {
        window.frames["printContent"].contentWindow.focus();
        window.frames["printContent"].contentWindow.print();
    }    
}

function closePrintPopup() {
    $(".viewPrintContent").fadeOut('slow', function () {
        if (window.location.href.toLowerCase().indexOf('viewinfo') > -1) {

            // For Portfolio

            var ifContent;
            var port_key;

            if ($("#tab_agencies").hasClass("tab_current")) {
                ifContent = $("#ifReport_Agency").contents();
                port_key = "agency";
            }
            else if ($("#tab_group").hasClass("tab_current")) {
                ifContent = $("#ifReport_Group").contents();
                port_key = "group";
            }
            else if ($("#tab_account_manager").hasClass("tab_current")) {
                ifContent = $("#ifReport_AccountManager").contents();
                port_key = "accountmanager";
            }
            else {
                // without tabs

                if (window.location.href.toLowerCase().indexOf('viewinfo') > -1) {
                    ifContent = $("#ifReport_Agency").contents();
                    port_key = "agency";
                }
            }

            // reset styles
            var className = ifContent.find("table[alt='portfolio_" + port_key + "']").attr("class").substring(0, 33);
            ifContent.find("a[class^=" + className + "]").css("font-weight", "normal");
            ifContent.find("div[alt*=DetailedPortfolio]").css({ "color": "#747474", "font-weight": "normal" });
            ifContent.find("div[alt=PortfolioHeader]").css({ "color": "#747474", "font-weight": "normal" });

            // reset: to fix rendering full of hidden part in 'overflow:auto' div
            ifContent.find("div[id^=rvwReportViewer_ctl]").css("overflow", "auto");
        }

        $("#overlay").fadeOut('fast');
    });
}

function getPrintContent(content, isRawData) {
    var contentWidth = $(".viewPrintContent").width() - 10;

    // remove existing image
    $("#printContent").contents().find('body > .printPage > img').remove();

    // remove existing tabs
    $("#printContent").contents().find('body > .tab').remove();
    
    if (window.location.href.toLowerCase().indexOf('viewinfo') > -1) {
        // For Portfolio

        // remove existing parameter section
        $("#printContent").contents().find('body > .portfolioParameterSection').remove();

        if (isRawData == true) {
            // For Raw Data

            $("#printContent").contents().find('body > .logo').after("<div style='height: 1px;'></div>");
        }
        else {
            adjustPrintPortPage();
        }
    }
    else {
        // For Dashboard

        if (isRawData == true) {
            // For Raw Data

            var tabSection = $("#tab_graph").parent("ul").clone();
            tabSection.find("a").css("cursor", "default");
            tabSection.find("li[id='printRawData']").remove();
            tabSection.find("li[id='exportExcel']").remove();
            tabSection.find("li[id='closePopup']").remove();
            $("#printContent").contents().find('body > .logo').after(tabSection.get(0).outerHTML);
        }
        else {
            // render and append guide bar
            renderImage($(".boxBdr_tl_000"));

            if (window.location.href.toLowerCase().indexOf('_level1') < 0) {
                // render and append tabs
                // MUST get parent tag of agency, group or account manager tabs
                // FIXED: conflic class "tab" in main page and popup
                renderImage($("#tab_agencies").parent("ul"));
            }
        }
    }

    // render and append main content
    renderImage(content, isRawData);
}

function getPrintRawDataContent(ifContent) {
    // show loading icon
    ifContent.find("#rvwReportViewerRawData_AsyncWait_Wait").css({ "display": "block", "visibility": "visible", "background-color": "#fff", "top": "225.5px", "clip": "auto" });
    ifContent.find("#rvwReportViewerRawData_AsyncWait_Wait > a").remove();

    var tbReportViewerRawData = ifContent.find("table > tbody > tr[height=0]").first().closest("table");
    getPrintContent(tbReportViewerRawData, true);

    // to fix rendering full of hidden part in 'overflow:auto' div
    ifContent.find("div[id^=rvwReportViewerRawData_ctl]").css("overflow", "visible");
    ifContent.find("#divViewer").css("overflow", "visible");
}

function renderImage(content, isRawData) {
    html2canvas(content, {
        onrendered: function (canvas) {
            var img = canvas.toDataURL();
            $("#printContent").contents().find('body > .printPage').append("<img style='width:100%;' src=" + img + "></img>");
            $("#printContent").contents().find("body").css({ "width": "99.8%", "height": "100%", "overflow": "auto" });
            $("#printContent").contents().find("html").css("overflow", "auto");

            // show print preview popup after rendered
            var selfPopup = $(".viewPrintContent");
            selfPopup.css("top", ($(window).height() - selfPopup.height()) / 2 + $(window).scrollTop() + "px");
            var marginLeft = ($(window).width() - selfPopup.width()) / 2;
            marginLeft -= 22;
            selfPopup.css("left", "15px");
            selfPopup.fadeIn('slow');

            if (isRawData) {
                // close current Raw Data popup
                $(".viewRawDataContent").fadeOut('fast');
                $("#printLoadingIcon").hide();
            }
        }
    });
}

function adjustPrintPortPage() {
    // For Portfolio: append more sections
    
    var paramSection = $(".portfolioParameterSection").clone();
    paramSection.css("width", "97.4%");
    paramSection.find("label").css({ "font-weight": "bold", "color": "#000" });
    paramSection.find("input").css({ "font-weight": "bold", "color": "#000" });
    paramSection.find("a").css({ "font-weight": "bold", "color": "#000" });
    paramSection.find("a.show").parent("div").remove();
    paramSection.find('a').removeAttr("href");
    paramSection.find(".btnPurple").parent("div").remove();
    $("#printContent").contents().find('body > .logo').after(paramSection.get(0).outerHTML);

    if ($("#tab_agencies").length > 0) {
        var tabSection = $("#tab_agencies").parent("ul").clone();
        tabSection.css("width", "99.8%");
        tabSection.find("a").css("cursor", "default");
        $("#printContent").contents().find('body > .logo').after(tabSection.get(0).outerHTML);
    }
}



// ======== HELPER =========
function getCurrentTabType() {
    var currentTab = $('.tab .tab_current');
    if (currentTab.length == 0) {
        return '';
    }

    var currentTabType = currentTab.attr('id').replace('tab_', '');
    return currentTabType;
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

function isIE11()
{
    if (!!navigator.userAgent.match(/Trident\/7\./))
        return true;

    return false;
}

function generateAntiForgeryTokenHeader(){
    var headers = {};
    headers['__RequestVerificationToken'] = $('input[name="__RequestVerificationToken"]').val();

    return headers;
}
// ======== END HELPER ==========