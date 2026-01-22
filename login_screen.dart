// made by Hamza Mahdi

// my_expense_tracker/lib/ui/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';


import '../../logic/providers/profile_provider.dart';
import '../../logic/providers/expense_provider.dart';

import 'home_screen.dart';
import '../helpers/common_ui_helpers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // ================= Login Logic =================

Future<void> _login() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  final prefs = await SharedPreferences.getInstance();
  final savedPassword = prefs.getString('savedPassword');

  final previousEmail = prefs.getString('lastAccountEmail');
  final newEmail = _emailController.text.trim();

  // يوجد حساب سابق مختلف
  if (previousEmail != null && previousEmail != newEmail) {
    setState(() => _isLoading = false);

    if (!mounted) return;

    _confirmReplaceAccount(context, newEmail);
    return;
  }

  // التحقق من كلمة المرور إذا كان هناك حساب سابق
if (savedPassword != null &&
    _passwordController.text != savedPassword) {
  setState(() => _isLoading = false);

  if (!mounted) return;
  _confirmReplaceAccount(context, newEmail);
  return;
}


  // نفس المستخدم أو أول تسجيل دخول
  await _completeLogin();
}

// تأكيد استبدال الحساب
Future<void> _completeLogin() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool('isLoggedIn', true);
  await prefs.setString('userEmail', _emailController.text.trim());

  // 👇 هذا هو المفتاح المهم
  await prefs.setString(
    'lastAccountEmail',
    _emailController.text.trim(),
  );

  await prefs.setString('passwordHint', _hintController.text.trim());

  await prefs.setString(
    'savedPassword',
    _passwordController.text,
  );


  await Future.delayed(const Duration(seconds: 1));

  if (!mounted) return;

  setState(() => _isLoading = false);
  
  context.read<ProfileProvider>().showProfileImage();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HomeScreen()),
  );
}


// حوار تأكيد استبدال الحساب
void _confirmReplaceAccount(BuildContext context, String newEmail) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Replace Account'),
        content: const Text(
          'The email or password is incorrect.\n'
          'If you want to continue with a new account, the previous account data must be deleted.\n'
          'Do you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // إلغاء
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // حذف بيانات الحساب السابق
              
              await context.read<ExpenseProvider>().deleteAccount();
              await context.read<ProfileProvider>().clearProfileImage();

              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete & Continue'),
          ),
        ],
      );
    },
  );
}

  // ================= Dialogs =================
// Show Password Hint Dialog
  void _showPasswordHint() async {
    final prefs = await SharedPreferences.getInstance();
    final hint = prefs.getString('passwordHint');
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Password Hint'),
        content: Text(
          hint != null && hint.isNotEmpty
              ? hint
              : 'No password hint was saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );//made by Hamza Mahdi
  }

// Show Image Picker Dialog
  void _showImagePicker(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Select Image'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileProvider>()
                  .pickImage(ImageSource.camera);
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileProvider>()
                  .pickImage(ImageSource.gallery);
            },
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}


  // ================= UI =================
//  UI elements for the login screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Consumer<ProfileProvider>(
  builder: (context, provider, _) {
    return GestureDetector(
      onTap: () {
        _showImagePicker(context);
      },
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.blueAccent.withOpacity(0.2),
        backgroundImage: provider.profileImage != null && provider.isVisible
            ? FileImage(provider.profileImage!)
            : null,
        child: provider.profileImage == null
            ? const Icon(Icons.camera_alt, size: 30)
            : null,
      ),
    );
  },
),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    suffixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _hintController,
                  decoration: const InputDecoration(
                    labelText: 'Password Hint (optional)',
                  ),
                  onChanged: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('passwordHint', value);
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        child: const Text('Login'),
                      ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _showPasswordHint,
                  child: const Text('Forgot Password?'),
                ),
                TextButton(
                  onPressed: () => CommonUIHelpers.showPrivacyPolicy(context),
                  child: const Text('Privacy Policy'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _hintController.dispose();
    super.dispose();
  }
}
