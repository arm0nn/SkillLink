// lib/screens/provider/post_job_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/app_state.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handlePost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      context.read<AppState>().postJob(
          title: _titleController.text.trim(),
          company: _companyController.text.trim(),
          location: _locationController.text.trim());
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job posted!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post job: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppConfig.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Post a Job',
            style: TextStyle(
                color: AppConfig.textDark,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _titleController,
                hintText: 'e.g. Senior Flutter Developer',
                labelText: 'Job Title',
                validator: (v) =>
                    Validators.required(v, fieldName: 'Job title'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _companyController,
                hintText: 'e.g. TechNova Sdn Bhd',
                labelText: 'Company',
                validator: (v) => Validators.required(v, fieldName: 'Company'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _locationController,
                hintText: 'e.g. Kuala Lumpur',
                labelText: 'Location',
                validator: (v) => Validators.required(v, fieldName: 'Location'),
              ),
              const SizedBox(height: 28),
              CustomButton(
                label: 'Post Job',
                onPressed: _handlePost,
                isLoading: _isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
