import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 7 - Signup Form',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SignupScreen(),
    );
  }
}

/*
Màn hình đăng ký
 */
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  // form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Focus nodes
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  // State
  bool isCheckingEmail = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool acceptTerms = false;

  // Name Validation
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  // Email Validation
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final email = value.trim();
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Password Validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Độ mạnh mật khẩu
  String get passwordStrength {
    final password = passwordController.text;
    if (password.isEmpty) {
      return '';
    }
    int score = 0;
    if (password.length >= 8) {
      score++;
    }
    if (RegExp(r'[0-9]').hasMatch(password)) {
      score++;
    }
    if (RegExp(r'[A-Z]').hasMatch(password)) {
      score++;
    }
    if (RegExp(r'[a-z]').hasMatch(password)) {
      score++;
    }
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      score++;
    }
    if (score <= 2) {
      return 'Weak';
    }
    if (score <= 4) {
      return 'Medium';
    }
    return 'Strong';
  }

  // Submit
  Future<void> submitForm() async {
    // Thoát bàn phím
    FocusScope.of(context).unfocus();

    // Kiểm tra tất cả các trường thông tin
    final isValid = formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    // Kiểm tra điều kiện
    if (!acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Terms & Conditions')),
      );
      return;
    }

    // Kiểm tra email không đồng bộ
    setState(() {
      isCheckingEmail = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    final email = emailController.text.trim().toLowerCase();

    // Tất cả những email nào bắt đầu với "taken" đều không có sẵn
    final isEmailTaken = email.startsWith('taken');
    if (!mounted) return;
    setState(() {
      isCheckingEmail = false;
    });
    if (isEmailTaken) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This email is already taken'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Phản hồi thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signup successful! Account created.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Loạt bỏ
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
  }

  // Giao diện
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Không nhận bàn phím khi người dùng nhấn ra ngoài ô nhập dữ liệu
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Signup'),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Padding(padding: const EdgeInsets.all(20),

              // Listview ngăn tràn
              child: Form(
                key: formKey,

                // Kiểm tra khi người dùng tương tác với các trường dữ liệu
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  children: [
                    // Header
                    const Icon(Icons.person, size: 70),

                    const SizedBox(height: 10),
                    const Text(
                      'Create your account',
                      textAlign: TextAlign.center,
                      style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      'Fill in the information below to sign up.',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    // Full name
                    TextFormField(
                      controller: nameController,
                      focusNode: nameFocus,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Full Name', hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: validateName,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(emailFocus);
                        },
                    ),

                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: emailController,
                      focusNode: emailFocus,

                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,

                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'example@email.com',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),

                      validator: validateEmail,

                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(passwordFocus);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Mật khẩu
                    TextFormField(
                      controller: passwordController,
                      focusNode: passwordFocus,

                      obscureText: obscurePassword,
                      textInputAction: TextInputAction.next,

                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock),

                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),

                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),

                        border: const OutlineInputBorder(),
                      ),

                      validator: validatePassword,

                      onChanged: (_) {
                        // Đặt lại độ mạnh mật khẩu
                        setState(() {});
                      },

                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(confirmPasswordFocus);
                      },
                    ),

                    // Độ mạnh mật khẩu
                    if (passwordStrength.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password strength: $passwordStrength',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: passwordStrength == 'Strong'
                                  ? Colors.green
                                  : passwordStrength == 'Medium'
                                  ? Colors.orange
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Xác minh mật khẩu
                    TextFormField(
                      controller: confirmPasswordController,
                      focusNode: confirmPasswordFocus,

                      obscureText: obscureConfirmPassword,
                      textInputAction: TextInputAction.done,

                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Re-enter your password',
                        prefixIcon: const Icon(Icons.lock_outline),

                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),

                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword =
                              !obscureConfirmPassword;
                            });
                          },
                        ),

                        border: const OutlineInputBorder(),
                      ),

                      validator: validateConfirmPassword,

                      onFieldSubmitted: (_) {
                        submitForm();
                      },
                    ),

                    const SizedBox(height: 10),

                    // Điều kiện
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,

                      value: acceptTerms,

                      title: const Text(
                        'I agree to the Terms & Conditions',
                      ),

                      controlAffinity:
                      ListTileControlAffinity.leading,

                      onChanged: (value) {
                        setState(() {
                          acceptTerms = value ?? false;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // Nút xác nhận gửi dữ liệu
                    SizedBox(
                      height: 50,

                      child: ElevatedButton(
                        onPressed:
                        isCheckingEmail ? null : submitForm,

                        child: isCheckingEmail
                            ? const SizedBox(
                          width: 24,
                          height: 24,

                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }
}
