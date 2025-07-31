import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawgenius/core/constants/app_colors.dart';
import 'package:lawgenius/core/constants/app_text_styles.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onDigitEntered(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _navigateToNewPassword() {
    context.go('/new-password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify Code',
          style: TextStyle(color: AppColors.background),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          //key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Verify Code",
                style: AppTextStyles.formHeader,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Please enter the code we sent to email",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const Text(
                "example@email.com",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.primary),
              ),
              const SizedBox(height: 30),

              Text(
                'Enter the 4-digit code',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      width: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          counterText: '', // removes character counter
                          filled: true,
                          fillColor: const Color.fromARGB(
                            255,
                            242,
                            242,
                            242,
                          ), // background color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                        ),
                        onChanged: (value) => _onDigitEntered(value, index),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _navigateToNewPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Text(
                  'Verify Code',
                  style: TextStyle(fontSize: 16, color: AppColors.background),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
