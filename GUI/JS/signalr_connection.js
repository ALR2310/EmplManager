$(function () {
    var connection = $.hubConnection();
    var hubProxy = connection.createHubProxy('chatHub');

    hubProxy.on('ReceiveMessage', async function (message) {
        message = JSON.parse(message);

        Saved_Messages[message.Id] = message;
        await   renderMessage(message);
        
   
        if (Users.CLIENT_USER.Id == message.UserId || getScrollPos() < 200) { setTimeout(scrollBottom, 10); }
       
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