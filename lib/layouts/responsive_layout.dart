import 'package:flutter/material.dart';
import '../pages/page1.dart';
import '../pages/page2.dart';
import '../pages/profile_page.dart';
import '../utils/app_localizations.dart';

class ResponsiveLayout extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final Locale currentLocale;
  final Function(Locale) onLocaleChange;
  final VoidCallback onLogout;

  const ResponsiveLayout({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.currentLocale,
    required this.onLocaleChange,
    required this.onLogout,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const Page1(),
          const Page2(),
          ProfilePage(
            isDarkMode: widget.isDarkMode,
            onThemeToggle: widget.onThemeToggle,
            currentLocale: widget.currentLocale,
            onLocaleChange: widget.onLocaleChange,
            onLogout: widget.onLogout,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            label: loc.get('page1'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.business),
            label: loc.get('page2'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person),
            label: loc.get('profile'),
          ),
        ],
      ),
    );
  }
} 