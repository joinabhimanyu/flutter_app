import 'package:http/http.dart' as http;

class ResponseModel {
  http.Response response;
  bool errorCode;
  String errorMessage;

  ResponseModel(
      {this.response = null, this.errorCode = false, this.errorMessage = ''}) {
    if (this.errorCode == null) {
      throw new ArgumentError('Error code cannot be null');
    }
    if (this.errorMessage == null) {
      throw new ArgumentError('Error message cannot be null');
    }
  }
}
