// lib/screens/personal_info_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../models/user_model.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  UserModel _user = UserModel(
    name: 'Arman',
    email: 'arman@example.com',
  );

  File? _selectedImage;
  PlatformFile? _selectedResume;
  bool _isPickingFile = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = _user.name;
    _emailController.text = _user.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null && mounted) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _pickResume() async {
    if (_isPickingFile) return; // prevent double-tap

    setState(() => _isPickingFile = true);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
        withData: false,       // don't load bytes into memory
        withReadStream: false,
      );

      if (result != null && result.files.isNotEmpty && mounted) {
        final file = result.files.first;
        if (file.path != null) {
          setState(() {
            _selectedResume = file;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick file: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPickingFile = false);
    }
  }

  void _removeResume() {
    setState(() {
      _selectedResume = null;
    });
  }

  void _savePersonalInfo() {
    if (_formKey.currentState!.validate()) {
      // Update user model with new name
      _user = UserModel(
        name: _nameController.text.trim(),
        email: _user.email,
        photoUrl: _selectedImage?.path ?? _user.photoUrl,
        resumeUrl: _selectedResume?.path ?? _user.resumeUrl,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Personal information updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _savePersonalInfo,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Profile Photo Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : null,
                          child: _selectedImage == null
                              ? Icon(Icons.person, size: 60, color: Colors.grey[400])
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 18,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                              onPressed: _pickImage,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap camera icon to upload photo',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email field (read-only)
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: false,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Resume section
              const Text(
                'Resume',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.picture_as_pdf,
                    color: _selectedResume != null ? Colors.red : Colors.grey,
                  ),
                  title: Text(
                    _selectedResume?.name ?? 'No resume uploaded',
                    style: TextStyle(
                      color: _selectedResume != null ? Colors.black : Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: _selectedResume != null
                      ? Text(
                          '${((_selectedResume!.size) / 1024).toStringAsFixed(1)} KB',
                          style: const TextStyle(fontSize: 11),
                        )
                      : null,
                  trailing: _selectedResume != null
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          tooltip: 'Remove resume',
                          onPressed: _removeResume,
                        )
                      : IconButton(
                          icon: _isPickingFile
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.upload_file),
                          onPressed: _isPickingFile ? null : _pickResume,
                        ),
                  onTap: _isPickingFile ? null : _pickResume,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'PDF files only (Optional)',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _savePersonalInfo,
                  child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}