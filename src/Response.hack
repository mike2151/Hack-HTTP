namespace HttpHack\Responses;

use namespace HH\Lib\Str;
use type HttpHack\Requests\Request;

class Response {

  private Request $request;

  public function __construct(Request $req) {
    $this->request = $req;
  }

  private function getProtocol(): string {
    return "HTTP/1.1";
  }

  private function getStatus(): string {
    return "200 OK";
  }

  private function getContentType(): string {
    return "Content-Type: text/plain";
  }

  private function getContentLength(string $response_body): string {
    $length = \Strval(Str\length($response_body));
    return "Content-Length: ".$length;
  }

  private function getContentBody(): string {
    return "Hello world!";
  }

  public function getResponse(): string {
    $protocol = $this->getProtocol();
    $status = $this->getStatus();
    $content_type = $this->getContentType();
    $content_body = $this->getContentBody();
    $content_length = $this->getContentLength($content_body);
    return $protocol.
      " ".
      $status.
      "\n".
      $content_type.
      "\n".
      $content_length.
      "\n\n".
      $content_body;
  }
}
