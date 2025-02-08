import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'utils/app_colors.dart';
import 'utils/app_localizations.dart';
import 'layouts/responsive_layout.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final languageCode = prefs.getString('languageCode') ?? 'en';
  runApp(MyApp(
    initialDarkMode: isDarkMode,
    initialLocale: Locale(languageCode),
  ));
}

class MyApp extends StatefulWidget {
  final bool initialDarkMode;
  final Locale initialLocale;
  
  const MyApp({
    super.key,
    required this.initialDarkMode,
    required this.initialLocale,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;
  late Locale _locale;
  // Comment out login state
  // bool _isLoggedIn = false;

  @override
  void initState() { 
    super.initState();
    isDarkMode = widget.initialDarkMode;
    _locale = widget.initialLocale;
  }

  void toggleTheme() async {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  void setLocale(Locale newLocale) async {
    setState(() {
      _locale = newLocale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);
  }

  void handleLogout() {
    setState(() {
      // _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          primary: AppColors.primaryGreen,
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        scaffoldBackgroundColor: isDarkMode 
            ? AppColors.darkBackground 
            : AppColors.lightBackground,
        cardColor: isDarkMode 
            ? AppColors.darkCard 
            : AppColors.lightCard,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: isDarkMode 
                ? AppColors.darkText 
                : AppColors.lightText,
          ),
          bodyMedium: TextStyle(
            color: isDarkMode 
                ? AppColors.darkTextSecondary 
                : AppColors.lightTextSecondary,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: isDarkMode ? AppColors.darkCard : Colors.white,
          elevation: 24,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primaryGreen,
            ),
          ),
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.grey[600] : Colors.grey[500],
          ),
        ),
        dividerTheme: DividerThemeData(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
        ),
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.grey[700],
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: isDarkMode ? AppColors.darkCard : Colors.white,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: isDarkMode ? Colors.grey[600] : Colors.grey[400],
        ),
        useMaterial3: true,
      ),
      home: ResponsiveLayout(
        isDarkMode: isDarkMode,
        onThemeToggle: toggleTheme,
        currentLocale: _locale,
        onLocaleChange: setLocale,
        onLogout: handleLogout,
      ),
      // Comment out login condition
      // home: _isLoggedIn 
      //     ? ResponsiveLayout(
      //         isDarkMode: isDarkMode,
      //         onThemeToggle: toggleTheme,
      //         currentLocale: _locale,
      //         onLocaleChange: setLocale,
      //         onLogout: handleLogout,
      //       )
      //     : LoginPage(
      //         onLoginSuccess: () => setState(() => _isLoggedIn = true),
      //       ),
    );
  }
}
