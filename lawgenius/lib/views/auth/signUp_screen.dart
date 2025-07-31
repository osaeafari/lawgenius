import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawgenius/core/constants/app_colors.dart';
import 'package:lawgenius/core/constants/app_text_styles.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreedToTerms = false;

  void _navigateToLogin(BuildContext context) {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Text(
                "Create Account",
                style: AppTextStyles.formHeader,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Fill your information below or register\nwith your social account.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 40),

              // Name Field
              Text('Name'),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'John Doe',
                  filled: true,
                  fillColor: Color(0xFFF5F5F5), // light grey background
                  hintStyle: TextStyle(color: AppColors.lightgrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: TextStyle(color: Colors.black), // optional text color
              ),
              const SizedBox(height: 16),

              // Email Field
              Text('Email'),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'example@email.com',
                  filled: true,
                  fillColor: Color(0xFFF5F5F5), // light grey background
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: TextStyle(color: Colors.black), // optional text color
              ),
              const SizedBox(height: 16),

              // Password Field
              Text('Password'),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Color(0xFFF5F5F5), // light grey background
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                style: TextStyle(color: Colors.black), // optional text color
              ),
              const SizedBox(height: 12),

              // Terms and Conditions
              Row(
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (value) {
                      setState(() => _agreedToTerms = value!);
                    },
                    activeColor: AppColors.primary,
                  ),
                  const Text("Agree with "),
                  GestureDetector(
                    onTap: () {
                      // handle terms tap
                    },
                    child: const Text(
                      "Terms & Condition",
                      style: TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Sign Up Button
              ElevatedButton(
                onPressed: _agreedToTerms ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 16, color: AppColors.background),
                ),
              ),
              const SizedBox(height: 30),

              // Divider with text
              // Row(
              //   children: const [
              //     Expanded(child: Divider()),
              //     Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 8),
              //       child: Text("Or sign up with"),
              //     ),
              //     Expanded(child: Divider()),
              //   ],
              // ),
              // const SizedBox(height: 30),

              // // Social Icons
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     _buildSocialIcon("assets/images/icons/apple-icon.png"),
              //     const SizedBox(width: 16),
              //     _buildSocialIcon("assets/images/icons/google-icon.png"),
              //     const SizedBox(width: 16),
              //     _buildSocialIcon("assets/images/icons/facebook-icon.png"),
              //   ],
              // ),
              // const SizedBox(height: 30),

              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => _navigateToLogin(context),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildSocialIcon(String path) {
  //   return GestureDetector(
  //     onTap: () {
  //       // handle social login
  //     },
  //     child: Container(
  //       width: 48,
  //       height: 48,
  //       decoration: BoxDecoration(
  //         color: AppColors.background,
  //         shape: BoxShape.circle,
  //         border: Border.all(color: AppColors.primary, width: 1.0),
  //       ),
  //       child: CircleAvatar(
  //         backgroundColor: Colors.transparent,
  //         child: Image.asset(path, width: 24, height: 24),
  //       ),
  //     ),
  //   );
  // }
}
