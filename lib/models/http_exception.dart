import 'dart:convert';
import 'package:http/http.dart';

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  factory HttpException.fromResponse(Response response) {
    var errorMessage;
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      errorMessage = responseData['error']['message'];
    } else {
      errorMessage = "Unexpected error";
    }

    return HttpException(errorMessage);
  }

  @override
  String toString() {
    return message;
  }
}
