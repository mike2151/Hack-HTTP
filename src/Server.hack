namespace HttpHack\Server;

require_once("../vendor/autoload.hack");
use namespace HH\Lib\Str;

function get_protocol(string $input): string {
  return "HTTP/1.1";
}

function get_status(string $input): string {
  return "200 OK";
}

function get_content_type(string $input): string {
  return "Content-Type: text/plain";
}

function get_content_length(string $response_body): string {
  $length = \Strval(Str\length($response_body));
  return "Content-Length: ".$length;
}

function get_content_body(string $input): string {
  return "Hello world!";
}

function respond(string $input) {
  $protocol = get_protocol($input);
  $status = get_status($input);
  $content_type = get_content_type($input);
  $content_body = get_content_body($input);
  $content_length = get_content_length($content_body);
  $return_string = $protocol.
    " ".
    $status.
    "\n".
    $content_type.
    "\n".
    $content_length.
    "\n\n".
    $content_body;
  return $return_string;
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
