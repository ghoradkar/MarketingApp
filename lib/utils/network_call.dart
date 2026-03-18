import 'dart:io';

class ByPassCert {
  // Private constructor
  ByPassCert._internal() {
    httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }

  // Static field to hold the singleton instance
  static final ByPassCert _instance = ByPassCert._internal();

  // Public factory constructor to return the same instance
  factory ByPassCert() {
    return _instance;
  }

  late HttpClient httpClient;
}
