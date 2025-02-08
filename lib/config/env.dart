class Env {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: '192.168.137.181:8000', // Default development URL
  );
  
  // Add other environment variables as needed
  static const bool isDevelopment = bool.fromEnvironment(
    'IS_DEVELOPMENT',
    defaultValue: true,
  );
} 