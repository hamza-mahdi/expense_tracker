// made by Hamza Mahdi

// my_expense_tracker/lib/ui/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/providers/profile_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'login_screen.dart';
import '../helpers/common_ui_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../logic/providers/expense_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== Profile Image =====
          Center(
            child: Consumer<ProfileProvider>(
              builder: (context, provider, _) {
                return GestureDetector(
                  onTap: () {
                    _showImagePicker(context);
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        Colors.blueAccent.withOpacity(0.2),
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
          ),

          const SizedBox(height: 24),

          // ===== Privacy Policy =====
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              CommonUIHelpers.showPrivacyPolicy(context);
            },
          ),

          const Divider(),

          // ===== About App =====
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About App'),
            onTap: () {
              _showAboutApp(context);
            },
          ),

          const Divider(),

          // ===== Language (Placeholder) =====
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('English'),
            onTap: () {
              _showComingSoon(context);
            },
          ),

          const Divider(),

          // ===== Dark Mode (Placeholder) =====
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            subtitle: const Text('Coming soon'),
            onTap: () {
              _showComingSoon(context);
            },
          ),
          const Divider(),

ListTile(
  leading: const Icon(Icons.logout),
  title: const Text('Logout'),
  onTap: () {
    _confirmLogout(context);
  },
),

const Divider(),

ListTile(
  leading: const Icon(Icons.delete_forever, color: Colors.red),
  title: const Text(
    'Delete Account',
    style: TextStyle(color: Colors.red),
  ),
  onTap: () {
    _confirmDeleteAccount(context);
  },
),

        ],
      ),
    );
  }

  // ===== Image Picker Dialog =====
  void _showImagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Profile Image'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context
                    .read<ProfileProvider>()
                    .pickImage(ImageSource.camera);
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context
                    .read<ProfileProvider>()
                    .pickImage(ImageSource.gallery);//  made by Hamza Mahdi
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



  // ===== About App Dialog =====
  void _showAboutApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About App'),
          content: const Text(
            'Expense Tracker App\n'
            'Version 1.0\n\n'
            'Developed as a mobile application project.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ===== Coming Soon Dialog =====
  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Coming Soon'),
          content: const Text(
            'This feature will be available in a future update.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  // ===== Confirm Logout Dialog =====
  void _confirmLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
// made by Hamza Mahdi
              final prefs =
                  await SharedPreferences.getInstance();
                  await prefs.remove('isLoggedIn');
                  await prefs.remove('userEmail');

                  context.read<ProfileProvider>().hideProfileImage();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}
  // ===== Confirm Delete Account Dialog =====
void _confirmDeleteAccount(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete all your data. '
          'Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // حذف قاعدة البيانات
              await context.read<ExpenseProvider>().deleteAccount();
              await context.read<ProfileProvider>().clearProfileImage();

              // حذف SharedPreferences
              final prefs =
                  await SharedPreferences.getInstance();
              await prefs.clear();
              
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}


  
}
