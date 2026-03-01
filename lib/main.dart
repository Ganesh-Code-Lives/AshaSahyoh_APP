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

  await NotificationService().init();
  
  await Supabase.initialize(
    url: 'https://kfrgkhhsnyqqvqtwimbx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtmcmdraGhzbnlxcXZxdHdpbWJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzEwNTEyNTgsImV4cCI6MjA4NjYyNzI1OH0.pOSmrezElecOcCm6ANJ81nO_WN9wnc_EdLq1mwAmXZU',
  );
  print("Supabase Initialized");
  
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final hasCompletedProfile = prefs.getBool('hasCompletedProfile') ?? false;

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

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isAuthenticated;
  String onboardingScreen = 'intro';
  bool _isLoginFlow = false;
  bool _isGrayscale = false;

  bool get isGrayscale => _isGrayscale;
  void toggleGrayscale() async {
    setState(() => _isGrayscale = !_isGrayscale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGrayscale', _isGrayscale);
  }

  String language = '';
  String mobileNumber = '';
  Map<String, dynamic>? personalData;
  Map<String, dynamic>? disabilityData;

  @override
  void initState() {
    super.initState();
    _loadPrefs();

    isAuthenticated = widget.isLoggedIn && widget.hasCompletedProfile;
    if (widget.isLoggedIn && !widget.hasCompletedProfile) {
      onboardingScreen = 'personal';
    }
    if (!widget.isLoggedIn && widget.hasCompletedProfile) {
      onboardingScreen = 'authChoice';
    }
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGrayscale = prefs.getBool('isGrayscale') ?? false;
    });
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
    if (_isLoginFlow) {
      final prefs = await SharedPreferences.getInstance();
      final hasProfile = prefs.getBool('hasCompletedProfile') ?? false;
      if (hasProfile) {
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
        setState(() {
          onboardingScreen = 'personal';
        });
      }
    } else {
      setState(() {
        onboardingScreen = 'personal';
      });
    }
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
      isAuthenticated = true;
    });
  }

  void _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

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
      builder: (context, child) {
        Widget app = child!;
        if (_isGrayscale) {
          app = ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0, 0, 0, 1, 0,
            ]),
            child: app,
          );
        }
        return Stack(
          children: [
            app,
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 8,
              child: Material(
                type: MaterialType.transparency,
                child: _ThemeToggleButton(),
              ),
            ),
          ],
        );
      },
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
          onBack: () {
            setState(() {
              onboardingScreen = 'mobile';
              mobileNumber = '';
            });
          },
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

class _ThemeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context)!;
    final isGray = appState.isGrayscale;
    return InkWell(
      onTap: appState.toggleGrayscale,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isGray ? Icons.filter_b_and_w : Icons.palette,
                size: 18, color: AppTheme.primary),
            const SizedBox(width: 4),
            Text(isGray ? 'Normal' : 'Grayscale',
                style: TextStyle(color: AppTheme.textMain, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
