$(document).ready(function () {
    // hack ie7    
    if ($.browser.msie && parseInt($.browser.version, 10) == 7) {
        $("td:empty").html("&nbsp;");
    }

    // set cursor pointer for tablix's heading
    $("td[sortdir='']").css("cursor", "pointer");

    $("a[id*=favorite]").click(function () {
        $("#hddAction").val("favorite" + "|" + $(this).attr("id").replace("favorite_", ""));
        var Msg = "Are you sure that you want to add favorite for the selected item?";
        if ($(this).attr("class") != undefined && $(this).attr("class").indexOf("none_favorite") >= 0 || $(this).attr("title").indexOf("remove") >= 0) {
            Msg = "Are you sure that you want to remove favorite for the selected item?";
        }
        confirmSubmit("Notification!", Msg);
    });

    $("table[name=tbGrid] td[title!='']").each(function () {
        if ($(this).attr("title") != undefined && $(this).attr("title") != "") {
            if ($(this).children("a").length > 0) {
                $(this).children("a").html(GetStringByLength($(this).width(), $(this).attr("title")));
            }
            else {
                $(this).html(GetStringByLength($(this).width(), $(this).attr("title")));
            }
        }
    });

    $('#cboCategory').change(function () {
        $('form').submit();
    });

    $("#cboDisplayEntry").next("div").children("ul").children("li").children("a").attr("href", "javascript:void(0)");

    $("#cboDisplayEntry").next("div").children("ul").children("li").children("a").click(function () {
        $("#hddPaging").val("");
        $('#cboDisplayEntry').val($(this).attr("rel"));
        var cookieName = document.URL.toLowerCase() + "_" + $.trim($("div.topLink > p").html().replace("Hello", "")).toLowerCase() + "_pagesize";
        cookieName = cookieName.replace(/\//g, '_').replace(/\:/g, '_').replace(/\?/g, '_').replace(/\&/g, '_').replace(/\=/g, '_');
        $.cookie(cookieName, $(this).attr("rel"));
        $('form').submit();
    });

    $("input[id='btnSearch']").mousedown(function () {
        $("#hddPaging").val("");
    });

    // System change
    $('#cboSystem').change(function () {
        $("#hddPaging").val("");
        $('form').submit();
    });

    $("#cboUserType").next("div").children("ul").children("li").children("a").attr("href", "javascript:void(0)");

    $("#cboUserType").next("div").children("ul").children("li").children("a").click(function () {        
        $("#hddPaging").val("");
        $('#cboUserType').val($(this).attr("rel"));
        $('form').submit();
    });

    // Not item found 
    if ($("table[name=tbGrid]").length > 0) {
        if ($("table[name=tbGrid] > tbody > tr").length <= 0) {
            var colNo = $("table[name=tbGrid] > thead > tr > td").length > 0 ? $("table[name=tbGrid] > thead > tr > td").length : 20;
            $("table[name=tbGrid]").append("<tbody><tr class='gradeA odd'><td colspan='" + colNo + "' style='text-align:center;vertical-align:middle;color:Red;height:80px;'>No item found!</td></tr></tbody>");
        }
    }
    //
    $("input[class*=disable]").each(function () {
        $(this).attr("disabled", "disabled");
    });
    $("span[class*=message]").click(function () {
        $(this).toggleClass('hide');
    });

    $("div.Paging a[href*='page']").each(function () {
        $(this).attr("title", this.href.substring(this.href.indexOf('page=') + 5, this.href.length));
        $(this).removeAttr("href");
        $(this).removeAttr("data-ajax");

        $(this).bind('click', function () {
            $("#hddPaging").val($(this).attr('title'));
            $(this).closest("form").submit();
        });
    });

    $('input[name=chkAll]').click(function () {
        if ($(this).attr("checked")) {
            $("input[name=chkItem]").attr("checked", true);
        }
        else {
            $("input[name=chkItem]").attr("checked", false);
        }
    });

    $("table[name=tbGrid] > thead >tr >th:first img").parent("a").attr("href", "javascript:void(0)");
    $("table[name=tbGrid] > thead >tr >th:first img").click(function () {
        if ($(this).attr("src").indexOf("checkboxUnchecked") >= 0) {
            $("img[src*='checkboxUnchecked']").attr("src", window.g_baseUrl + "/images/form_element/checkboxChecked.gif");
            $(this).attr("src", window.g_baseUrl + "/images/form_element/checkboxChecked.gif");
        }
        else {
            $("img[src*='checkboxChecked']").attr("src", window.g_baseUrl + "/images/form_element/checkboxUnchecked.gif");
            $(this).attr("src", window.g_baseUrl + "/images/form_element/checkboxUnchecked.gif");
        }
    });

    $('input[name=chkAllSecondList]').click(function () {
        if ($(this).attr("checked")) {
            $("input[name=chkItemSecondList]").attr("checked", true);
        }
        else {
            $("input[name=chkItemSecondList]").attr("checked", false);
        }
    });

    $('#cmdSave,#cmdAccept').click(function () {
        $('form').submit();
    });

    // Begin Sort 
    var objSorts = $("table[name*='tbGrid'] >thead >tr >td").not("td[class*=action]");
    if ($("input[name=chkAll]").length <= 0) {
        objSorts = $("table[name*='tbGrid'] >thead >tr >td").not("td[class*=action]");
    }

    objSorts.mouseover(function () {
        if ($(this).attr("sortdir") == "") {
            $(this).children("span").removeClass().addClass('css_right ui-icon ui-icon-triangle-1-n');
        }
        else {
            if ($(this).attr("sortdir") == "desc")
                $(this).children("span").removeClass().addClass('css_right ui-icon ui-icon-triangle-1-n');
            else
                $(this).children("span").removeClass().addClass('css_right ui-icon ui-icon-triangle-1-s');
        }
    });

    objSorts.mouseout(function () {
        if ($(this).attr("sortdir") == "") {
            if ($(this).children().size() > 0) {
                $(this).children("span").removeClass().addClass("css_right ui-icon ui-icon-carat-2-n-s");
            }
        }
        else {
            if ($(this).attr("sortdir") == "desc")
                $(this).children("span").removeClass().addClass('css_right ui-icon ui-icon-triangle-1-s');
            else
                $(this).children("span").removeClass().addClass('css_right ui-icon ui-icon-triangle-1-n');
        }
    });

    objSorts.click(function () {
        if ($(this).attr("sortdir") == "" || $(this).attr("sortdir") == "desc") {
            $(this).attr("sortdir", "asc")
        }
        else {
            $(this).attr("sortdir", "desc")
        }
        if ($(this).attr("sortby") != "undefined" && $(this).attr("sortby") != null) {
            $("#hddSort").val($(this).attr("sortby") + "|" + $(this).attr("sortdir"));
            var cookieName = document.URL.toLowerCase() + "_" + $.trim($("div.topLink > p").html().replace("Hello", "")).toLowerCase() + "_sort";
            cookieName = cookieName.replace(/\//g, '_').replace(/\:/g, '_').replace(/\?/g, '_').replace(/\&/g, '_').replace(/\=/g, '_');
            $.cookie(cookieName, $("#hddSort").val());
            $('form').submit();
        }
    });

    if ($("#hddSort").length > 0 && $("#hddSort").val() != "") {
        $("table[name*='tbGrid'] >thead >tr >td[sortby=" + $("#hddSort").val().split('|')[0] + "]").attr("sortdir", $("#hddSort").val().split('|')[1]);
        if ($("#hddSort").val().split('|')[1].indexOf("asc") >= 0)
            $("table[name*='tbGrid'] >thead >tr >td[sortby=" + $("#hddSort").val().split('|')[0] + "]").children("span").removeClass().addClass('css_right ui-icon ui-icon-triangle-1-n');
        else
            $("table[name*='tbGrid'] >thead >tr >td[sortby=" + $("#hddSort").val().split('|')[0] + "]").children("span").removeClass().addClass('css_right ui-icon ui-icon-triangle-1-s');
    }
    // End Sort

    // Submit Action
    $("#search_input").keypress(function (e) {
        if (e.keyCode == 13) {
            $("#hddPaging").val("");
            $('form').submit();
        }
    });
    $('#cmdDelete,#cmdActive,#cmdInActive').click(function () {
        $("#action").attr("value", $(this).attr("value"));
        $("#hddAction").val("");
        $("img[src*='checkboxChecked']").each(function (index) {
            if ($(this).attr("id").indexOf("fakechkId") >= 0) {
                switch ($("#hddAction").val()) {
                    case "":
                        $("#hddAction").val($(this).parent().next().val());
                        break;
                    default:
                        $("#hddAction").val($("#hddAction").val() + "," + $(this).parent().next().val());
                        break;
                }
            }
        });
        if ($("#hddAction").val() != "") {
            $("#hddAction").val($(this).attr("value") + "|" + $("#hddAction").val());
            var Msg = "";
            if ($("#hddAction").val().substring($("#hddAction").val().indexOf("|") + 1, $("#hddAction").val().length).split(',').length > 1) {
                Msg = "Are you sure that you want to " + $(this).attr("id").toLowerCase().replace("cmd", "") + " the selected item(s)?";
            }
            else {
                Msg = Msg = "Are you sure that you want to " + $(this).attr("id").toLowerCase().replace("cmd", "") + " the selected item?";
            }
            if (window.location.pathname.toLowerCase().indexOf("/systemrole") >= 0) {
                if (confirmSubmit("Notification!", "System will also auto delete all users related to this role. " + Msg)) {
                    $('form').submit();
                }
            }
            else {
                confirmSubmit("Notification!", Msg);
            }
        }
        else {
            confirmOK("Warning!", "You must select at least one item to perform this operation.")
        }
    });

    $('#cmdUnAssign').click(function () {
        $("#action").attr("value", $(this).attr("value"));
        $("#hddAction").val("");
        $('input[name=chkItemSecondList]:checked').each(function (index) {
            switch ($("#hddAction").val()) {
                case "":
                    $("#hddAction").val($(this).val());
                    break;
                default:
                    $("#hddAction").val($("#hddAction").val() + "," + $(this).val());
                    break;
            }

        });
        if ($("#hddAction").val() != "") {
            $("#hddAction").val($(this).attr("value") + "|" + $("#hddAction").val());
            confirmSubmit("Notification!", "Are you sure that you want to unassign for the selected item?");
        }
        else {
            confirmOk("Warning!", "You must select at least one item to perform this operation.")
        }
    });
    //End Submit

    // Begin User Report   

    if ($('input[name=Is_External_User]:checked').length > 0 && $('input[name=Is_External_User]:checked').val() == "True") {
        $("#divInternal").hide();
        $("#divExternal").show();
    }
    else {
        $("#divExternal").hide();
        $("#divInternal").show();
    }

    $("input[name=Is_External_User]").change(function () {
        if ($(this).val() == "True") {
            $("#divInternal").hide();
            $("#divExternal").show();
        }
        else {
            $("#divExternal").hide();
            $("#divInternal").show();
        }
    });

    if ($("#cboCategory").length > 0) {
        if ($("a[href*='cId=" + $("#cboCategory").val() + "']").length > 0) {
            $("a[href*='cId=" + $("#cboCategory").val() + "']").parent().removeClass().toggleClass('leaf_selected');
        }
    }

    if ($('input[name=Is_System_User]:checked').length > 0 && $('input[name=Is_System_User]:checked').val() == "True") {
        $("#divSystemUser").show();
        $("#divReportUser").hide();
    }
    else {
        $("#divSystemUser").hide();
        $("#divReportUser").show();
    }

    $('input[name=Is_System_User]').change(function () {
        if ($(this).val() == "True") {
            $("#divSystemUser").show();
            $("#divReportUser").hide();
        }
        else {
            $("#divReportUser").show();
            $("#divSystemUser").hide();
        }
    });
    // End User Report

    // System Role
    $('input[name=chkAll]').click(function () {
        if ($(this).attr("checked")) {
            $.each($('input[name=chkItemAll]'), function (index, value) {
                $(this).attr("checked", true);
                $.each($("input[name=chkItem" + "_" + $(this).val() + "]"), function (index, value) {
                    $(this).attr("checked", true);
                });
            });
        }
        else {
            $.each($('input[name=chkItemAll]'), function (index, value) {
                $(this).attr("checked", false);
                $.each($("input[name=chkItem" + "_" + $(this).val() + "]"), function (index, value) {
                    $(this).attr("checked", false);
                });
            });
        }
    });

    $('input[name=chkItemAll]').prev().children("img").click(function () {
        if ($(this).attr("src").indexOf("checkboxUnchecked") >= 0) {
            $("input[name=chkItem" + "_" + $(this).parent("a").next().val() + "]").prev().children("img").attr("src", window.g_baseUrl + "/images/form_element/checkboxChecked.gif");
        }
        else {
            $("input[name=chkItem" + "_" + $(this).parent("a").next().val() + "]").prev().children("img").attr("src", window.g_baseUrl + "/images/form_element/checkboxUnchecked.gif");
        }
    });
    $('#cmdSave_SystemRole').click(function () {
        if ($('img[src*="checkboxChecked"]').length > 0) {
            $("#hddSystemPermission").val($('img[src*="checkboxChecked"]').parent("a").next("input[value*='_']").map(function () { return $(this).val(); }).get().join(","));
            $('form').submit();
        }
        else {
            confirmOK("Warning!", "You must select at least one system permission.")
        }
    });
    //End System Role
});