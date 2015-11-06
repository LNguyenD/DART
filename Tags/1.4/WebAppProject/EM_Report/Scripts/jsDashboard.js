var dashboardRegion;
$(function () {
    CreateOverlay("#customizeData");
    CreateOverlay('#customizeReport');
    //create dialog - overlay
    CreateOverlay("#searchPolicy");
    CreateOverlay(".remove");

    // drag and drog function
    $('.box.r1-c2')
    	.each(function () {
    	    $(this).hover(function () {
    	        $(this).find('h2').addClass('collapse');
    	    }, function () {
    	        $(this).find('h2').removeClass('collapse');
    	    })
    	    .find('h2').hover(function () {
    	        $(this).find('.configure').css('visibility', 'visible');
    	    }, function () {
    	        $(this).find('.configure').css('visibility', 'hidden');
    	    })
    	    .end()
    	    .find('.configure').css('visibility', 'hidden');
    	});

    $('.first-row').sortable({
        connectWith: '.first-row',
        handle: 'h2',
        cursor: 'move',
        placeholder: 'placeholder',
        forcePlaceholderSize: true,
        opacity: 0.4,
        stop: function (event, ui) {
            $(ui.item).find('h2').click();
            var sortorder = '';
            $('.first-row').each(function () {
                var itemorder = $(this).sortable('toArray');
                var columnId = $(this).attr('id');
                sortorder += columnId + '=' + itemorder.toString() + '&';
            });

            updateWidgetData();
        }

    })
    .disableSelection();

    // update status when draging and droping
    function updateWidgetData() {
        var dataArray = [];
        $('.first-row').each(function () {
            var columnId = $(this).attr('id');
            var style = '';
            if ($('.box.r1-c2').children().length > 0)
                style = '.box.r1-c2';
            if ($('.box.r2-c1').children().length > 0)
                style = '.box.r2-c1';

            $(style, this).each(function (i) {
                //Create Item object for current panel  
                var item = {
                    id: $(this).attr('id'),
                    order: i,
                    column: columnId
                };
                dataArray.push(item);
            });
        });

        //Assign items array to sortorder JSON variable  
        var sortorder = { data: dataArray };
        $.ajax({
            url: '/Dashboard/UpdatedPanelPosition/',
            type: 'post',
            dataType: 'json',
            contentType: 'application/json',
            data: JSON.stringify({ order: dataArray }),
            cache: false,
            success: function (result) {
                // alert(result.success);
            },
            error: function (xhr, ajaxOptions, thrownError) {
                //  alert(thrownError);
            }
        });

    }

    $('a#Grid,a#List').click(function (event) {
        var layoutStyle = $(this).attr('id');
        var dashboardId;
        $(this).children().each(function () {
            dashboardId = $(this).attr('id');
        });
        if (layoutStyle == "Grid") {
            $(this).removeClass();
            $("a#List").removeClass();
            $(this).addClass("view-btn gridview-act");
            $("a#List").addClass("view-btn listview");
        }
        else if (layoutStyle == "List") {
            $(this).removeClass();
            $("a#List").removeClass();
            $(this).addClass("view-btn gridview");
            $("a#Grid").addClass("view-btn listview-act");
        }

        var dataRegion = Array();

        $("#first_region").children().each(function () {
            if (layoutStyle == "Grid") {
                $("div#" + $(this).attr('id') + ".box.r1-c2").css("width", "46.9%");
                $("div#" + $(this).attr('id') + ".box.r2-c1").css("width", "46.9%");
                $("iframe#ifReport" + $(this).attr('id') + "").scrollTop(400).scrollLeft(400);
            }
            else if (layoutStyle == "List") {
                $("div#" + $(this).attr('id') + ".box.r1-c2").css("width", "96%");
                $("div#" + $(this).attr('id') + ".box.r2-c1").css("width", "96%");
            }

        });


    });
    // end function
});

//************ Dashboard functions: AddNew, Config, Filter, ExportFile ***************
function ShowAddNewRegionForm() {
    var url = window.g_baseUrl + "/Dashboard/UcAddNewRegion";
    ShowDashBoardDialogForm(url, ShowAddNew);
}
function ShowAddNew(data) {
    ShowForm("#customizeReport", data);
}
function handleOK_AddNewRegionForm(flag, max) {
    if (flag == 0) {
        var reportNameId = $('select[name=ReportId]').val();
        var chartType = $('select[name=charttype]').val();
        var chartColor = $('select[name=colortype]').val();
        var fields = $("#ReportParameterFramefrm").serializeArray();
        var strResults = "";
        jQuery.each(fields, function (i, field) {

            if (strResults.indexOf(field.name) == -1) {
                strResults = strResults + field.name + "|" + field.value + ";";
            }
        });
        showLoading();
        $.post(window.g_baseUrl + '/Dashboard/UCAddNewRegion', { reportNameID: reportNameId,
            charttype: chartType, chartcolor: chartColor, paraseries: strResults
        },
        function (data) {
            $("#first_region").append(data);
            closePopup('#customizeReport');
        });
        hideLoading();
    }
    else {
        //confirmOK("Warning", "Maximum region is 6. You must remove one.");
        closePopup('#customizeReport');
        alert("Maximum region is " + max + ". You must remove one.");
        return false;
    }
}

function ConfigRegion(regionid) {
    ShowPopup(regionid);
}

