// lib/screens/shared/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/app_state.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';

// screen that allows users to edit profile
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // form key used to validate all form fields before saving.
  final _formKey = GlobalKey<FormState>();

  // Controller for holding the current text in the input field
  late final TextEditingController _nameController;

  // to disable thet save button for a while when saving name, and showing loading animation
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // read the current user profile from the auth provider (without listening to rebuilds)
    // pre-fill the text box with the current name, or if there's no name, use empty string
    final user = context.read<AppState>().userProfile;
    _nameController = TextEditingController(text: user?.name ?? '');
  }

  @override
  void dispose() {
    // clean up controller to prevent memory leaks
    _nameController.dispose();
    super.dispose();
  }

  // Handles the save action and updates the local prototype state.
  // shows feedback, and navigates back on success.
  Future<void> _handleSave() async {
    // form validation, if invalid, it stops here
    if (!_formKey.currentState!.validate()) return;

    // get the current user ID from auth provider, if there's no user, exit early
    // showing loading state (disable button / show spinner).
    setState(() => _isSaving = true);

    try {
      context.read<AppState>().updateName(_nameController.text.trim());

      // if the widget is still mounted, navigate back and show a success message.
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
      }
    } catch (e) {
      // if there's an error, hide the loading state and show an error message.
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar with back arrow and title "Edit Profile"
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppConfig.textDark),
          onPressed: () => Navigator.pop(context), // Dismiss the screen.
        ),
        title: const Text('Edit Profile',
            style: TextStyle(
                color: AppConfig.textDark,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey, // associates the form with the validation key.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TexFormField with "Name" title
              // a single input field for the user's full name.
              // the validator ensures the field is not empty.
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Your full name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                  ),
                  filled: true, // White background for better readability.
                  fillColor: Colors.white,
                ),
                validator: (v) => Validators.required(v, fieldName: 'Name'),
              ),
              const SizedBox(height: 28),

              // the SAVE button
              // CustomButton shows a loading spinner when _isSaving is true.
              // Pressing it triggers the _handleSave logic.
              CustomButton(
                label: 'Save Changes',
                onPressed: _handleSave,
                isLoading: _isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
