import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supa_electronics/const/color.dart';
import 'package:supa_electronics/const/const.dart';
import 'package:supa_electronics/screens/home_screen.dart';
import '../../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController(); // ✅ عدلنا الاسم
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, theme.colorScheme.surface],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: TopWaveClipper(),
              child: Container(
                height: 150,
                color: AppColors.secondary,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                height: 150,
                color: AppColors.secondary,
                alignment: Alignment.center,
                child: const Text(
                  "مرحبًا بك",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'LobsterTwo',
                  ),
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              child: const Text(
                                "مرحبًا بك",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'سجّل الدخول إلى حسابك',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppColors.secondary,fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 48),
                            Container(
                              padding: EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    style: TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                      labelText: 'البريد الإلكتروني',
                                      labelStyle: TextStyle(color: Colors.black54),
                                      prefixIcon: Icon(Icons.email_outlined),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: AppColors.primary),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: theme.colorScheme.primary),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  SizedBox(height: 24),
                                  TextFormField(
                                    controller: _passwordController,
                                    style: TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                      labelText: 'كلمة المرور',
                                      labelStyle: TextStyle(color: Colors.black54),
                                      prefixIcon: Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        icon: Icon(_isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible = !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: AppColors.primary),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: theme.colorScheme.primary),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                    ),
                                    obscureText: !_isPasswordVisible,
                                  ),
                                  SizedBox(height: 32),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    height: 56,
                                    child: _isLoading
                                        ? Center(child: CircularProgressIndicator())
                                        : ElevatedButton(
                                            onPressed: () async {
                                              if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('يرجى ملء جميع الحقول'),
                                                    behavior: SnackBarBehavior.floating,
                                                    backgroundColor: theme.colorScheme.error,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }

                                              setState(() => _isLoading = true);

                                              try {
                                                await authProvider.login(
                                                 // "sos123@gmail.com",
                                                  
                                                  //"123123123"
                                                 _emailController.text,
                                                  _passwordController.text,
                                                );
                                                  print('✅ بيانات المستخدم الحقيقية تم حفظها:');
                                                  print('Token: ${authProvider.token}');
                                                  print('Username: ${authProvider.username}');
                                                  print('Email: ${authProvider.userEmail}');
                                                  print('UserID: ${authProvider.userId}');


                                                if (!mounted) return;

                                                if (authProvider.token != null) {
                                                  
                                                
                                                  SharedPreferences prefs = await SharedPreferences.getInstance();

await prefs.setString('token', authProvider.token!);
await prefs.setString('username', authProvider.username ?? '');
await prefs.setString('email', authProvider.userEmail ?? '');
await prefs.setString('id', authProvider.userId ?? '');


                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(builder: (_) => HomeScreen()),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('فشل تسجيل الدخول، تحقق من الاتصال'),
                                                      behavior: SnackBarBehavior.floating,
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('فشل تسجيل الدخول: $e'),
                                                    behavior: SnackBarBehavior.floating,
                                                    backgroundColor: theme.colorScheme.error,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                );
                                              } finally {
                                                setState(() => _isLoading = false);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.secondary,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              elevation: 3,
                                              padding: EdgeInsets.symmetric(vertical: 16),
                                            ),
                                            child: Text(
                                              'تسجيل الدخول',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => RegisterScreen()),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color.fromARGB(255, 6, 51, 38),
                              ),
                              child: Text(
                                'ليس لديك حساب؟ أنشئ حسابًا',
                                style: TextStyle(
                                  fontSize: 16,
                                    color: AppColors.secondary,fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
