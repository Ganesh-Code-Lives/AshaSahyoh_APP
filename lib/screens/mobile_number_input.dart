import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import 'otp_verification.dart';

class MobileNumberInput extends StatefulWidget {
  final Function(String, String) onComplete;

  const MobileNumberInput({super.key, required this.onComplete});

  @override
  State<MobileNumberInput> createState() => _MobileNumberInputState();
}

class _MobileNumberInputState extends State<MobileNumberInput> {
  final TextEditingController _controller = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  
  void _handleContinue() async {
    if (_controller.text.length != 10) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String phoneNumber = '+91${_controller.text}';

    await _authService.sendOtp(
      phoneNumber: phoneNumber,
      onCodeSent: () {
        if (mounted) {
          setState(() => _isLoading = false);
          // Assuming AuthService stored the ID.
          // We pass a dummy or the stored one to the parent callback if it expects one.
          // But wait, main.dart expects (mobile, verId).
          // We can expose verId from AuthService.
          widget.onComplete(_controller.text, _authService.verificationId ?? '');
        }
      },
      onError: (message) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = message;
          });
        }
      },
    );
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
                    Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppTheme.purpleLight, borderRadius: BorderRadius.circular(2)))),
                    const SizedBox(width: 8),
                    Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppTheme.purpleLight, borderRadius: BorderRadius.circular(2)))),
                  ],
                ),
                const SizedBox(height: 32),

                const Text('Enter Mobile Number', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                const SizedBox(height: 8),
                const Text("We'll send you a verification code", style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                const SizedBox(height: 40),

                const Text('Mobile Number', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),

                // Input Box
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppTheme.inputBorder),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Text('+91', style: TextStyle(fontSize: 18, color: AppTheme.textMain, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Container(width: 1, height: 24, color: AppTheme.border),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppTheme.textMain),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Enter 10 digit number',
                            hintStyle: TextStyle(color: AppTheme.textSecondary),
                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (_errorMessage != null)
                   Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: AppTheme.error, fontSize: 14),
                    ),
                  ),

                if (_controller.text.isNotEmpty && _controller.text.length < 10)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Please enter a valid 10-digit mobile number',
                      style: TextStyle(color: AppTheme.error, fontSize: 14),
                    ),
                  ),

                const SizedBox(height: 32),

                // Disclaimer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.purpleVeryLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, size: 20, color: AppTheme.primary),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'By continuing, you agree to receive SMS verification codes.',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
                        ),
                      ),
                    ],
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
            gradient: _controller.text.length == 10 && !_isLoading ? AppTheme.primaryGradient : null,
            color: _controller.text.length == 10 && !_isLoading ? null : AppTheme.primary.withOpacity(0.1),
          ),
          child: ElevatedButton(
            onPressed: (_controller.text.length == 10 && !_isLoading) ? _handleContinue : null,
            style: ElevatedButton.styleFrom(
               backgroundColor: Colors.transparent,
               shadowColor: Colors.transparent,
               foregroundColor: (_controller.text.length == 10 && !_isLoading) ? Colors.white : AppTheme.primary.withOpacity(0.5),
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
                        'Sending code...', 
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        )
                      ),
                    ],
                  )
                : const Text(
                    'Send OTP', 
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
