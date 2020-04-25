namespace HttpHack\Server;

require_once(__DIR__."/../../vendor/autoload.hack");
use type HttpHack\Server\{Request, Response};

function listen_loop(resource $socket, int $port_num, string $directory): void {
  \socket_bind($socket, 'localhost', $port_num);
  print("Listening on port ".$port_num."\n");
  // 10 is the number of connections allowed
  \socket_listen($socket, 10);
  for (; ; ) {
    // accept the incoming connection, print the data and then disconnect
    $client = \socket_accept($socket);
    $input = \socket_read($client, 1024000);
    $request = new Request($input);
    $response = new Response($request, $directory);
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

function server(array<string> $argv): int {
  \Facebook\AutoloadMap\initialize();
  // simple socket to begin - listen and send a message
  // use \ to call a PHP function. These are PHP functions for networking
  // variables below can be found here: https://www.php.net/manual/en/function.socket-create.php
  $socket = \socket_create(\AF_INET, \SOCK_STREAM, \SOL_TCP);

  $port_num = 9000;
  $directory = __DIR__."/../../www";
  $argc = \count($argv);
  if ($argc >= 2) {
    $port_num = \intval($argv[1]);
  }
  if ($argc >= 3) {
    $directory = __DIR__."/".$argv[2];
  }
  listen_loop($socket, $port_num, $directory);

  tear_down_server($socket);
  return 0;
}

server($argv);
