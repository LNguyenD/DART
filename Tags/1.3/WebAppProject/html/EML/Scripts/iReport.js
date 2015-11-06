$(document).ready(function () {
    $("table[name=tbGrid] td[title!='']").each(function () {
        if ($(this).attr("title") != undefined && $(this).attr("title") !="") {
            if ($(this).children("a").length > 0) {
                $(this).children("a").html("");
            }
            else {
                $(this).html("");
            }
        }
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

    // Paging dropdown change
    $('#cboDisplayEntry').change(function () {
        $("#hddPaging").val("");
        $('form').submit();
    });

    // Not item found 
    if ($("table[name=tbGrid]").length > 0) {
        if ($("table[name=tbGrid] > tbody").length <= 0) {
            var colNo = $("table[name=tbGrid] > thead > tr > th").length > 0 ? $("table[name=tbGrid] > thead > tr > th").length : 20;
            $("table[name=tbGrid]").append("<tbody><tr class='gradeA odd'><td colspan='" + colNo + "' style='text-align:center;color:Red;height:80px;'>No item found!</td></tr></tbody>");
        }
    }
    //
    $("input[class*=disable]").each(function () {
        $(this).attr("disabled", "disabled");
    });
    $("span[class*=message]").click(function () {
        $(this).toggleClass('hide');
    });
    //    $(".datepicker").datepicker({ 'dateFormat': 'dd/mm/yy' });   

    if ($("div.Paging span.ui-state-disabled").length > 0) {
        $("div.Paging span.ui-state-disabled").children().toggleClass('Disable');
    }
    if ($("div.Paging span.fg-button").length > 0) {
        $("div.Paging span.fg-button").parent().css('float', 'left');
        $("div.Paging span.fg-button").removeClass().addClass('Button');
    }

    $("div.Paging a[href*='page']").each(function () {
        $(this).attr("title", this.href.substring(this.href.indexOf('?page=') + 6, this.href.length));
        $(this).removeAttr("href");
        $(this).removeAttr("data-ajax");

        $(this).bind('click', function () {
            $("#hddPaging").val($(this).attr('title'));
            $('form').submit();
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
    var objSorts = $("table[name*='tbGrid'] >thead >tr >th:not(:first)").not("th[class*=action]");
    if ($("input[name=chkAll]").length <= 0) {
        objSorts = $("table[name*='tbGrid'] >thead >tr >th").not("th[class*=action]");
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
            $('form').submit();
        }
    });

    if ($("#hddSort").length > 0 && $("#hddSort").val() != "") {
        $("table[name*='tbGrid'] >thead >tr >th[sortby=" + $("#hddSort").val().split('|')[0] + "]").attr("sortdir", $("#hddSort").val().split('|')[1]);
        if ($("#hddSort").val().split('|')[1].indexOf("asc") >= 0)
            $("table[name*='tbGrid'] >thead >tr >th[sortby=" + $("#hddSort").val().split('|')[0] + "]").children("span").removeClass().addClass('css_right ui-icon ui-icon-triangle-1-n');
        else
            $("table[name*='tbGrid'] >thead >tr >th[sortby=" + $("#hddSort").val().split('|')[0] + "]").children("span").removeClass().addClass('css_right ui-icon ui-icon-triangle-1-s');
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
        $('input[name=chkItem]:checked').each(function (index) {
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

    $("a[id*=favorite]").click(function () {
        $("#hddAction").val("favorite" + "|" + $(this).attr("id").replace("favorite_", ""));
        var Msg = "Are you sure that you want to add favorite for the selected item?";
        if ($(this).attr("class")!=undefined && $(this).attr("class").indexOf("none_favorite") >= 0 || $(this).attr("title").indexOf("remove") >= 0) {
            Msg = "Are you sure that you want to remove favorite for the selected item?";
        }
        confirmSubmit("Notification!", Msg);
    });

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

    $('input[name=chkItemAll]').click(function () {
        if ($(this).attr("checked")) {
            $("input[name=chkItem" + "_" + $(this).val() + "]").attr("checked", true);
        }
        else {
            $("input[name=chkItem" + "_" + $(this).val() + "]").attr("checked", false);
        }
    });
    $('#cmdSave_SystemRole').click(function () {
        if ($('input[value*="_"]:checked').length > 0) {
            $("#hddSystemPermission").val($('input[value*="_"]:checked').map(function () { return $(this).val(); }).get().join(","));
            $('form').submit();
        }
        else {
            confirmOK("Warning!", "You must select at least one system permission.")
        }
    });
    //End System Role

    // Audit Trail   

    $('#cboAuditList').change(function () {
        $("#hddSort").val("");
        $("#search_input").val("");
        if ($("#txtStartDateAudit").length > 0) {
            $("#txtStartDateAudit").val("mm/dd/yyyy");
        }
        if ($("#txtEndDateAudit").length > 0) {
            $("#txtEndDateAudit").val("mm/dd/yyyy");
        }
        $('form').submit();
    });

    $('#txtStartDateAudit,#txtEndDateAudit').click(function (e) {
        e.stopPropagation();
        if ($(this).val() == "mm/dd/yyyy") {
            $(this).val("");
        }
    });

    $(document).click(function () {
        if ($('#txtStartDateAudit').length > 0 && $('#txtStartDateAudit').val() == "") {
            $('#txtStartDateAudit').val("mm/dd/yyyy");
        }
        if ($('#txtEndDateAudit').length > 0 && $('#txtEndDateAudit').val() == "") {
            $('#txtEndDateAudit').val("mm/dd/yyyy");
        }
    });

    $("a#btnAuditSearch").click(function () {
        $("#hddPaging").val("");
        $("#hddSort").val("");
        try {
            if ($("#txtStartDateAudit").val() != "" && $("#txtStartDateAudit").val() != "mm/dd/yyyy") {
                //                $.datepicker.parseDate('mm/dd/yyyy', $("#txtStartDateAudit").val());
            }
            if ($("#txtEndDateAudit").val() != "" && $("#txtEndDateAudit").val() != "mm/dd/yyyy") {
                //                $.datepicker.parseDate('mm/dd/yyyy', $("#txtEndDateAudit").val());
            }
            $('form').submit();
        } catch (e) {
            confirmOK("Warning!", "Date time is wrong format. Please check again!");
        };
    });
    //End Audit Trail

    //double list
    $('.img-check').click(function () {
        $(this).toggleClass('checked');
    });
    if ($('.left-list ul').children().length == 0)
        $('#cmdAssign').addClass('hide');
    $('#cmdAssign').click(function () {
        $("#action").attr("value", "assign");
        $("#firstList").val("");
        $('input[name=chkFirst].checked').each(function (index) {
            switch ($("#firstList").val()) {
                case "":
                    $("#firstList").val($(this).attr("roleId"));
                    break;
                default:
                    $("#firstList").val($("#firstList").val() + "," + $(this).attr("roleId"));
                    break;
            }
        });
        $('form').submit();
    });
    //end double list
});

function GetStringByLength(width, text) {
    if (text != undefined && text != "") {
        var length = width * 0.195;
        if (text.length > length) {
            return text.substring(0, length - 8) + "...";
        }
        else
            return text;
    }
    else
        return "";
}
function ArrangeLevel() {
    $("#tree-wrap ul li[rel=root]").each(function (index, value) {
        if ($.browser.msie && parseInt($.browser.version) == 7) {
            $(".jstree-closed > .jstree-icon").css({ 'top': "-10px" });            
        }
        if (index == 0) {
            $(this).css({ 'marginLeft': "" });           
        }
        else {
            var prev = $('#tree-wrap ul li[rel=root]:eq(' + (index - 1) + ')');
            $(this).css({ 'marginLeft': (parseInt(prev.css('marginLeft').replace("px", "")) + 50) + "px" });           
        }       
    });
}
$(function () {
    if ($("#tree-wrap").length > 0) {
        $('#tree-wrap a').click(function (event) {
            window.location = $(this).attr("href");
        });
        $("#tree-wrap").bind("move_node.jstree", function (e, data) {
            ArrangeLevel();
            if ($(data.rslt.o).attr("id").indexOf("level") >= 0) {
                $.post("organisation_level", { itype: "level", data: $('#tree-wrap ul li[rel=root]').map(function (index) { return this.id.replace("level_", "") + "|" + index; }).get().join(',') }, function (data) { });
            }
            else {
                $.post("organisation_level", { itype: "role", lid: $(data.rslt.np).attr("id").replace("level_", ""), rid: $(data.rslt.o).attr("id").replace("role_", "") });
            }
        });
        $("#tree-wrap").bind("open_node.jstree", function (e, data) {
            ArrangeLevel();
        });
        $("#tree-wrap").bind("close_node.jstree", function (e, data) {
            ArrangeLevel();
        });
        $("#tree-wrap").bind("loaded.jstree", function (event, data) {
            ArrangeLevel();
        });
        $("#tree-wrap").jstree({
            "types": {
                "valid_children": ["root"],
                "types": {
                    "root": {
                        "icon": {
                            "image": ""
                        },
                        "valid_children": ["default"],
                        "max_depth": 2,
                        "hover_node": false,
                        "select_node": function () { return false; }
                    },
                    "default": {
                        "valid_children": ["default"],
                        "start_drag": function (el) {
                            if (el.children("a").attr("class").toLowerCase().indexOf("inactive") >= 0 || (el.parent("ul").prev("a").length >0 && el.parent("ul").prev("a").attr("class").toLowerCase().indexOf("inactive") >= 0)) {
                                return false;
                            }
                            else {
                                return true;
                            }
                        }
                    }
                }
            },
            "plugins": ["themes", "html_data", "dnd", "ui", "types"]
        });
    }
});  

