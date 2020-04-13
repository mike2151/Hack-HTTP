namespace HttpHack\Requests;

class Request {
  private string $request;
  public function __construct(string $req) {
    $this->request = $req;
  }
}
