import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  final bool useMockMode = false;

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
      return code == "123456";
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
