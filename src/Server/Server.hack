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

function is_dir_child_of(string $dir1, string $dir2): bool {
  $curr_dir = $dir1;
  $is_valid_dir = false;
  while ($curr_dir !== "/") {
    if ($curr_dir === $dir2) {
      $is_valid_dir = true;
      break;
    }
    $curr_dir = \dirname($curr_dir);
  }
  return $is_valid_dir;
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
    $directory_name = __DIR__."/".$argv[2];
    if (!\file_exists($directory_name)) {
      print("Error: Directory does not exist\n");
      return 1;
    }
    // check the directory is inside the root and not accessing elsewhere in the system
    $directory = \realpath($directory_name);
    $root_dir = \realpath(__DIR__."/../../");
    if (!is_dir_child_of($directory, $root_dir)) {
      print("Error: Folder is not a child of server root dir\n");
      return 1;
    }
  }
  listen_loop($socket, $port_num, $directory);

  tear_down_server($socket);
  return 0;
}

server($argv);
