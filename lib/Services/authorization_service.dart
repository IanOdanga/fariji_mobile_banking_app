import 'package:flutter_appauth/flutter_appauth.dart';
import 'secure_storage_service.dart';

class AuthorizationService {
  static const String issuer = 'https://';
  static const String redirectUrl =
      '/suresms.co.ke:4242/mobileapi/api/Login';
  final FlutterAppAuth appAuth;
  final SecureStorageService secureStorageService;
  AuthorizationService(
      this.appAuth,
      this.secureStorageService,
      );
  Future<void> authorize() async {
    final AuthorizationTokenResponse? response =
    await appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
        redirectUrl, issuer,
        issuer: issuer,
        promptValues: <String>[
          'login'
        ],
        scopes: <String>[
          'offline_access',
        ],
        additionalParameters: {
          'audience': 'https:///suresms.co.ke:4242/mobileapi/api/GetToken',
        }));
    await secureStorageService.saveAccessToken(response!.accessToken!);
    await secureStorageService
        .saveAccessTokenExpiresIn(response.accessTokenExpirationDateTime!);
    await secureStorageService.saveRefreshToken(response.refreshToken!);
  }
  Future<String?> getValidAccessToken() async {
    final DateTime? expirationDate =
    await secureStorageService.getAccessTokenExpirationDateTime();
    if (DateTime.now()
        .isBefore(expirationDate!.subtract(const Duration(minutes: 1)))) {
      return secureStorageService.getAccessToken();
    }
    return _refreshAccessToken();
  }
  Future<String?> _refreshAccessToken() async {
    final String? refreshToken = await secureStorageService.getRefreshToken();
    final TokenResponse? response = await appAuth.token(TokenRequest(
        redirectUrl, issuer,
        issuer: issuer, refreshToken: refreshToken));
    await secureStorageService.saveAccessToken(response!.accessToken!);
    await secureStorageService
        .saveAccessTokenExpiresIn(response.accessTokenExpirationDateTime!);
    await secureStorageService.saveRefreshToken(response.refreshToken!);
    return response.accessToken;
  }
}