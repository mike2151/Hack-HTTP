namespace HttpHack\Requests;

use namespace HH\Lib\Str;

class Request {

  private string $request;
  private string $host;
  private string $accept_type;
  private string $user_agent;
  private string $accept_language;
  private string $accept_encoding;
  private string $connection_type;

  public function __construct(string $req) {
    $all_lines = Str\split($req, "\n");
    $this->request = $all_lines[0];
    foreach ($all_lines as $line) {
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

  public function getRequest(): string {
    return $this->request;
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