function RemoveRegion(regionid) {
    confirmOKCancel("Delete region?", "This region will be permanently deleted and cannot be recovered. Are you sure?");
    var div = "#" + regionid + "";
    $("#btnOkModal").unbind("click");
    $("#btnOkModal").click(function (e) {
        $.post(window.g_baseUrl + '/Dashboard/UCDeleteRegion', { id: regionid },
            function (data) {
                $(div).remove();
                closePopup('#yesno');
            });
    });
}

function FilterColumn(regionid, reporturl) {
    ShowCustomizeData(regionid, reporturl);
}

function Export(file) {
    var filetype = file.substring(0, 3);
    var id = file.substring(4, file.length);
    $('div.box-content iframe#ifReport' + id + '')[0].contentWindow.ExportFile(filetype);
}
//********************************** Customize Report **********************************
function ShowPopup(dashboardregionId) {
    $('div#temp input#dashboardRegionTemp').attr('value', dashboardregionId);
    dashboardRegion = dashboardregionId;
    var url = window.g_baseUrl + "/Dashboard/CustomizeReport";

    ShowDashBoardDialogForm(url, ShowConfigurationPopup);
}

function ShowConfigurationPopup(data) {
    ShowForm("#customizeReport", data);
}

function ShowForm(form, data) {
    var api = $(form).data("overlay");
    $(form).html(data);
    api.load();
}
function ShowDashBoardDialogForm(url, functionShow) {
    $.ajax({
        type: 'GET',
        url: url,
        data: { dashboardRegionID: dashboardRegion },
        success: functionShow,
        statusCode: {
            403: function () {
                // forbidden (when users lost session) -> redirect to login page
                window.location.href = window.g_baseUrl + "/account/login";
            }
        }
    });
}
function closePopup(form) {
    $(form).data("overlay").close();
}

function handleOK_CustomizeForm(form) {
    var regionDashboardid = $('div#temp input#dashboardRegionTemp').val();
    var reportNameId = $('#reportId').val();
    var chartType = $('select[name=cboChartTypes]').val();
    var chartColor = $('select[name=PaletteColors]').val();
    var fields = $("#ReportParameterFramefrm").serializeArray();
    //    var frmValues = $("#reportParameterNames").val();

    var strResults = "";
    jQuery.each(fields, function (i, field) {
        if (field.name != "reportParameterNames") {
            strResults = strResults + field.name + "|" + field.value + ";";
        }
    });

    $.ajax({
        url: '/Dashboard/SaveCustomizeReport',
        type: 'POST',
        async: false,
        data: { reportNameID: reportNameId, RegionID: regionDashboardid.toString(), charttype: chartType, chartcolor: chartColor, paraseries: strResults },
        success: function (result) {
            $("#" + regionDashboardid).replaceWith(result);
            closePopup('#customizeReport');
        }
    });
    //    $.post('/Dashboard/SaveCustomizeReport', { reportNameID: reportNameId, RegionID: regionDashboardid.toString(),
    //        charttype: chartType, chartcolor: chartColor, paraseries: strResults
    //    },
    //        function (data) {
    //            alert("sdsdd");
    //            $("#" + regionDashboardid).replaceWith(data);
    //            closePopup('#customizeReport');
    //            //EventForDashboard();
    //        });
}

//********************************** Customize Data **********************************
function ShowCustomizeData(dashboardRegionId, reportUrl) {
    var id = dashboardRegionId;  //dashboardRegionId.substr(11, dashboardRegionId.length - 11);
    var url = window.g_baseUrl + "/Dashboard/CustomizeData?dashboardRegionId=" + id + "&reportUrl=" + reportUrl;
    ShowPopupForm(url, ShowCustomizeDataCallback);
}

function ShowCustomizeDataCallback(data) {
    ShowForm("#customizeData", data.html);
}

function ShowPopupForm(url, functionShow) {
    $.ajax({
        type: 'GET',
        url: url,
        data: "",
        success: functionShow,
        statusCode: {
            403: function () {
                // forbidden (when users lost session) -> redirect to login page
                window.location.href = window.g_baseUrl + "/account/login";
            }
        }
    });
}
function handleOK_CustomizeData(frameId) {
    var visibleColumns = getSelectedColumns();
    var dashboardCustomDataId = $('[name*="DashboardCustomDataId"]').val();
    var dashboardRegionId = $('[name*="DashboardRegionId"]').val();
    var reportUrl = $('#reportURL').val();
    var paraSeries = $('#frm').serialize();

    var result = paraSeries.replace(/&/g, '/');

    if (visibleColumns != undefined) {
        $.getJSON('SaveCustomizeData', { visibleColumns: "'" + visibleColumns + "'", dashboardRegionId: dashboardRegionId, dashboardCustomDataId: dashboardCustomDataId },
            function (model) {
                if (visibleColumns != undefined && visibleColumns != "") {
                    var type = model.ChartType.toString() + '/' + model.ChartColor.toString();

                    $(frameId).attr('src', window.g_baseUrl + '/DashboardReports/DashboardReport.aspx?rptname=' + reportUrl
                                + '&visibleColumns=' + visibleColumns
                                + '&type=' + type
                                + '&paraseries=' + result);
                }
            });
    }
}

function getSelectedColumns() {
    var result = "";
    var j = 1;
    var items = $('li .jstree-checked');

    for (var i = 0; i < items.length; i++) {
        result += items[i].id;

        if (j++ < items.length) {
            result += ",";
        }
    }
    return result;
}

function EditDashboardInfomation() {
    
}