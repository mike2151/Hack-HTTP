namespace HttpHack\Server;

function tear_down_server(resource $socket) : void {
    \socket_close($socket);
}

function listen_loop(resource $socket) : void {
    \socket_bind($socket, 'localhost', 9000);
    // 10 is the number of connections allowed
    \socket_listen($socket, 10);
    for (;;) {
        // accept the incoming connection, print the data and then disconnect
        $client = \socket_accept($socket);
        $input = \socket_read($client, 1024000);
        print($input);
        \socket_close($client);
    }
}

<<__EntryPoint>>
function server() : int {
    // simple socket to begin - listen and send a message
    // use \ to call a PHP function. These are PHP functions for networking
    // variables below can be found here: https://www.php.net/manual/en/function.socket-create.php
    $socket = \socket_create(\AF_INET, \SOCK_STREAM, \SOL_TCP);

    listen_loop($socket);

    tear_down_server($socket);
    return 0;
}
