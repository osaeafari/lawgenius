import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawgenius/core/constants/app_colors.dart';
import 'package:lawgenius/core/constants/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final String dummyEmail = 'user';
  final String dummyPassword = '123';

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      if (_emailController.text == dummyEmail &&
          _passwordController.text == dummyPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  void _navigateToSignUp(BuildContext context) {
    context.go('/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Sign In",
                  style: AppTextStyles.formHeader,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Hi! Welcome Back, you've been missed",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 60),

                Text('Email'),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'example@email.com',
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
                  style: TextStyle(color: Colors.black), // optional text color,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                Text('Password'),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '***********',
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Forgot Password?
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push('/verify-code');
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Sign Up Button
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 16, color: AppColors.background),
                  ),
                ),
                const SizedBox(height: 40),

                // // Divider with text
                // Row(
                //   children: const [
                //     Expanded(child: Divider()),
                //     Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 8),
                //       child: Text("Or sign in with"),
                //     ),
                //     Expanded(child: Divider()),
                //   ],
                // ),
                // const SizedBox(height: 40),

                // Social Icons
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
                const SizedBox(height: 30),

                // Don't have an account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () => _navigateToSignUp(context),
                      child: const Text(
                        "Sign Up",
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
