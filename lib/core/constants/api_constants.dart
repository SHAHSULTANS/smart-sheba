class ApiConstants {
  // For development - use mock
  static const String baseUrl = 'https://mock.smartsheba.com/api/v1';
  
  // For production - use actual API (will be available later)
  // static const String baseUrl = 'https://api.smartsheba.com/api/v1';
  
  static const int connectTimeoutInSeconds = 30;
  static const int receiveTimeoutInSeconds = 30;
  
  // Development flags
  static const bool isDevelopment = true;
  static const bool useMockData = true;
}