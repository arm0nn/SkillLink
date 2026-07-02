// lib/screens/provider/post_job_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/app_config.dart';
import '../../models/job_model.dart';
import '../../services/database_service.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

/// NOTE for team: JobModel has title/company/location/status/providerId
/// (no salary, type, or tags). This form only collects what the model
/// supports. providerId is set automatically from the signed-in user —
/// not a form field. If you extend JobModel with more fields, add
/// matching inputs here.
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

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to post a job')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final job = JobModel(
      id: '', // Firestore assigns this on add()
      title: _titleController.text.trim(),
      company: _companyController.text.trim(),
      location: _locationController.text.trim(),
      status: 'pending',
      providerId: uid,
    );

    try {
      await DatabaseService().postJob(job);
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
                validator: (v) => Validators.required(v, fieldName: 'Job title'),
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
