$(function () {
    var connection = $.hubConnection();
    var hubProxy = connection.createHubProxy('chatHub');

    hubProxy.on('ReceiveMessage', async function (message) {
        message = JSON.parse(message);

   
        await   renderMessage(message);
        Saved_Messages[message.Id] = message;
   
        if (Users.CLIENT_USER.Id == message.UserId || getScrollPos() < 200) { setTimeout(scrollBottom,10); }
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