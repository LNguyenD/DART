/*
    THIS FILE CONTAINS AWC METHODS USED OUTSIDE IFRAME ONLY
*/

if ($(".tab").length) {
    $(".formBox").not(".formBox:first").hide();
    $('ul [id^="tab_"]').each(function (index) {
        $(this).click(function () {
            var currentTab = $('.tab_current');

            switchMetricLightTableLevel2($(this));

            if ($.browser.msie && ($.browser.version.substr(0, 1) == 7) && document.documentMode == 8) {
                $('#ifReport_Agency').contents().find('#rvwReportViewer').css('width', '100%');
            }

            var id_name = $(this).attr('id');
            var systemName = $('#wrapper .breadcrum_01 a:eq(0)').html().trim();
            var AgencyTabContent = $('#ifReport_Agency').contents().find('table#tbMetric_TrafficLight').html();
            var GroupTabContent = $('#ifReport_Group').contents().find('table#tbMetric_TrafficLight').html();
            var AccountManagerTabContent = $('#ifReport_AccountManager').contents().find('table#tbMetric_TrafficLight').html();

            // AWC
            var level2CrumbtrailsAWC = $("#level2CrumbtrailsAWC").html();
            var lookaheadLevel3CrumbtrailsAWC = $("#lookaheadLevel3CrumbtrailsAWC").html();
            var lookaheadLevel4CrumbtrailsAWC = $("#lookaheadLevel4CrumbtrailsAWC").html();

            $(".tab li").removeClass("tab_current");
            $(this).addClass("tab_current");

            $(".formBox").hide();
            $('div.' + id_name).fadeIn("slow");

            if (id_name == "tab_agency" || id_name == "tab_employer_size" || id_name == "tab_portfolio") {
                // change crumbtrail text when change tab to agency/employer size

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

                    }
                    else if (systemName == "WCNSW") {

                        if (level2CrumbtrailsAWC.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("group", "employer size"));
                        }
                        else if (level2CrumbtrailsAWC.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("account manager", "employer size"));

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

                        }
                        else if (level2CrumbtrailsAWC.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("account manager", "portfolio"));

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


            }

            else if (id_name == "tab_group") {

                //change crumbtrail text when change tab Group


                // AWC
                if (level2CrumbtrailsAWC != null) {
                    if (systemName == "TMF") {
                        $("#level2CrumbtrailsAWC").html($("#level2CrumbtrailsAWC").html().replace("agency", "group"));
                        $("#lookaheadLevel3CrumbtrailsAWC").html($("#lookaheadLevel3CrumbtrailsAWC").html().replace("agency", "group"));

                        //hide level 4 5 lookahead crumtrails for group
                        $("#lookaheadLevel4CrumbtrailsAWC").hide();

                    }
                    else if (systemName == "WCNSW") {

                        if (level2CrumbtrailsAWC.indexOf('employer size') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("employer size", "group"));

                        }
                        else if (level2CrumbtrailsAWC.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("account manager", "group"));

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

                        }
                        else if (level2CrumbtrailsAWC.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("account manager", "group"));

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


            }
            else if (id_name == "tab_account_manager") {
                //Change Crumbtrail text when change tab Account Manager


                // AWC
                if (level2CrumbtrailsAWC != null) {
                    if (systemName == "WCNSW") {
                        if (level2CrumbtrailsAWC.indexOf('employer size') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("employer size", "account manager"));

                        }
                        else if (level2CrumbtrailsAWC.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("group", "account manager"));

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

                        }
                        else if (level2CrumbtrailsAWC.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsAWC").html(level2CrumbtrailsAWC.replace("group", "account manager"));

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
            }
            adjustGuideBar();
            // keep track start time, end time of each page/tab
            submitTimeInfo(currentTab);
            saveStartTime();

        });
    });
}

function switchMetricLightTableLevel2(tab) {
    var tabName = tab.attr('id').replace('tab_', '');
    var hiddenTableMetricHeight = 0;
    var visibleTableMetriHeight = 0;
    $("#ifReport_Agency").contents().find("table[alt*='metric_table']").each(function () {
        var tableName = $(this).attr('alt').replace('metric_table_', '');
        if (tableName == tabName) {
            $(this).show();
            $(this).closest("div[alt='width_100']").parent('td').attr('style', '').height(0);
        }
        else {
            $(this).hide();
            hiddenTableMetricHeight += $(this).height();
        }
    });
    var heightAdjust = url.indexOf("tmf") >= 0 ? 10 : -50;
    $("#ifReport_Agency").height(parent.iframeHeight - hiddenTableMetricHeight + heightAdjust);

    //replace raw data icon url by a correct type
    tabName = tabName.replace("agencies", "agency");

    $("#ifReport_Agency").contents().find("img[alt*='raw_data']").each(function () {
        var rawDataUrl = $(this).parent('a').attr('onclick');
        var rawDataUrlSplitted = rawDataUrl.split('&');
        var sType = rawDataUrlSplitted[1];
        rawDataUrl = rawDataUrl.replace(sType, "Type=" + tabName);
        $(this).parent('a').attr('onclick', rawDataUrl);
    });
}

