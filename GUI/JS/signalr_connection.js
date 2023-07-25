var last_unread_message_id;



$(function () {
    var connection = $.hubConnection();
    var hubProxy = connection.createHubProxy('chatHub');

    hubProxy.on('ReceiveMessage', async function (message) {

        message = JSON.parse(message);

        Saved_Messages[message.Id] = message;


        let last_read_message = lastRenderedMessage;

        latest_message_id = message.Id;
        await renderMessage(message);


        if (Users.CLIENT_USER.Id == message.UserId || getScrollPos() < scroll.clientHeight/2 && focused) {


            setTimeout(function () {
                markasread(null, false);
                scrollBottom();
            }, 0);
        }
        else {


       
            let new_messages_ever_since = latest_message_id - last_read_message;
            let old_bar_exists = $("#markasread_active").length > 0;
            let new_bar = old_bar_exists ? $("#markasread_active") : new_messages_template.clone();
            if (!old_bar_exists) {
                new_bar.attr("id", "markasread_active");

                new_bar.insertAfter(Saved_Messages[last_read_message].message_element);

                unread_messages_ele.css("display", "");

                let date = FormatFuncs["_timestr_"](Saved_Messages[last_read_message + 1]);


            

                unread_messages_ele.find(".unread_notif_message").text(`Bạn có ${new_messages_ever_since} chưa đọc kể từ ${date}`);

                last_unread_message_id = last_read_message;
            }
            else {
                console.log(latest_message_id - last_unread_message_id)
                let new_messages_ever_since = latest_message_id - last_unread_message_id;

                var old_text = unread_messages_ele.find(".unread_notif_message").text();
                console.log(old_text);
                var new_str = old_text.replace(/\d+/, new_messages_ever_since);
                console.log(new_str);
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