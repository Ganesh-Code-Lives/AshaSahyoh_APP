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
  }

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
      onboardingScreen = 'otp';
    });
  }

  void _completeOtp() {
    setState(() {
      // Don't set isAuthenticated = true yet!
      onboardingScreen = 'personal'; 
    });
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Using clear() as requested in Step 7
    
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
      case 'language':
        return LanguageSelection(onComplete: _completeLanguage);
      case 'mobile':
        return MobileNumberInput(onComplete: _completeMobile);
      case 'otp':
        return OTPVerification(
          mobile: mobileNumber, 
          verificationId: 'TWILIO_VERIFY',
          onComplete: _completeOtp
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
