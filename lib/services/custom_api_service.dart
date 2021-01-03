import 'dart:async';
import 'dart:convert';
import 'package:ecommerceapp/models/cocart_item.dart';
import 'package:ecommerceapp/models/products.dart';
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
    isRefreshCart = false;
    return _request("/get-cart?thumb=true&cart_key=" + cartKey,
            nameSpace: _wpWooNameSpace, type: REQUEST_TYPE.GET)
        .then((res) {
      if (!(res is Map) || res.length == 0)
        return new CustomResponseData(false, null,
            message: 'Sepet Boş yada Bulunamadı');
      Map values = res;
      List<CoCartItem> items =
          values.entries.map((e) => CoCartItem.fromJson(e.value)).toList();
      if (items.length > 0) {
        cartItems = items;
      }
      return new CustomResponseData(true, items);
    });
  }

  static Future<CustomResponseData<List<CoCartItem>>> addCart(
      String productid, String quantity) {
    isRefreshCart = true;
    Map<String, String> data = {"product_id": productid, "quantity": quantity};
    return _request("/add-item?return_cart=true&cart_key=" + cartKey,
            data: data, nameSpace: _wpWooNameSpace)
        .then((res) {
      if (!(res is Map) || res.length == 0)
        return new CustomResponseData(false, null, message: res['message']);
      Map values = res;
      List<CoCartItem> items =
          values.entries.map((e) => CoCartItem.fromJson(e.value)).toList();
      if (items.length > 0) {
        cartItems = items;
      }
      return new CustomResponseData(true, items);
    });
  }

  static Future<CustomResponseData<List<CoCartItem>>> deleteCart(String cartItemKey) {
    isRefreshCart = true;
    return _request(
            "/item?return_cart=true&cart_key=" +
                cartKey +
                "&cart_item_key=" +
                cartItemKey,
            nameSpace: _wpWooNameSpace,
            type: REQUEST_TYPE.DELETE)
        .then((res) {
      if (!(res is Map) || res.length == 0)
        return new CustomResponseData(false, null, message: res['message']);
      Map values = res;
      List<CoCartItem> items =
          values.entries.map((e) => CoCartItem.fromJson(e.value)).toList();
      if (items.length > 0) {
        cartItems = items;
      }
      return new CustomResponseData(true, items);
    });
  }

  static Future<CustomResponseData> clearCart() {
    isRefreshCart = true;
    return _request("/clear?cart_key=" + cartKey,
            nameSpace: _wpWooNameSpace, type: REQUEST_TYPE.POST)
        .then((value) {
      return new CustomResponseData(true, value);
    });
  }

  static Future<CustomResponseData<CoCartTotals>> totalsCart() {
    return _request("/totals?cart_key=" + cartKey + "&html=true",
            nameSpace: _wpWooNameSpace, type: REQUEST_TYPE.GET)
        .then((value) {
      return new CustomResponseData(true, CoCartTotals.fromJson(value));
    });
  }

  // LOST PASSWORD

  static Future<CustomResponseData> lostPassword(String email) async {
    return CustomApiService._request("/lost/password", data: {"email": email})
        .then((json) => CustomResponseData.fromJson(json));
  }

  // FAVORITES

  static bool isRefreshFavorites = true;
  static bool isFirstFetchFavoriteIds = false;
  static List<int> favoriteIds = new List<int>();

  static Future<CustomResponseData<dynamic>> addFavs(WooProduct product) async {
    CustomApiService.isRefreshFavorites = true;
    return CustomApiService._request("/user/favorites/add", data: {
      "userid": loggedInCustomer.id.toString(),
      "productid": product.id.toString()
    }).then((res) {
      CustomApiService.favoriteIds.add(product.id);
      return res;
    }).then((json) => CustomResponseData.fromJson(json));
  }

  static Future<CustomResponseData<dynamic>> deleteFavs(
      WooProduct product) async {
    CustomApiService.isRefreshFavorites = true;
    return CustomApiService._request("/user/favorites/delete", data: {
      "userid": loggedInCustomer.id.toString(),
      "productid": product.id.toString()
    }).then((res) {
      CustomApiService.favoriteIds.remove(product.id);
      return res;
    }).then((json) => CustomResponseData.fromJson(json));
  }

  static List<int> fetchCustomerFavoriteIds() {
    List<int> ids = new List<int>();
    if (loggedInCustomer != null) {
      List meta = loggedInCustomer.metaData
          .where((meta) => meta.key == 'favorite_products')
          .toList();
      favoriteProducts = new List<WooProduct>();
      if (meta.isNotEmpty) {
        var values = meta.first.value;
        if (values is List) {
          if (values.length > 0)
            values.forEach((v) {
              ids.add(int.parse(v));
            });
        } else {
          if (values.length > 0 && values != null)
            values.forEach((k, v) {
              ids.add(int.parse(v));
            });
        }
      }
    }
    CustomApiService.favoriteIds = ids;
    return ids;
  }

  static Future<CustomResponseData<List<WooProduct>>> loadFavProducts() async {
    if (loggedInCustomer != null && CustomApiService.isRefreshFavorites) {
      List<int> ids = CustomApiService.favoriteIds;
      if (!CustomApiService.isFirstFetchFavoriteIds) {
        ids = CustomApiService.fetchCustomerFavoriteIds();
        CustomApiService.isFirstFetchFavoriteIds = true;
      }
      if (ids.length > 0) {
        CustomApiService.isRefreshFavorites = false;
        return woocommerce.getProducts(include: ids).then((value) {
          favoriteProducts = value;
          return CustomResponseData(true, favoriteProducts);
        });
      } else {
        favoriteProducts = new List<WooProduct>();
      }
    }
    return CustomResponseData(true, favoriteProducts);
  }

  static bool isFav(int productid) {
    return favoriteProducts.where((p) => p.id == productid).isNotEmpty;
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
  String message;
  CustomResponseData(this.success, this.data, {this.message});
  factory CustomResponseData.fromJson(Map<String, dynamic> json) =>
      CustomResponseData(
        json['success'] != null ? json['success'] : false,
        json['data'] != null ? json['data'] : '',
        message: json['message'] != null ? json['message'] : null,
      );
}
