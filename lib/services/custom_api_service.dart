import 'dart:async';
import 'dart:convert';
import 'package:ecommerceapp/models/cocart_item.dart';
import 'package:ecommerceapp/models/customer.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerceapp/constants.dart';

enum REQUEST_TYPE { GET, POST, DELETE, UPDATE }

class CustomApiService {
  static Future<dynamic> _request(String endpoint,
      {Map data,
      String nameSpace = customApiNamespace,
      REQUEST_TYPE type = REQUEST_TYPE.POST}) async {
    //nameSpace = nameSpace != null ? nameSpace : customApiNamespace;
    String url = woocommerce.baseUrl + nameSpace + endpoint;
    print("++++++++++++++++++++++++ START " + type.toString());
    print("REQUEST: " + url + ' ' + json.encode(data));
    dynamic res;
    if (type == REQUEST_TYPE.GET) {
      res = await http.get(url);
    } else if (type == REQUEST_TYPE.POST) {
      res = await http.post(url, body: data);
    } else if (type == REQUEST_TYPE.UPDATE) {
      res = await http.put(url, body: data);
    } else if (type == REQUEST_TYPE.DELETE) {
      res = await http.delete(url);
    }
    print("RESPONSE: " + res.body);
    print("######################## END " + type.toString());
    return json.decode(res.body);
  }

  static String nonceStore = DateTime.now().toString();

  static Future<CustomResponseData<String>> createNonce() {
    return _request('/create-store-nonce', type: REQUEST_TYPE.GET)
        .then((value) {
      CustomApiService.nonceStore = value;
      print('Current Nonce KEY: ' + value);
      return new CustomResponseData(true, value);
    });
  }

  // CART https://docs.cocart.xyz/

  static String _wpWooNameSpace = "/wp-json/cocart/v1"; //wp cocart namespace

  static String get cartKey =>
      (loggedInCustomer != null ? loggedInCustomer.id.toString() : nonceStore);

  static Future<CustomResponseData<List<CoCartItem>>> getCart() {
    return _request("/get-cart?thumb=true&cart_key=" + cartKey,
            nameSpace: _wpWooNameSpace, type: REQUEST_TYPE.GET)
        .then((res) {
      if (res is List && res.length == 0)
        return new CustomResponseData(true, null);
      Map values = res;
      List<CoCartItem> items =
          values.entries.map((e) => CoCartItem.fromJson(e.value)).toList();
      return new CustomResponseData(true, items);
    });
  }

  static Future<CustomResponseData<List<CoCartItem>>> addCart(
      String productid, String quantity) {
    Map<String, String> data = {"product_id": productid, "quantity": quantity};
    return _request("/add-item?return_cart=true&cart_key=" + cartKey,
            data: data, nameSpace: _wpWooNameSpace)
        .then((res) {
      if (res is List && res.length == 0)
        return new CustomResponseData(true, null);
      Map values = res;
      List<CoCartItem> items =
          values.entries.map((e) => CoCartItem.fromJson(e.value)).toList();
      return new CustomResponseData(true, items);
    });
  }

  static Future<CustomResponseData> deleteCart(String cartItemKey) {
    return _request(
            "/item?cart_key=" + cartKey + '&cart_item_key=' + cartItemKey,
            nameSpace: _wpWooNameSpace,
            type: REQUEST_TYPE.DELETE)
        .then((value) {
      return new CustomResponseData(true, value);
    });
  }

  // LOST PASSWORD

  static Future<CustomResponseData> lostPassword(String email) async {
    return CustomApiService._request("/lost/password", data: {"email": email})
        .then((json) => CustomResponseData.fromJson(json));
  }

  // FAVORITES

  static Future<CustomResponseData> addFavs(String productid) async {
    return CustomApiService._request("/user/favorites/add", data: {
      "userid": loggedInCustomer.id.toString(),
      "productid": productid
    }).then((json) => CustomResponseData.fromJson(json));
  }

  static Future<CustomResponseData> deleteFavs(String productid) async {
    return CustomApiService._request("/user/favorites/delete", data: {
      "userid": loggedInCustomer.id.toString(),
      "productid": productid
    }).then((json) => CustomResponseData.fromJson(json));
  }

  static FutureOr<WooCustomerMetaData> getFavs() {
    if (loggedInCustomer != null) {
      List meta = loggedInCustomer.metaData
          .where((meta) => meta.key == 'favorite_products')
          .toList();
      if (meta.isNotEmpty) return meta.first;
    }
    return null;
  }

  // GENERAL DATA

  static Future getCities(String cityCode) {
    return woocommerce.get('data/countries/' + cityCode).then((value) => value);
  }

  static Future getContinents() {
    return woocommerce.get('data/continents').then((value) => value);
  }
}

class CustomResponseData<T> {
  bool success;
  T data;
  CustomResponseData(this.success, this.data);
  factory CustomResponseData.fromJson(Map json) =>
      CustomResponseData(json['success'], json['data']);
}
