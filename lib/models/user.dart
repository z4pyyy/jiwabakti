import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class User extends ChangeNotifier{
  int? id;
  int? userId;
  String? lastName;
  String? firstName;
  int? age;
  String? email;
  String? password;
  String country = "Malaysia";
  String? state;
  // String? token;
  bool isLogin = false;
  double _textSizeScale;

  User({
    this.id,
    this.userId,
    this.lastName,
    this.firstName,
    this.age,
    this.email,
    this.password,
    this.state,
    // this.token,
    required double textSizeScale,
  }) : _textSizeScale = textSizeScale;

  double get textSizeScale => _textSizeScale;

  set textSizeScale(double value) {
    if (_textSizeScale == value) {
      return;
    }
    _textSizeScale = value;
    notifyListeners();
  }

  Future<void> login(Map<String, dynamic> userDetails, String userEmail) async {
    try {
      debugPrint("---------- USER LOGIN START");
      debugPrint("---------- USER DETAILS: $userDetails");
      debugPrint("---------- USER EMAIL: $userEmail");
      
      isLogin = true;
      
      // Safely parse id
      if (userDetails.containsKey('id') && userDetails['id'] != null) {
        id = int.tryParse(userDetails['id'].toString());
        debugPrint("---------- ID: $id");
      }
      
      // Safely parse user_id
      if (userDetails.containsKey('user_id') && userDetails['user_id'] != null) {
        userId = int.tryParse(userDetails['user_id'].toString());
        debugPrint("---------- USER_ID: $userId");
      }
      
      // Safely get firstName
      if (userDetails.containsKey('first_name')) {
        firstName = userDetails['first_name']?.toString();
        debugPrint("---------- FIRST_NAME: $firstName");
      }
      
      // Safely get lastName
      if (userDetails.containsKey('last_name')) {
        lastName = userDetails['last_name']?.toString();
        debugPrint("---------- LAST_NAME: $lastName");
      }
      
      // Safely parse age
      if (userDetails.containsKey('age') && userDetails['age'] != null) {
        age = int.tryParse(userDetails['age'].toString());
        debugPrint("---------- AGE: $age");
      }
      
      // Safely get state/country
      if (userDetails.containsKey('country')) {
        state = userDetails['country']?.toString();
        debugPrint("---------- STATE: $state");
      }
      
      email = userEmail;
      debugPrint("---------- EMAIL: $email");
      
      debugPrint("---------- USER LOGIN COMPLETE: $firstName $lastName (ID: $id)");
    } catch (e, stackTrace) {
      debugPrint("---------- USER LOGIN ERROR: $e");
      debugPrint("---------- LOGIN STACK TRACE: $stackTrace");
      // Re-throw to let caller handle the error
      rethrow;
    }
  }

  Future<void> rememberLogin(String username, String password) async {
    try {
      debugPrint("---------- REMEMBER LOGIN START: $username");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final DateTime expireAt = DateTime.now().add(const Duration(days: 90));

      await prefs.setString("username", username);
      await prefs.setString("password", password);
      await prefs.setString("expireAt", expireAt.toString());
      
      debugPrint("---------- REMEMBER LOGIN SAVED SUCCESSFULLY");
    } catch (e, stackTrace) {
      debugPrint("---------- REMEMBER LOGIN ERROR: $e");
      debugPrint("---------- REMEMBER STACK TRACE: $stackTrace");
      // Don't rethrow - this is not critical
    }
  }

  Future<void> logout() async {
    try {
      debugPrint("---------- LOGOUT START");
      isLogin = false;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("username");
      await prefs.remove("password");
      await prefs.remove("expireAt");
      
      // Clear user data
      id = null;
      userId = null;
      firstName = null;
      lastName = null;
      age = null;
      email = null;
      password = null;
      state = null;
      
      debugPrint("---------- LOGOUT COMPLETE");
    } catch (e, stackTrace) {
      debugPrint("---------- LOGOUT ERROR: $e");
      debugPrint("---------- LOGOUT STACK TRACE: $stackTrace");
    }
  }
}
