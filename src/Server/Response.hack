namespace HttpHack\Server;

use namespace HH\Lib\Str;
use type HttpHack\Server\Request;

class Response {

  private Request $request;
  private string $directory;

  public function __construct(Request $req, string $dir) {
    $this->request = $req;
    $this->directory = $dir;
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

  private function isFileRequest(): bool {
    $request_file = $this->request->getRequestFile();
    return $request_file !== "/";
  }

  private function getFileBody(): string {
    return "this is a file";
  }

  private function getContentBody(boolean is_file_request): string {
    $default_message = "Main Page of Web Server";
    return is_file_request ? $this->getFileBody() : $default_message;
  }

  public function getResponse(): string {
    $is_file_request = $this->isFileRequest();
    $protocol = $this->getProtocol();
    $status = $this->getStatus();
    $content_type = $this->getContentType();
    $content_body = $this->getContentBody($is_file_request);
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
