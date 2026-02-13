import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/intro_screen.dart';
import 'screens/language_selection.dart';
import 'screens/mobile_number_input.dart';
import 'screens/otp_verification.dart';
import 'screens/personal_details.dart';
import 'screens/disability_details.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set global system UI overlays for a production-ready look
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Application State
  bool isAuthenticated = false;
  String onboardingScreen = 'intro'; // 'intro', 'language', 'mobile', 'otp', 'personal', 'disability'
  
  // User Data State
  String language = '';
  String mobileNumber = '';
  String? verificationId;
  Map<String, dynamic>? personalData;
  Map<String, dynamic>? disabilityData;

  void _completeIntro() {
    setState(() => onboardingScreen = 'language');
  }

  void _completeLanguage(String selectedLanguage) {
    setState(() {
      language = selectedLanguage;
      onboardingScreen = 'mobile';
    });
  }

  void _completeMobile(String mobile, String verId) {
    setState(() {
      mobileNumber = mobile;
      verificationId = verId;
      if (verId == 'AUTO_VERIFIED') {
        onboardingScreen = 'personal'; // Skip OTP
      } else {
        onboardingScreen = 'otp';
      }
    });
  }

  void _completeOtp() {
    setState(() => onboardingScreen = 'personal');
  }

  void _completePersonal(Map<String, dynamic> data) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(data['fullName']);
      // Note: user.updateEmail requires sensitive action re-auth, so we'll just keep it in our Map
    }
    setState(() {
      personalData = data;
      onboardingScreen = 'disability';
    });
  }

  void _completeDisability(Map<String, dynamic> data) {
    setState(() {
      disabilityData = data;
      isAuthenticated = true;
    });
  }

  void _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      isAuthenticated = false;
      onboardingScreen = 'intro';
      language = '';
      mobileNumber = '';
      personalData = null;
      disabilityData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AshaSahyog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If the connection is active, check the auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final bool hasFirebaseUser = snapshot.hasData;

          // If we have a firebase user
          if (hasFirebaseUser) {
            final User user = snapshot.data!;
            
            // Auto-populate basic details from Firebase if missing (e.g. after reload)
            if (personalData == null) {
              personalData = {
                'fullName': user.displayName ?? 'User',
                'email': user.email ?? '',
                'mobile': user.phoneNumber?.replaceAll('+91', '') ?? '',
              };
            }

            // If they just finished the flow in this session
            if (isAuthenticated) {
              return HomeScreen(
                personalData: personalData,
                disabilityData: disabilityData,
                onLogout: _handleLogout,
              );
            }

            // If they are in the middle of onboarding steps
            if (onboardingScreen == 'personal') {
              return PersonalDetails(onComplete: _completePersonal);
            }
            if (onboardingScreen == 'disability') {
              return DisabilityDetails(onComplete: _completeDisability);
            }

            // Default for auto-login (already finished in a previous session)
            return HomeScreen(
              personalData: personalData,
              disabilityData: disabilityData,
              onLogout: _handleLogout,
            );
          }

          // User is NOT signed in via Firebase → Show onboarding flow (Intro, Language, Mobile, OTP)
          return _buildOnboardingFlow();
        },
      ),
    );
  }

  Widget _buildOnboardingFlow() {
    switch (onboardingScreen) {
      case 'intro':
        return IntroScreen(onStart: _completeIntro);
      case 'language':
        return LanguageSelection(onComplete: _completeLanguage);
      case 'mobile':
        return MobileNumberInput(onComplete: _completeMobile);
      case 'otp':
        return OTPVerification(
          mobile: mobileNumber, 
          verificationId: verificationId ?? '',
          onComplete: _completeOtp
        );
      default:
        return IntroScreen(onStart: _completeIntro);
    }
  }
}
