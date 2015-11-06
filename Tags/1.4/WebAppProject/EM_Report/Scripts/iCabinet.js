var system;
var dashBoardLevel;
var dashBoardType;
var dashboardValue;
var dashboardSubValue;

$(function () {
    system = $('#hddSystem').val();
    dashBoard = $('#hddDashboard').val();
    dashBoardLevel = $('#hddDashboardLevel').val();
    dashBoardType = $('#hddDashboardType').val();
    dashboardValue = $('#hddDashboardValue').val();
    dashboardSubValue = $('#hddDashboardSubValue').val();
   
    $('.viewCabinetContent').on('click', 'a[data-type="Folder"]', function () {
        getActuarialItems($(this), 'File');
    });

    $('.viewCabinetContent').on('click', 'a[data-type="backToFolder"]', function () {
        getActuarialItems($(this), 'Folder');
    });

    //update for Employer size from WCNSW view
    if (system == "eml" && dashBoardType == "employer_size") {
        dashboardValue = "all";
    }
});

function openCabinetPopup(){
    var selfPopup = $(".viewCabinetContent");
    if (selfPopup.css("display") == "none") {
        var queryData = "?system=" + system
                        + "&dashboard=" + dashBoard
                        + "&level=" + dashBoardLevel
                        + "&type=" + dashBoardType
                        + "&value=" + dashboardValue.replace(" & ", "@@@")
                        + "&subvalue=" + dashboardSubValue;

        var url = window.g_baseUrl + "/Report/GetFileCabinetReports" + queryData;
        $.ajax({
            type: 'GET',
            url: url,
            async: false,
            success: function (data) {
                $("#cabinetContent").html(data);
                adjustCrossBrowser();
            },
            statusCode: {
                403: function () {
                    // forbidden (when users lost session) -> redirect to login page
                    window.location.href = window.g_baseUrl + "/account/login";
                }
            }
        });

        // set position to center
        if ($("#actuarialItems").length > 0) {
            selfPopup.css("top", ($(window).height() - selfPopup.height()) / 2 + $(window).scrollTop() + "px");
        }

        var marginLeft = ($(window).width() - selfPopup.width()) / 2;
//        if ($.browser.msie && $.browser.version.substr(0, 1) < 8 || document.documentMode == 7) {
//            // IE 7 and smaller version
//            marginLeft -= 22;
//            selfPopup.css("left", marginLeft + "px");
//        } else {
//            selfPopup.css("left", "15px");
        //        }
        //if ($.browser.msie && $.browser.version.substr(0, 1) == 7 && document.documentMode == 9) {
            marginLeft -= 22;
            selfPopup.css("left", "15px");
        //}

        $("#overlay").fadeIn('fast', function () {
            selfPopup.fadeIn('slow');
        });
    }
}

function getActuarialItems(me, itemType) {
    var url = window.g_baseUrl;
    if (itemType == 'File') {
        url += "/Report/GetActuarialReports?folderPath=" + me.attr('data-path');
    }
    else if (itemType == 'Folder') {
        url += "/Report/GetActuarialFolders?system=" + system;
    }

    $.ajax({
        type: 'GET',
        url: url,
        async: false,
        success: function (data) {
            $("#actuarialItems").html(data);
            adjustCrossBrowser();
        },
        statusCode: {
            403: function () {
                // forbidden (when users lost session) -> redirect to login page
                window.location.href = window.g_baseUrl + "/account/login";
            }
        }
    });
}

function closeCabinetPopup() {
    $(".viewCabinetContent").fadeOut('slow', function () {
        $("#overlay").fadeOut('fast');
    });
}

function adjustCrossBrowser() {
    if ($.browser.msie && $.browser.version.substr(0, 1) < 8) {
        // adjust width
        $(".viewCabinetContent table").css("width", "97.5%");
    }

    // append 'file:' element for network folder path
//    $("a.actuarialFolderPath").each(function (i, e) {
//        if ($(this).attr('href').indexOf('file:') < 0)
//            $(this).attr('href', 'file:' + $(this).attr('href'));
//    });
}