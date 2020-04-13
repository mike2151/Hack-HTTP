namespace HttpHack\Server;

require_once(__DIR__."/../vendor/autoload.hack");
use type HttpHack\Requests\Request;
use type HttpHack\Responses\Response;


function listen_loop(resource $socket): void {
  \socket_bind($socket, 'localhost', 9000);
  // 10 is the number of connections allowed
  \socket_listen($socket, 10);
  for (; ; ) {
    // accept the incoming connection, print the data and then disconnect
    $client = \socket_accept($socket);
    $input = \socket_read($client, 1024000);
    $request = new Request($input);
    $response = new Response($request);
    $response_msg = $response->getResponse();
    $write_res = \socket_write($client, $response_msg);
    if ($write_res === 0) {
      print("An error has occured with writing\n");
    }
    \socket_close($client);
  }
}

function tear_down_server(resource $socket): void {
  \socket_close($socket);
}

<<__EntryPoint>>
function server(): int {
  \Facebook\AutoloadMap\initialize();
  // simple socket to begin - listen and send a message
  // use \ to call a PHP function. These are PHP functions for networking
  // variables below can be found here: https://www.php.net/manual/en/function.socket-create.php
  $socket = \socket_create(\AF_INET, \SOCK_STREAM, \SOL_TCP);

  listen_loop($socket);

  tear_down_server($socket);
  return 0;
}
