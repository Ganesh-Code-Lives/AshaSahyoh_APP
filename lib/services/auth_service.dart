import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Mock Mode for testing without a real backend
  // Set this to false when your Supabase Edge Functions are deployed
  final bool useMockMode = false;

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Future<bool> sendOtp(String phone) async {
    if (useMockMode) {
      print("MOCK MODE: Sending OTP to $phone");
      await Future.delayed(const Duration(seconds: 1));
      return true;
    }

    try {
      print("Attempting to invoke 'send-otp' function for phone: $phone");
      print("Calling send-otp function...");
      
      final response = await supabase.functions.invoke(
        'send-otp',
        body: {'phone': phone},
      );

      print("Response status: ${response.status}");

      if (response.status >= 200 && response.status < 300) {
        return true;
      } else {
        print("Send OTP Error status: ${response.status}");
        return false;
      }
    } on FunctionException catch (e) {
      print("Supabase FunctionException: ${e.toString()}");
      return false;
    } catch (e) {
      print("General Send OTP Exception: $e");
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String code) async {
    if (useMockMode) {
      print("MOCK MODE: Verifying OTP $code for $phone");
      await Future.delayed(const Duration(seconds: 1));
      return code == "123456"; // Default mock OTP
    }

    try {
      final response = await supabase.functions.invoke(
        'verify-otp',
        body: {
          'phone': phone,
          'code': code,
        },
      );

      if (response.status >= 200 && response.status < 300) {
        // Assume Twilio Verify returns status: approved
        return response.data['status'] == 'approved';
      } else {
        print("Verify OTP Error: ${response.data}");
        return false;
      }
    } catch (e) {
      print("Verify OTP Exception: $e");
      return false;
    }
  }
}
