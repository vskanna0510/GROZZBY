import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../data/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  bool isLoading = false;
  String? errorMessage;
  AuthSession? pendingSession;
  AuthUser? currentUser;
  AuthUser? get user => currentUser;
  String otpChannel = 'email';
  bool otpAccepted = false;
  bool otpVerifying = false;

  Future<void> loadCurrentUser() async {
    currentUser = await _repository.getCurrentUser();
    notifyListeners();
  }

  void updateUser(AuthUser user) {
    currentUser = user;
    notifyListeners();
  }

  Future<void> logout() async {
    await _repository.logout();
    currentUser = null;
    pendingSession = null;
    notifyListeners();
  }

  Future<AuthSession?> register({
    required String name,
    required String email,
    String? phone,
    required String password,
  }) async {
    return _run(() async {
      final session = await _repository.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      _beginOtpSession(session);
      return session;
    });
  }

  Future<AuthSession?> login({
    required String identifier,
    required String password,
  }) async {
    return _run(() async {
      final session = await _repository.login(
        identifier: identifier,
        password: password,
      );
      _beginOtpSession(session);
      return session;
    });
  }

  Future<AuthUser?> verifyOtp(String code) async {
    final session = pendingSession;
    if (session == null) return null;
    otpVerifying = true;
    errorMessage = null;
    notifyListeners();
    try {
      final user = await _repository.verifyOtp(
        userId: session.userId,
        code: code,
        channel: otpChannel,
      );
      otpAccepted = true;
      return user;
    } on DioException catch (e) {
      errorMessage = _repository.parseError(e);
      otpAccepted = false;
      return null;
    } catch (e) {
      errorMessage = e.toString();
      otpAccepted = false;
      return null;
    } finally {
      otpVerifying = false;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resendOtp() async {
    final session = pendingSession;
    if (session == null) return;
    await _run(() async {
      await _repository.resendOtp(
        userId: session.userId,
        channel: otpChannel,
      );
    });
  }

  void setOtpChannel(String channel) {
    otpChannel = channel;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  void resetOtpState() {
    otpAccepted = false;
    otpVerifying = false;
    errorMessage = null;
    notifyListeners();
  }

  void _beginOtpSession(AuthSession session) {
    pendingSession = session;
    otpAccepted = false;
    otpVerifying = false;
    otpChannel = session.maskedEmail.isNotEmpty ? 'email' : 'phone';
  }

  Future<T?> _run<T>(Future<T> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      return await action();
    } on DioException catch (e) {
      errorMessage = _repository.parseError(e);
      return null;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
