$(".Emoji").on("click", function (e) {
    var id = $(e.target).attr("id")
    console.log(id);
    if (id.includes("Emoji_")) {
        
        __doPostBack("InsertEmoji", `{ "Message_Id": ${ellips.attr("Message_Id")},"Emoji_Id": ${parseInt(id.match(/\d+/))}}`)
    }
})