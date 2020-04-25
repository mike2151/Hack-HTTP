namespace HttpHack\Server;

use namespace HH\Lib\Str;
use type HttpHack\Server\Request;

class Response {

  // passed in params
  private Request $request;
  private string $directory;

  // state variables
  private bool $is_file_request;
  private bool $file_exists;
  private string $file_extension;
  private string $file;

  public function __construct(Request $req, string $dir) {
    $this->request = $req;
    $this->directory = $dir;

    $this->file = $req->getRequestFile();
    $this->is_file_request = $this->isFileRequest();
    $this->file_exists = $this->doesFileExist();
    $this->file_extension = $this->getFileExtension();
  }

  private function getProtocol(): string {
    return "HTTP/1.1";
  }

  private function getStatus(): string {
    return $this->file_exists ? "200 OK" : "404 Not Found";
  }

  private function getFileExtension(): string {
    $extension = "";
    if ($this->is_file_request) {
      $extension = Str\split($this->file, ".")[1];
    }
    return $extension;
  }

  private function getContentType(): string {
    $content_type = "text/plain";
    if ($this->is_file_request && $this->file_exists) {
      switch ($this->file_extension) {
        case "html":
          $content_type = "text/html";
          break;
        default:
          break;
      }
    }
    return "Content-Type: ".$content_type;
  }

  private function getContentLength(string $response_body): string {
    $length = \Strval(Str\length($response_body));
    return "Content-Length: ".$length;
  }

  private function isFileRequest(): bool {
    return Str\contains($this->file, ".");
  }

  private function doesFileExist(): bool {
    return \file_exists($this->directory.$this->file);
  }

  private function getFileResponse(): string {
    $return_message = "File does not exist";
    if ($this->file_exists) {
      $return_message = \file_get_contents($this->directory.$this->file);
    }
    return $return_message;
  }

  private function getContentBody(): string {
    $default_message = "Main Page of Web Server";
    return $this->is_file_request
      ? $this->getFileResponse($this->file)
      : $default_message;
  }

  public function getResponse(): string {
    $protocol = $this->getProtocol();
    $content_body = $this->getContentBody();
    $status = $this->getStatus();
    $content_type = $this->getContentType();
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
