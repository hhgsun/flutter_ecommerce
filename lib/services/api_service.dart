import 'dart:convert';

import 'package:ecommerceapp/models/ApiRequest.dart';
import 'package:http/http.dart' as http;

class ApiService {
  String _baseUrl = "";
  ApiService() {
    // url end domain.com + "/"
    if (_baseUrl[_baseUrl.length - 1] != "/") {
      _baseUrl = _baseUrl + "/";
    }
  }

  Future<String> request(String endPoint, ApiRequest req) async {
    String jsonReqData = json.encode(req.toMap());
    String url = this._baseUrl + endPoint;
    print("###### REQUEST URL: " + url);
    print("###### REQUEST DATA: ####### \n" + jsonReqData);
    var response = await http.post(
      url,
      headers: {'content-type': 'application/json'},
      body: jsonReqData,
    );
    print("###### RESPONSE DATA: ####### \n" +
        response.body +
        "\n ############################ \n ");
    return response.body;
  }
}
