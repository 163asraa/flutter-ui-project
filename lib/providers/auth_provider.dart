import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AuthProvider with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  String? _username;
  String? _email;
  bool _isLoading = false;

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;
  String get userId => _userData?['id']?.toString() ?? '';

  String? get token => _token;
  String? get refreshToken => _refreshToken;
  String? get username => _username;
  String? get userEmail => _email;
  bool get isLoading => _isLoading;

  final storage = FlutterSecureStorage();

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      print('${dotenv.env['BASE_URL']}/api/token/');

      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/api/token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _token = data['access'];
        _refreshToken = data['refresh'];

        final user = data['user'];
        _username = user['username'];
        _email = user['email'];
        _userData = user;

        await storage.write(key: 'access_token', value: _token);
        await storage.write(key: 'refresh_token', value: _refreshToken);
        await storage.write(key: 'username', value: _username);
        await storage.write(key: 'email', value: _email);

        notifyListeners();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(translateError(error['detail'] ?? 'Login failed'));
      }
    } catch (e) {
      print('Login Error: $e');
      throw Exception('فشل تسجيل الدخول: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(String email, String password, String confirmPassword) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        await login(email, password);
      } else {
        String errorMessage = 'Registration failed';
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('password')) {
            errorMessage = responseData['password'].toString();
          } else if (responseData.containsKey('email')) {
            errorMessage = responseData['email'].toString();
          } else if (responseData.containsKey('detail')) {
            errorMessage = responseData['detail'].toString();
          }
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Registration Error: $e');
      throw Exception('Registration failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      if (_refreshToken != null) {
        await http.post(
          Uri.parse('${dotenv.env['BASE_URL']}/logout/'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'refresh': _refreshToken}),
        );
      }
    } catch (e) {
      print('Logout error ignored: $e');
    } finally {
      await _clearTokens();
      _setLoading(false);
    }
  }

  Future<void> loadToken() async {
    _setLoading(true);
    try {
      _token = await storage.read(key: 'access_token');
      _refreshToken = await storage.read(key: 'refresh_token');
      _username = await storage.read(key: 'username');
      _email = await storage.read(key: 'email');

      if (_token != null && _refreshToken != null) {
        final response = await http.get(
          Uri.parse('${dotenv.env['BASE_URL']}/api/users/me/'),
          headers: {'Authorization': 'Bearer $_token'},
        );

        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body);
          _username = userData['username'] ?? _username;
          _email = userData['email'] ?? _email;
          _userData = userData;
          notifyListeners();
        } else if (response.statusCode == 401) {
          await _refreshAccessToken();
        } else {
          await _clearTokens();
        }
      }
    } catch (e) {
      print('Load Token Error: $e');
      await _clearTokens();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _refreshAccessToken() async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/api/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': _refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['access'];
        await storage.write(key: 'access_token', value: _token);
        notifyListeners();
      } else {
        await _clearTokens();
      }
    } catch (e) {
      print('Token Refresh Error: $e');
      await _clearTokens();
    }
  }

  Future<void> _clearTokens() async {
    _token = null;
    _refreshToken = null;
    _username = null;
    _email = null;
    _userData = null;
    await storage.deleteAll();
    notifyListeners();
  }

  Future<bool> isTokenValid() async {
    if (_token == null || _refreshToken == null) return false;

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['BASE_URL']}/api/users/me/'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        await _refreshAccessToken();
        return _token != null;
      }
      return false;
    } catch (e) {
      print('Token Validation Error: $e');
      return false;
    }
  }

  String translateError(String error) {
    switch (error.toLowerCase()) {
      case 'no active account found with the given credentials':
        return 'لا يوجد حساب نشط يطابق هذه البيانات.';
      case 'invalid token':
        return 'رمز الدخول غير صالح.';
      case 'user inactive':
        return 'تم تعطيل الحساب. يرجى التواصل مع الدعم.';
      case 'wrong password':
        return 'كلمة المرور غير صحيحة.';
      default:
        return 'خطأ: $error';
    }
  }
}
