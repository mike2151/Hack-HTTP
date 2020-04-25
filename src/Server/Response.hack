namespace HttpHack\Server;

use namespace HH\Lib\Str;
use type HttpHack\Server\Request;

class Response {

  private Request $request;
  private string $directory;
  private bool $file_not_found;

  public function __construct(Request $req, string $dir) {
    $this->request = $req;
    $this->directory = $dir;
    $this->file_not_found = false;
  }

  private function getProtocol(): string {
    return "HTTP/1.1";
  }

  private function getStatus(): string {
    return $this->file_not_found ? "404 Not Found" : "200 OK";
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

  private function doesFileExist(string $file): bool {
    return \file_exists($this->directory.$file);
  }

  private function getFileResponse(string $file): string {
    $file_exists = $this->doesFileExist($file);
    $return_message = "File Exists";
    if (!$file_exists) {
      $return_message = "File does not exist";
      $this->file_not_found = true;
    }
    return $return_message;
  }

  private function getContentBody(bool $is_file_request): string {
    $default_message = "Main Page of Web Server";
    $file = $this->request->getRequestFile();
    return $is_file_request ? $this->getFileResponse($file) : $default_message;
  }

  public function getResponse(): string {
    $is_file_request = $this->isFileRequest();
    $protocol = $this->getProtocol();
    $content_type = $this->getContentType();
    $content_body = $this->getContentBody($is_file_request);
    $status = $this->getStatus();
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
