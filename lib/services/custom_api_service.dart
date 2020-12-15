import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerceapp/constants.dart';
import 'package:woocommerce/models/customer.dart';

class CustomApiService {
  static Future<dynamic> _postRequest(String endpoint, Map data) async {
    String url = woocommerce.baseUrl + customApiNamespace + endpoint;
    print("////////////////////// start");
    print("REQUEST: " + url + ' ' + json.encode(data));
    dynamic res = await http.post(url, body: data);
    print("RESPONSE: " + res.body);
    print("////////////////////// end");
    return json.decode(res.body);
  }

  /* static Future<dynamic> _getRequest(String endpoint) async {
    String url = woocommerce.baseUrl + customApiNamespace + endpoint;
    print("req url: GET " + url);
    dynamic res = http.get(url);
    return json.decode(res.body);
  } */

  static Future<CustomResponseData> lostPassword(String email) async {
    return CustomApiService._postRequest("/lost/password", {"email": email})
        .then((json) => CustomResponseData.fromJson(json));
  }

  // FAVORITES

  static Future<CustomResponseData> addFavs(String productid) async {
    return CustomApiService._postRequest("/user/favorites/add", {
      "userid": loggedInCustomer.id.toString(),
      "productid": productid
    }).then((json) => CustomResponseData.fromJson(json));
  }

  static Future<CustomResponseData> deleteFavs(String productid) async {
    return CustomApiService._postRequest("/user/favorites/delete", {
      "userid": loggedInCustomer.id.toString(),
      "productid": productid
    }).then((json) => CustomResponseData.fromJson(json));
  }

  static Future<WooCustomerMetaData> getFavs() async {
    WooCustomerMetaData meta = loggedInCustomer.metaData
        .where((meta) => meta.key == 'favorite_products')
        .first;
    return meta;
  }

  // GENERAL DATA

  static Future getCities(String cityCode) {
    return woocommerce.get('data/countries/' + cityCode).then((value) => value);
  }

  static Future getContinents() {
    return woocommerce.get('data/continents').then((value) => value);
  }
}

class CustomResponseData {
  bool success;
  dynamic data;
  CustomResponseData(this.success, this.data);
  factory CustomResponseData.fromJson(Map json) =>
      CustomResponseData(json['success'], json['data']);
}
