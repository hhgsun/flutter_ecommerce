import 'package:ecommerceapp/models/ApiRequest.dart';
import 'package:ecommerceapp/models/ApiResponse.dart';
import 'package:ecommerceapp/models/User.dart';
import 'package:ecommerceapp/services/api_service.dart';

class ApiAuth extends ApiService {
  Future<ApiResponse<User>> login(String email, String pass) {
    return this
        .request(
      "login",
      ApiRequest(page: "1"),
    )
        .then((value) {
      return ApiResponse(
        data: User(),// set value data
        isError: false,
      );
    });
  }
}
