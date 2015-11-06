/*
    THIS FILE CONTAINS RTW METHODS USED OUTSIDE IFRAME ONLY
*/

if ($(".tab").length) {
    $(".formBox").not(".formBox:first").hide();
    $('ul [id^="tab_"]').each(function (index) {
        $(this).click(function () {
            var currentTab = $('.tab_current');

            //Prevent clicking when the first tab is loading. CHANGE THEN LENGTH IF ADD MORE IFRAME
            if (($(this).attr("class") == "tab_current" || $('iframe').length <= 2 || !parent.canTabClick))
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


            var id_name = $(this).attr('id');
            var systemName = $('#wrapper .breadcrum_01 a:eq(0)').html().trim();
            var AgencyTabContent = $('#ifReport_Agency').contents().find('table#tbMetric_TrafficLight').html();
            var GroupTabContent = $('#ifReport_Group').contents().find('table#tbMetric_TrafficLight').html();
            var AccountManagerTabContent = $('#ifReport_AccountManager').contents().find('table#tbMetric_TrafficLight').html();

            // RTW
            var level2CrumbtrailsRTW = $("#level2CrumbtrailsRTW").html();
            var lookaheadLevel3Crumbtrails = $("#lookaheadLevel3CrumbtrailsRTW").html();
            var lookaheadLevel4Crumbtrails = $("#lookaheadLevel4CrumbtrailsRTW").html();
            var lookaheadLevel5Crumbtrails = $("#lookaheadLevel5CrumbtrailsRTW").html();

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
                    }
                    else if (systemName == "WCNSW") {

                        if (level2CrumbtrailsRTW.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('group', "employer size"));
                        }
                        else if (level2CrumbtrailsRTW.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('account manager', "employer size"));
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
                        }
                        else if (level2CrumbtrailsRTW.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('account manager', "portfolio"));
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
                    }
                    else if (systemName == "WCNSW") {

                        if (level2CrumbtrailsRTW.indexOf('employer size') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('employer size', "group"));

                        }
                        else if (level2CrumbtrailsRTW.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('account manager', "group"));

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

                        }
                        else if (level2CrumbtrailsRTW.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('account manager', "group"));

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

                        }
                        else if (level2CrumbtrailsRTW.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('group', "account manager"));

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

                        }
                        else if (level2CrumbtrailsRTW.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsRTW").html(level2CrumbtrailsRTW.replace('group', "account manager"));
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
            }

            adjustGuideBar();

            // keep track start time, end time of each page/tab
            submitTimeInfo(currentTab);
            saveStartTime();
        });
    });
}

