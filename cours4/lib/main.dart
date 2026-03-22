import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:formation_flutter/screens/homepage/homepage_screen.dart';
import 'package:formation_flutter/screens/product/product_page.dart';
import 'package:formation_flutter/screens/product/recall_details_page.dart';
import 'package:go_router/go_router.dart';
import 'package:formation_flutter/model/recall.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/service/auth_service.dart';
import 'package:formation_flutter/screens/auth/login_page.dart';
import 'package:formation_flutter/screens/auth/signup_page.dart';
import 'package:provider/provider.dart';
import 'package:formation_flutter/screens/scanner/scanner_page.dart';
import 'package:formation_flutter/screens/favorites/favorites_page.dart';
void main() async {
  final authService = AuthService(); // vérif l'authentification 
  await authService.checkAuthStatus();
  
  runApp(MyApp(authService: authService));
}

GoRouter _buildRouter(AuthService authService) {
  return GoRouter(
    initialLocation: authService.isAuthenticated ? '/' : '/login',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => HomePage(),
      ),
      
      GoRoute(
        path: '/product',
        builder: (_, GoRouterState state) =>
            ProductPage(barcode: state.extra as String),
      ),
      
      GoRoute(
        path: '/recall',
        builder: (_, GoRouterState state) {
          final extras = state.extra as Map<String, dynamic>;
          final recall = extras['recall'] as Recall;
          final product = extras['product'] as Product?;
          return RecallDetailsPage(
            recall: recall,
            product: product,
          );
        }
      ),
      
      GoRoute( 
        path: '/login',
        builder: (_, _) => const LoginPage(),
      ),
      
      GoRoute(
        path: '/signup',
        builder: (_, _) => const SignupPage(),
      ),
      GoRoute(
        path: '/scanner',
        builder: (_, _) => const ScannerPage(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (_, _) => const FavoritesPage(),
      )
    ],
    
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authService.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSigningUp = state.matchedLocation == '/signup';

      if (!isLoggedIn && !isLoggingIn && !isSigningUp) {
        return '/login';
      }

      if (isLoggedIn && (isLoggingIn || isSigningUp)) {
        return '/';
      }

      return null; 
    },
  );
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  
  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: authService),
      ],
      child: MaterialApp.router(
        title: 'Open Food Facts',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          extensions: [OffThemeExtension.defaultValues()],
          fontFamily: 'Avenir',
          dividerTheme: DividerThemeData(color: AppColors.grey2, space: 1.0),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: AppColors.blue,
            unselectedItemColor: AppColors.grey2,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
          ),
          navigationBarTheme: const NavigationBarThemeData(
            indicatorColor: AppColors.blue,
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: _buildRouter(authService),
      ),
    );
  }
}