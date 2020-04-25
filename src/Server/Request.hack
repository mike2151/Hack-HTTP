namespace HttpHack\Server;

use namespace HH\Lib\{C, Str};

class Request {

  private string $request_type;
  private string $request_file;
  private string $http_version;
  private string $host;
  private string $accept_type;
  private string $user_agent;
  private string $accept_language;
  private string $accept_encoding;
  private string $connection_type;

  private function setFirstLineVariables(string $first_line): void {
    $headers = Str\split($first_line, " ");
    $this->request_type = $headers[0];
    $this->request_file = $headers[1];
    $this->http_version = $headers[2];
  }

  public function __construct(string $req) {
    $all_lines = Str\split($req, "\n");

    $this->setFirstLineVariables($all_lines[0]);

    $num_lines = C\count($all_lines);
    for ($i = 1; $i < $num_lines; $i += 1) {
      $line = $all_lines[$i];
      if (Str\contains($line, "Host:")) {
        $this->host = $line;
      } else if (Str\contains($line, "Accept:")) {
        $this->accept_type = $line;
      } else if (Str\contains($line, "User-Agent:")) {
        $this->user_agent = $line;
      } else if (Str\contains($line, "Acceppt-Language:")) {
        $this->accept_language = $line;
      } else if (Str\contains($line, "Accept-Encoding:")) {
        $this->accept_encoding = $line;
      } else if (Str\contains($line, "Connection:")) {
        $this->connection_type = $line;
      }
    }
  }

  public function getRequestType(): string {
    return $this->request_type;
  }

  public function getRequestFile(): string {
    return $this->request_file;
  }

  public function getHttpVersion(): string {
    return $this->http_version;
  }

  public function getHost(): string {
    return $this->host;
  }

  public function getAcceptType(): string {
    return $this->accept_type;
  }

  public function getUserAgent(): string {
    return $this->user_agent;
  }

  public function getAcceptLanguage(): string {
    return $this->accept_language;
  }

  public function getAcceptEncoding(): string {
    return $this->accept_encoding;
  }

  public function getConnectionType(): string {
    return $this->connection_type;
  }


}
