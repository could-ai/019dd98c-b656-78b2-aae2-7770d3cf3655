import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../providers/app_provider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    _nameController.text = provider.profileName;
  }

  void _pickProfilePicture() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      Provider.of<AppProvider>(context, listen: false)
          .updateProfilePicture(result.files.single.path!);
    }
  }

  void _changePassword() {
    // Simulated change password flow
    if (_oldPasswordController.text.isNotEmpty && _newPasswordController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully!')),
      );
      _oldPasswordController.clear();
      _newPasswordController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Center(
              child: GestureDetector(
                onTap: _pickProfilePicture,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueAccent,
                  backgroundImage: provider.profilePicturePath.isNotEmpty
                      ? FileImage(File(provider.profilePicturePath))
                      : null,
                  child: provider.profilePicturePath.isEmpty
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Profile Name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (val) {
                provider.updateProfileName(val);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name updated!')));
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Change Password'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _oldPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Old Password'),
                        ),
                        TextField(
                          controller: _newPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'New Password'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      TextButton(onPressed: _changePassword, child: const Text('Save')),
                    ],
                  ),
                );
              },
              child: const Text('Change Password'),
            ),
            const Divider(height: 40),
            // Preferences Section
            Text('Preferences', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: provider.isDarkMode,
              onChanged: (val) => provider.toggleTheme(),
            ),
            SwitchListTile(
              title: const Text('Clicking Sound'),
              value: provider.soundEnabled,
              onChanged: (val) => provider.toggleSound(),
            ),
            const SizedBox(height: 10),
            const Text('Brightness Level'),
            Slider(
              value: provider.brightness,
              min: 0.1,
              max: 1.0,
              onChanged: (val) => provider.setBrightness(val),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
