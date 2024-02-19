
abstract class NetworkManagerRepository<T> {

  Future<T?> makeRequest(String endpointUrl, Map<String, String>? headers) async {
    return null;
  }

  Future<List<T>?> makeRequestList(String endpointUrl, Map<String, String>? headers) async {
    return null;
  }

}