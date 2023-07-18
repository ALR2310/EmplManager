

function ToggleEmoji(id) {
    $.ajax({
        url: 'Message.aspx/ToggleEmoji',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: `{ "Message_Id": ${ellips.attr("Message_Id")},"Emoji_Id": ${parseInt(id.match(/\d+/))}}`,
        success: function (response) {


        },
        error: function (xhr, status, error) {
            // Handle any errors
            console.error(error);
        }
    });
}


$(".Emoji").on("click", function (e) {
    var id = $(e.target).attr("id")
    console.log(id);
    if (id.includes("Emoji_")) {
        ToggleEmoji(id);
     
    }
})