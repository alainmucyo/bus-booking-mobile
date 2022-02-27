import 'package:booking_app/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _userId;
  final Dio http = Dio();

  bool get isAuth {
    print(userId != null);
    return userId != null;
  }

  String get userId {
    if (_userId != null && _userId.isNotEmpty) return _userId;
    return null;
  }

  Future<void> _authenticate(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", userId);
    _userId = userId;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    try {
      print("Login");
      final response = await Dio().post("${Constants.BASE_URL}/login", data: {
        "email": username,
        "password": password,
      });
      print(response.data);
      if (response.data["user_id"] == null)
        throw HttpException("Invalid username or password");
      _authenticate(response.data["user_id"].toString());
      // _authenticate(
      //     "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJaX3ZVWG1ULWpibXdycFVLNmt3a3JWdzd1OUcyYi02SHFkdV94eUNIanFJIn0.eyJleHAiOjE2NzA1Nzc1NDIsImlhdCI6MTYzOTA0MTU0MiwianRpIjoiNjg3ODcwYjYtMWQ2NS00NmQ0LTkzNTgtMjk1YTM5NzRlNjUyIiwiaXNzIjoiaHR0cHM6Ly9wc2Yta2V5Y2xvYWsyLmdhbGF4eWdyb3VwLmJpei9hdXRoL3JlYWxtcy9wc2YiLCJzdWIiOiIyNjI1N2I5ZC05ZmRlLTQ1M2EtYTRjMy00MjYwYjRkNDU5YTciLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJ1c2Vycy1tYW5hZ2VtZW50Iiwic2Vzc2lvbl9zdGF0ZSI6IjQ3YzFmODAwLWVjNzQtNDVkMy1iMDhlLWI1YmNjODE2NWNiYiIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiKiJdLCJzY29wZSI6Im9wZW5pZCBlbWFpbCBwcm9maWxlIiwic2lkIjoiNDdjMWY4MDAtZWM3NC00NWQzLWIwOGUtYjViY2M4MTY1Y2JiIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiQWdlbnQgVGVzdCIsInByZWZlcnJlZF91c2VybmFtZSI6ImFnZW50QGdtYWlsLmNvbSIsImdpdmVuX25hbWUiOiJBZ2VudCIsImZhbWlseV9uYW1lIjoiVGVzdCIsImVtYWlsIjoiYWdlbnRAZ21haWwuY29tIiwiZ3JvdXAiOltdfQ.faQbBQhhkeuQHRUc8e4g6VVbQYzOTRdAqJIO2IleLtpa_yfex6pB5oXA50hIFmTRG2f2nFODG7KO_aExVby6tFiS6BHalowS2TzuEi5gHYiU6k28lh5sjNh6XZn0cbQYbWiThQfWjurrdBquDsB7jIVN9BHng-GRTf2EBm5yRbVa3AXBcD6cgNbceGCSYHKZZxvrqq5AoaTPzNTGsm8n5o5icvbjyVQjrjIS2_ePVVlqAatMKM69Bq32oCOSNG9rXQksHo8nxPWceze8AiZc2bIsaeYc2d5q3n4YKZ4hGkV6zSJ4D6ljLGlCFGBeNUDHWKEPx8bOa9_IGZRPiKMcbA");
      // _authenticate("This is a really super secret userId");
    } on DioError catch (e) {
      print(e);
      print(e.response.data);
      throw HttpException("Invalid login credentials");
    }
    catch(e){
    rethrow;
    }

  }

  Future<void> logout() async {
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userId")) return false;
    final extractedToken = prefs.getString("userId");

    _userId = extractedToken;
    notifyListeners();
    return true;
  }
}
