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
        headers: generateAntiForgeryTokenHeader(),
        url: url,
        data:
        {
            systemid: $("#SystemId").val(),
        },
        success: function (data) {
            location.reload();
        },
        error: function () {
            $('#errorMessage').show();
        }
    });
}