$(function () {
    var connection = $.hubConnection();
    var hubProxy = connection.createHubProxy('chatHub');

    hubProxy.on('ReceiveMessage', function (message) {
        message = JSON.parse(message);
        console.log('Received message:', message);
   
        renderMessage(message);
        Saved_Messages[message.Id] = message;
        if (Users.CLIENT_USER.Id == message.UserId) { ScrollBottom(); }
    });

    connection.start()
        .done(function () {
            console.log('SignalR connection started.');
        })
        .fail(function (error) {
            console.error('Error starting SignalR connection:', error);
        });

});