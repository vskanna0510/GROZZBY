import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.isVerified,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  final int id;
  final String name;
  final String? email;
  final String? phone;
  final bool isVerified;
}

class AuthSession {
  const AuthSession({
    required this.userId,
    required this.maskedEmail,
    required this.maskedPhone,
  });

  final int userId;
  final String maskedEmail;
  final String maskedPhone;
}

class AuthRepository {
  AuthRepository({
    ApiClient? apiClient,
    TokenStorage? tokenStorage,
  })  : _client = apiClient ?? ApiClient(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final ApiClient _client;
  final TokenStorage _tokenStorage;

  Future<AuthSession> register({
    required String name,
    required String email,
    String? phone,
    required String password,
  }) async {
    final response = await _client.dio.post('/api/auth/register', data: {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    });
    return _sessionFromResponse(response.data as Map<String, dynamic>);
  }

  Future<AuthSession> login({
    required String identifier,
    required String password,
  }) async {
    final response = await _client.dio.post('/api/auth/login', data: {
      'identifier': identifier,
      'password': password,
    });
    return _sessionFromResponse(response.data as Map<String, dynamic>);
  }

  Future<AuthUser> verifyOtp({
    required int userId,
    required String code,
    required String channel,
  }) async {
    final response = await _client.dio.post('/api/auth/verify-otp', data: {
      'userId': userId,
      'code': code,
      'channel': channel,
    });
    final access = response.data['accessToken'] as String;
    final refresh = response.data['refreshToken'] as String;
    await _tokenStorage.saveTokens(
      accessToken: access,
      refreshToken: refresh,
    );
    return AuthUser.fromJson(response.data['user'] as Map<String, dynamic>);
  }

  Future<void> resendOtp({
    required int userId,
    required String channel,
  }) async {
    await _client.dio.post('/api/auth/resend-otp', data: {
      'userId': userId,
      'channel': channel,
    });
  }

  Future<AuthUser?> getCurrentUser() async {
    final token = await _tokenStorage.getAccessToken();
    if (token == null) return null;
    try {
      final response = await _client.dio.get('/api/auth/me');
      return AuthUser.fromJson(response.data['user'] as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _client.dio.post('/api/auth/logout');
    } catch (_) {}
    await _tokenStorage.clear();
  }

  AuthSession _sessionFromResponse(Map<String, dynamic> data) {
    return AuthSession(
      userId: data['userId'] as int,
      maskedEmail: data['maskedEmail'] as String? ?? '',
      maskedPhone: data['maskedPhone'] as String? ?? '',
    );
  }

  String parseError(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['error'] is String) {
      return data['error'] as String;
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Unable to reach the server. Make sure the backend is running on ${error.requestOptions.baseUrl}.';
    }
    return 'Something went wrong. Please try again.';
  }
}
