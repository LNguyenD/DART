$(function () {
    $('#btnOkModal').unbind('click').click(function () {
        deleteAllConfirmed();
    })
});

function deleteAllConfirmed() {
    var controllerName = $('input[type="hidden"][id="controllerName"]').val();
    var url = window.g_baseUrl + "/" + controllerName + "/DeleteAll";
    $.ajax({
        type: 'POST',
        url: url,
        data:
        {
            systemid: $("#SystemId").val(),
            "__RequestVerificationToken": $('input[name="__RequestVerificationToken"]').val()
        },
        success: function (data) {
            location.reload();
        },
        error: function () {
            $('#errorMessage').show();
        }
    });
}