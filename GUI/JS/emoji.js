
var Emoji_Insert_Cooldown = {}
async function ToggleEmoji(id) {
    id = parseInt(id.match(/\d+/));
    if (Emoji_Insert_Cooldown[id] == true) { return; }

  
    var ele = $(`.chat-main__item[message_id=${ellips.attr("Message_Id")}]`).find(`.emoji_display[emoji_id=${id}]`);
    if (ele[0] != null && ele.hasClass("emoji_display_active")) return;
    Emoji_Insert_Cooldown[id] = true;
    await $.ajax({
        url: 'Message.aspx/ToggleEmoji',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: `{ "Message_Id": ${ellips.attr("Message_Id")},"Emoji_Id": ${id}}`,
        success: function (response) {


        },
        error: function (xhr, status, error) {
            // Handle any errors
            console.error(error);
        }
    });
    Emoji_Insert_Cooldown[id] = false;
}


$(".Emoji").on("click", function (e) {
    var id = $(e.target).attr("id")
    
    if (id.includes("Emoji_")) {
        ToggleEmoji(id);

    }
})

var lastindexednum = 0;





function getRandomNumberBetween(min, max) {
    return Math.random() * (max - min) + min;
}






