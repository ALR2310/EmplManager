



$(function () {
    var connection = $.hubConnection();
    var hubProxy = connection.createHubProxy('chatHub');

    hubProxy.on('ReceiveMessage', async function (message) {

        message = JSON.parse(message);

      
        Saved_Messages[message.Id] = message;


        let last_read_message = getLastReadMessage();

        latest_message_id = message.Id;
    
        let can_render = latest_message_id == findLatestMessageId() + 1;
 
        if (can_render) {
            console.log("Rendering new Message...");
            loadedbottom = true;
            await renderMessage(message);
        }
        console.log(getScrollPos()  < scroll.clientHeight / 2);
        if (can_render && (Users.CLIENT_USER.Id == message.UserId || getScrollPos() < scroll.clientHeight / 2 && focused)) {

            console.log("Scrolled bottom on new message....");

            scrollBottom();

        }
        if (message.UserId == Users.CLIENT_USER.Id) {
            setLastRenderedMessageCache(message.Id);
        }
 
        if (Users.CLIENT_USER.Id != message.UserId ) {


       
            let new_messages_ever_since = latest_message_id - last_read_message.Id;
            let old_bar_exists = $("#markasread_active").length > 0;

    
            if (!last_unread_message_id) {
                let new_bar = old_bar_exists ? $("#markasread_active") : new_messages_template.clone();
                new_bar.attr("id", "markasread_active");

                var insert_after_ele = $(".chat-main__list").find(`.chat-main__item[message_id=${last_read_message.Id}]`);
                if (insert_after_ele.length != 0) {
                    new_bar.insertAfter(insert_after_ele);

                }
               
                unread_messages_ele.css("display", "");
                 let date = FormatFuncs["_timestr_"](!!last_read_message.AtCreate ? last_read_message : Saved_Messages[Number(last_read_message.Id)+1]);


            

                unread_messages_ele.find(".unread_notif_message").text(`Bạn có ${new_messages_ever_since} tin nhắn chưa đọc kể từ ${date}`);

                last_unread_message_id = last_read_message.Id;
            }
            else {
                unread_messages_ele.css("display", "");
             
                let new_messages_ever_since = latest_message_id - last_unread_message_id;

                var old_text = unread_messages_ele.find(".unread_notif_message").text();
      
                var new_str = old_text.replace(/\d+/, new_messages_ever_since);
      
                unread_messages_ele.find(".unread_notif_message").text(new_str);

            }




          
        }

    });

    hubProxy.on('MessageDeleted', async function (message) {
        DeleteMessage(message);
    });

    hubProxy.on('UpdateReaction', async function (json) {

        var data = JSON.parse(json);
        UpdateMessageReaction(data);
    });


    function connect() {
        connection.start()
            .done(function () {
                console.log('SignalR connection started.');
            })
            .fail(function (error) {

                console.log('Error starting SignalR connection:', error);
                setTimeout(connect, 1000);
            });


    }
    connect();
});