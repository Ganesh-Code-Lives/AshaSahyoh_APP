import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'services/notification_service.dart';
import 'screens/intro_screen.dart';
import 'screens/language_selection.dart';
import 'screens/mobile_number_input.dart';
import 'screens/otp_verification.dart';
import 'screens/auth_choice.dart';
import 'screens/personal_details.dart';
import 'screens/disability_details.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await NotificationService().init();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://kfrgkhhsnyqqvqtwimbx.supabase.co', // TODO: Replace with your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtmcmdraGhzbnlxcXZxdHdpbWJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzEwNTEyNTgsImV4cCI6MjA4NjYyNzI1OH0.pOSmrezElecOcCm6ANJ81nO_WN9wnc_EdLq1mwAmXZU', // TODO: Replace with your Supabase Anon Key
  );
  print("Supabase Initialized");
  
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final hasCompletedProfile = prefs.getBool('hasCompletedProfile') ?? false;

  // Set global system UI overlays
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(MyApp(
    isLoggedIn: isLoggedIn, 
    hasCompletedProfile: hasCompletedProfile,
  ));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final bool hasCompletedProfile;
  const MyApp({
    super.key, 
    required this.isLoggedIn,
    required this.hasCompletedProfile,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Application State
  late bool isAuthenticated;
  String onboardingScreen = 'intro';
  bool _isLoginFlow = false; // tracks whether user chose login or signup
  
  // User Data State
  String language = '';
  String mobileNumber = '';
  Map<String, dynamic>? personalData;
  Map<String, dynamic>? disabilityData;

  @override
  void initState() {
    super.initState();
    // User is only fully authenticated if they logged in AND completed onboarding
    isAuthenticated = widget.isLoggedIn && widget.hasCompletedProfile;
    
    // If logged in but onboarding not complete, start at mobile/otp/details depending on state
    if (widget.isLoggedIn && !widget.hasCompletedProfile) {
       onboardingScreen = 'personal'; // Re-start at details if phone is already verified
    }

    // If user has completed profile but not currently logged in, we want to
    // show the auth choice screen so they can either login or sign up again.
    if (!widget.isLoggedIn && widget.hasCompletedProfile) {
      onboardingScreen = 'authChoice';
    }
  }

  void _completeIntro() {
    setState(() => onboardingScreen = 'authChoice');
  }

  void _completeAuthChoice(bool isLogin) {
    setState(() {
      _isLoginFlow = isLogin;
      onboardingScreen = 'language';
    });
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
      onboardingScreen = 'otp';
    });
  }

  void _completeOtp() async {
    // After OTP verification we branch based on whether the user was trying to
    // log in or sign up.
    if (_isLoginFlow) {
      final prefs = await SharedPreferences.getInstance();
      final hasProfile = prefs.getBool('hasCompletedProfile') ?? false;
      if (hasProfile) {
        // load stored profile data
        personalData = {
          'fullName': prefs.getString('fullName'),
          'email': prefs.getString('email'),
          'dateOfBirth': prefs.getString('dateOfBirth'),
          'gender': prefs.getString('gender'),
          'address': prefs.getString('address'),
        };
        disabilityData = {
          'hasDisability': prefs.getBool('hasDisability') ?? false,
          'disabilityType': prefs.getString('disabilityType'),
          'disabilityPercentage': prefs.getString('disabilityPercentage'),
          'certificateNumber': prefs.getString('certificateNumber'),
          'assistiveDevices': prefs.getStringList('assistiveDevices'),
        };
        setState(() {
          isAuthenticated = true;
        });
      } else {
        // phone not registered yet, treat as normal signup
        setState(() {
          onboardingScreen = 'personal';
        });
      }
    } else {
      setState(() {
        onboardingScreen = 'personal';
      });
    }
    // once used, reset login flag so it won't affect future flows
    _isLoginFlow = false;
  }

  void _completePersonal(Map<String, dynamic> data) {
    setState(() {
      personalData = data;
      onboardingScreen = 'disability';
    });
  }

  void _completeDisability(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedProfile', true);
    
    setState(() {
      disabilityData = data;
      isAuthenticated = true; // Finally enter the Dashboard
    });
  }

  void _handleLogout() async {
    // Only remove the logged in flag; keep profile data for future logins
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    // optionally prefs.remove('phoneNumber');

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
      home: isAuthenticated 
          ? HomeScreen(
              personalData: personalData,
              disabilityData: disabilityData,
              onLogout: _handleLogout,
            )
          : _buildOnboardingFlow(),
    );
  }

  Widget _buildOnboardingFlow() {
    switch (onboardingScreen) {
      case 'intro':
        return IntroScreen(onStart: _completeIntro);
      case 'authChoice':
        return AuthChoice(onChosen: _completeAuthChoice);
      case 'language':
        return LanguageSelection(onComplete: _completeLanguage);
      case 'mobile':
        return MobileNumberInput(onComplete: _completeMobile);
      case 'otp':
        return OTPVerification(
          mobile: mobileNumber,
          verificationId: 'TWILIO_VERIFY',
          isLogin: _isLoginFlow,
          onComplete: _completeOtp,
        );
      case 'personal':
        return PersonalDetails(onComplete: _completePersonal);
      case 'disability':
        return DisabilityDetails(onComplete: _completeDisability);
      default:
        return IntroScreen(onStart: _completeIntro);
    }
  }
}
