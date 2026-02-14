import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class OTPVerification extends StatefulWidget {
  final String mobile;
  final String verificationId;
  final Function() onComplete;

  const OTPVerification({
    super.key, 
    required this.mobile, 
    required this.verificationId,
    required this.onComplete
  });

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  // Use a list of controllers to manage the input state
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isComplete = false;
  bool _isLoading = false;
  String? _errorMessage;
  final AuthService _authService = AuthService();
  
  late Timer _timer;
  int _start = 30;
  bool _isResendAvailable = false;

  late String _currentVerificationId;

  @override
  void initState() {
    super.initState();
    _currentVerificationId = widget.verificationId;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _start = 30;
      _isResendAvailable = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer.cancel();
          _isResendAvailable = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _verifyOTP() async {
    if (_isLoading) return;
    String otp = _controllers.map((e) => e.text).join();
    if (otp.length != 6) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool success = await _authService.verifyOtp('+91${widget.mobile}', otp);
      
      if (success && mounted) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userPhone', widget.mobile); // Keeping userPhone as well for compatibility if needed
        await prefs.setString('phoneNumber', widget.mobile); // User's requested key
        
        setState(() => _isLoading = false);
        widget.onComplete(); 
      } else {
        throw 'Invalid OTP. Please try again.';
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }
  
  void _resendOTP() async {
    if (!_isResendAvailable || _isLoading) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await _authService.sendOtp('+91${widget.mobile}');
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (success) {
        _startTimer();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP Resent!")));
      } else {
        setState(() {
          _errorMessage = "Resend failed. Please try again.";
        });
      }
    }
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        // Check if all digits are entered before verifying
        bool allFilled = _controllers.every((c) => c.text.isNotEmpty);
        if (allFilled) {
           _verifyOTP(); 
        }
      }
    }
    
    setState(() {
      _isComplete = _controllers.every((c) => c.text.isNotEmpty);
    });
  }

  // Handle backspace manually for empty fields
  void _onKey(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress
                Row(
                  children: [
                    Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2)))),
                    const SizedBox(width: 8),
                    Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2)))),
                    const SizedBox(width: 8),
                    Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2)))),
                    const SizedBox(width: 8),
                    Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(2)))),
                  ],
                ),
                const SizedBox(height: 32),
                
                const Text('Verify Your Number', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                const SizedBox(height: 8),
                Text('Enter the 6-digit code sent to +91 ${widget.mobile}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                const SizedBox(height: 40),
                
                // OTP Inputs
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Row(
                      children: List.generate(6, (index) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 0 : 4,
                              right: index == 5 ? 0 : 4,
                            ),
                            child: SizedBox(
                              height: 56,
                              child: RawKeyboardListener(
                                focusNode: FocusNode(), // Intercepts key events
                                onKey: (event) => _onKey(event, index),
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  enabled: !_isLoading,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) => _onChanged(value, index),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppTheme.inputBorder),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppTheme.inputBorder),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppTheme.primary, width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                if (_errorMessage != null)
                   Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Center(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: AppTheme.error, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                
                const SizedBox(height: 32),
                
                Center(
                  child: TextButton(
                    onPressed: _isResendAvailable ? _resendOTP : null,
                    child: Text(
                       _isResendAvailable 
                         ? "Didn't receive code? Resend OTP"
                         : "Resend OTP in ${_start}s",
                       style: TextStyle(
                         color: _isResendAvailable ? AppTheme.primary : AppTheme.textSecondary, 
                         fontWeight: FontWeight.w600
                       ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: (_isComplete && !_isLoading) ? AppTheme.primaryGradient : null,
            color: (_isComplete && !_isLoading) ? null : AppTheme.primary.withOpacity(0.1),
          ),
          child: ElevatedButton(
            onPressed: (_isComplete && !_isLoading) ? _verifyOTP : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: (_isComplete && !_isLoading) ? Colors.white : AppTheme.primary.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isLoading 
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5, 
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Verifying...', 
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        )
                      ),
                    ],
                  )
                : const Text(
                    'Verify & Continue', 
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    )
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
