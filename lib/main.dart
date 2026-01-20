import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'services/api_service.dart';
import 'screens/auth/welcome.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_screen.dart';
import 'screens/profile_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  if (!kIsWeb) {
    Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
    await Stripe.instance.applySettings();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = authProvider.token;
    final apiService = ApiService(token: token ?? '');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(apiService)..loadCartItems(),
        ),
      ],
      child: MaterialApp(
        title: 'Shop Rize',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData.light().copyWith(
          textTheme: ThemeData.light().textTheme.apply(
            fontFamily: 'Cairo',
          ),
        ),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl, // ✅ المحاذاة لليمين دائمًا
            child: child!,
          );
        },
        initialRoute: '/welcome',
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/orders': (context) => OrderScreen(),
          '/cart': (context) => CartScreen(),
          '/profile': (context) {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            return ProfileScreen(
              token: authProvider.token!,
              onLogout: () async {
                await authProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            );
          },
        },
      ),
    );
  }
}
