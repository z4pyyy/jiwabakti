import 'package:dio/dio.dart';
import 'package:jiwa_bakti/enums/status.dart';
import 'package:jiwa_bakti/utils/show_toast.dart';

class ApiService {
  final Dio client;
  // final String apiUrl = "${dotenv.env['API_URL']}";
  final String apiUrl = "https://utusansarawak.com.my/jiwa-cms";

  ApiService({required this.client});

  Future<dynamic> getAds() async {
    try {
      Response response = await client.get("$apiUrl/adsapi");
      return response.data;
    } on DioException catch (e) {
      // if (e.response?.data['message'] != null) {
      //   showToast(message: "Error while getting Ads data ${e.response!.data['message']}", status: Status.error);
      // }
      // showToast(message: "Error getting news articles", status: Status.error);
    }

    return {};
  }

  Future<List<Map<String, dynamic>>> getRewards() async {
    try {
      Response response = await client.get("$apiUrl/rewardapi");
      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(
          (response.data as List).map(
                (item) => Map<String, dynamic>.from(item),
          ),
        );
      }
    } on DioException catch (e) {
      print("ERROR ----- $e");
    }

    return [{}];
  }

  Future<dynamic> getSavedNews(int userId) async {
    try {
      Response response = await client.get(
        "$apiUrl/savenews",
        queryParameters: {
          'user_id': userId,
        },
      );
      return response.data;
    } on DioException catch (e) {
      print("--- ERROR WHILE GETTING SAVED NEWS $e");
    }

    return {};
  }

  Future<dynamic> saveNews(int userId, int newsId) async {
    try {
      Response response = await client.post(
        "$apiUrl/savenews",
        data: {
          'user_id': userId,
          'news_id': newsId,
        },
      );
      return response.data;
    } on DioException catch (e) {
      print("--- ERROR WHILE SAVING NEWS $e");
    }

    return {};
  }

  Future<dynamic> deleteSavedNews(int userId, int newsId) async {
    try {
      Response response = await client.delete(
        "$apiUrl/savenews/$newsId",
        queryParameters: {
          'user_id': userId,
        },
      );
      return response.data;
    } on DioException catch (e) {
      print("--- ERROR WHILE DELETING SAVED NEWS $e");
    }

    return {};
  }

  Future<dynamic> signup(Map<String, dynamic> postData) async {
  print("=============== SIGNUP START ===============");
  print("POST DATA: $postData");

  try {
    final formData = FormData.fromMap(postData);

    print("=============== SENDING REQUEST ===============");
    print("URL: $apiUrl/signupController");
    
    Response response = await client.post(
      "$apiUrl/signupController",
      data: formData,
    );

    print("=============== SIGNUP RESPONSE ===============");
    print("STATUS CODE: ${response.statusCode}");
    print("RAW DATA: ${response.data}");

    return response.data;
  } on DioException catch (e) {
    print("=============== SIGNUP DIO ERROR ===============");
    print("TYPE: ${e.type}");
    print("MESSAGE: ${e.message}");
    
    if (e.response != null) {
      print("STATUS CODE: ${e.response?.statusCode}");
      print("HEADERS: ${e.response?.headers.toString()}");
      print("BODY: ${e.response?.data}");
    } else {
      print("NO RESPONSE RECEIVED FROM SERVER.");
    }

    return {
      "status": "error",
      "message": "DIO ERROR: ${e.message}",
      "error": e.response?.data
    };
  } catch (e, stack) {
    print("=============== SIGNUP UNKNOWN ERROR ===============");
    print("ERROR: $e");
    print("STACK: $stack");

    return {
      "status": "error",
      "message": "UNKNOWN ERROR: $e",
    };
  }
}


  Future<dynamic> signIn(Map<String, dynamic> postData) async {
    try {
      final formData = FormData.fromMap(postData);
      Response response = await client.post("$apiUrl/loginController", data: formData);
      return response.data;
    } on DioException catch (e) {
      print("-------- ERROR WHILE SIGNING IN $e");
      // showToast(message: "Error while signing in, please try again");
    }

    final errorResult = {};
    return errorResult;
  }

  Future<dynamic> unsubscribe(Map<String, dynamic> postData) async {
    try {
      final formData = FormData.fromMap(postData);
      Response response = await client.post("$apiUrl/unsubscribeController", data: formData);
      return response.data;
    } on DioException catch (e) {
      // if (e.response?.data != null) {
      //   showToast(message: "Error while logging in: ${e.response!.data}", status: Status.error);
      // }
      // showToast(message: "Error while unsubscribing, please try again", status: Status.error);
    }

    final errorResult = {};
    return errorResult;
  }

  Future<dynamic> forgotPassword(Map<String, dynamic> postData) async {
    try {
      final formData = FormData.fromMap(postData);
      Response response = await client.post("$apiUrl/forgotPasswordController", data: formData);
      return response.data;
    } on DioException catch (e) {
      // if (e.response?.data != null) {
      //   showToast(message: "Error while logging in: ${e.response!.data}", status: Status.error);
      // }
      // print(e);
      // showToast(message: "Error while resetting password, please try again", status: Status.error);
    }

    final errorResult = {};
    return errorResult;
  }

  Future<dynamic> editProfile(Map<String, dynamic> postData) async {
    try {
      final formData = FormData.fromMap(postData);
      Response response = await client.post("$apiUrl/editProfileController", data: formData);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        // showToast(message: "Error while logging in: ${e.response!.data}", status: Status.error);
      }
      // showToast(message: "Error while editing profile, please try again", status: Status.error);
    }

    final errorResult = {};
    return errorResult;
  }

  Future<dynamic> adsClick(Map<String, dynamic> postData) async {
    try {
      final formData = FormData.fromMap(postData);
      Response response = await client.post("$apiUrl/adsclick", data: formData);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        // showToast(message: "Error while logging in: ${e.response!.data}", status: Status.error);
      }
      // showToast(message: "Error while editing profile, please try again", status: Status.error);
    }

    final errorResult = {};
    return errorResult;
  }



}
