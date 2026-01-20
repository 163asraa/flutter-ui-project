// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/providers/auth_provider.dart';
// import 'package:supa_electronics/screens/auth/login_screen.dart';
// import 'package:supa_electronics/screens/home_screen.dart';

// class WelcomeScreen extends StatefulWidget {
//   const WelcomeScreen({super.key});

//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }

// class _WelcomeScreenState extends State<WelcomeScreen> {
//   int _currentIndex = 0;
//   bool _navigated = false; // ✅ لتجنب التنقل بعد الإزالة

//   @override
//   void initState() {
//     super.initState();

//     Future.delayed(const Duration(seconds: 4), () {
//       if (!mounted) return;
//       setState(() {
//         _currentIndex = 1;
//       });
//     });

//     Future.delayed(const Duration(seconds: 8), () async {
//       if (!mounted || _navigated) return;
//       _navigated = true;

//       final auth = Provider.of<AuthProvider>(context, listen: false);
//       await auth.loadToken();

//       if (!mounted) return;
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) =>
//               auth.token == null ?  LoginScreen() :  HomeScreen(),
//         ),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _navigated = true; // ✅ ما منسمح بالتنقل بعد التخلص من الواجهة
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 AnimatedSwitcher(
//                   duration: const Duration(seconds: 1),
//                   transitionBuilder: (Widget child, Animation<double> animation) {
//                     return RotationTransition(
//                       turns: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
//                       child: child,
//                     );
//                   },
//                   child: _currentIndex == 0
//                       ? Image.asset(
//                           'assets/imm.png',
//                           key: const ValueKey<int>(0),
//                           width: 500,
//                           height: 300,
//                         )
//                       : Image.asset(
//                           'assets/im.png',
//                           key: const ValueKey<int>(1),
//                           width: 500,
//                           height: 300,
//                         ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'أهلاً بك في',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'SHop_Rise',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 4, 94, 97),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/const/color.dart';
// import 'package:supa_electronics/const/const.dart';
// import 'package:supa_electronics/providers/auth_provider.dart';
// import 'package:supa_electronics/screens/auth/login_screen.dart';
// import 'package:supa_electronics/screens/home_screen.dart';

// class WelcomeScreen extends StatefulWidget {
//   const WelcomeScreen({super.key});

//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }

// class _WelcomeScreenState extends State<WelcomeScreen> {
//   @override
// @override
// void initState() {
//   super.initState();

//   Future.microtask(() {
//     final auth = Provider.of<AuthProvider>(context, listen: false);
//     if (auth.token == null) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     } else {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//       );
//     }
//   });
// }


//   Future<void> _checkAuthAndNavigate() async {
//     final auth = Provider.of<AuthProvider>(context, listen: false);
//     await auth.loadToken(); // ننتظر تحميل التوكن

//     Future.delayed(const Duration(seconds: 9), () {
//       if (!mounted) return;
// Navigator.of(context).pushAndRemoveUntil(
//   MaterialPageRoute(builder: (context) => HomeScreen()),
//   (Route<dynamic> route) => false,
// );

//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // الموجة العلوية
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: ClipPath(
//               clipper: TopWaveClipper(),
//               child: Container(
//                 height: 150,
//                 color: AppColors.secondary,
//               ),
//             ),
//           ),

//           // الموجة السفلية
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: ClipPath(
//               clipper: BottomWaveClipper(),
//               child: Container(
//                 height: 150,
//                 color: AppColors.secondary,
//                 alignment: Alignment.center,
//                 child: const Text(
//                   "Welcome",
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     fontFamily: 'LobsterTwo',
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // الصورة المتحركة
//           Center(
//             child: Image.asset(
//               'assets/ezgif.com-video-to-gif-converter.gif',
//               width: 200,
//               height: 200,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/const/color.dart';
// import 'package:supa_electronics/const/const.dart';
// import 'package:supa_electronics/providers/auth_provider.dart';
// import 'package:supa_electronics/screens/auth/login_screen.dart';
// import 'package:supa_electronics/screens/home_screen.dart';

// class WelcomeScreen extends StatefulWidget {
//   const WelcomeScreen({super.key});

//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }

// class _WelcomeScreenState extends State<WelcomeScreen> {
//   @override
// @override
// void initState() {
//   super.initState();
//   _navigateAfterVideo();
// }

// Future<void> _navigateAfterVideo() async {
//   final auth = Provider.of<AuthProvider>(context, listen: false);
//   await auth.loadToken(); // نحمّل التوكن قبل أي شيء

//   await Future.delayed(const Duration(seconds: 9)); // ننتظر الفيديو

//   if (!mounted) return;

//   if (auth.token != null) {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (_) => HomeScreen()),
//     );
//   } else {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (_) => LoginScreen()),
//     );
//   }
// }


//   Future<void> _checkAuthAndNavigate() async {
//     final auth = Provider.of<AuthProvider>(context, listen: false);
//     await auth.loadToken(); // ننتظر تحميل التوكن

//     Future.delayed(const Duration(seconds: 9), () {
//       if (!mounted) return;
// Navigator.of(context).pushAndRemoveUntil(
//   MaterialPageRoute(builder: (context) => HomeScreen()),
//   (Route<dynamic> route) => false,
// );

//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // الموجة العلوية
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: ClipPath(
//               clipper: TopWaveClipper(),
//               child: Container(
//                 height: 150,
//                 color: AppColors.secondary,
//               ),
//             ),
//           ),

//           // الموجة السفلية
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: ClipPath(
//               clipper: BottomWaveClipper(),
//               child: Container(
//                 height: 150,
//                 color: AppColors.secondary,
//                 alignment: Alignment.center,
//                 child: const Text(
//                   "Welcome",
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     fontFamily: 'LobsterTwo',
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // الصورة المتحركة
//           Center(
//             child: Image.asset(
//               'assets/ezgif.com-video-to-gif-converter.gif',
//               width: 200,
//               height: 200,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supa_electronics/const/color.dart';
import 'package:supa_electronics/const/const.dart';
import 'package:supa_electronics/providers/auth_provider.dart';
import 'package:supa_electronics/screens/auth/login_screen.dart';
import 'package:supa_electronics/screens/home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterVideo();
  }

  Future<void> _navigateAfterVideo() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.loadToken();
    await Future.delayed(const Duration(seconds: 9));

    if (!mounted) return;

    if (auth.token != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // الشكل العلوي
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
          // الشكل السفلي
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
                  " أهلاً بك فيShop Rize",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // صورة الترحيب المتحركة
          Center(
            child: Image.asset(
              'assets/ezgif.com-video-to-gif-converter.gif',
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
