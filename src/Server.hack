namespace HttpHack\Server;

function tear_down_server(resource $socket): void {
  \socket_close($socket);
}


function respond(string $input) {
  return
    "HTTP/1.1 200 OK\nContent-Type: text/plain\nContent-Length: 12\n\nHello world!";
}
function listen_loop(resource $socket): void {
  \socket_bind($socket, 'localhost', 9000);
  // 10 is the number of connections allowed
  \socket_listen($socket, 10);
  for (; ; ) {
    // accept the incoming connection, print the data and then disconnect
    $client = \socket_accept($socket);
    $input = \socket_read($client, 1024000);
    $response = respond($input);
    $write_res = \socket_write($client, $response);
    if ($write_res === 0) {
      print("An error has occured with writing\n");
    }
    \socket_close($client);
  }
}


<<__EntryPoint>>
function server(): int {
  // simple socket to begin - listen and send a message
  // use \ to call a PHP function. These are PHP functions for networking
  // variables below can be found here: https://www.php.net/manual/en/function.socket-create.php
  $socket = \socket_create(\AF_INET, \SOCK_STREAM, \SOL_TCP);

  listen_loop($socket);

  tear_down_server($socket);
  return 0;
}
