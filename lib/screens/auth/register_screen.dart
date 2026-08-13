// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/app_state.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onSwitchToLogin;

  const RegisterScreen({super.key, required this.onSwitchToLogin});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  String _role = 'seeker'; // 'seeker' or 'provider'

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      context.read<AppState>().register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
            _role,
          );
      // SplashScreen rebuilds on the resulting auth state change and
      // swaps to the right dashboard — no manual navigation needed here.
    } catch (e) {
      setState(() => _errorMessage = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppConfig.textDark),
          onPressed: widget.onSwitchToLogin,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create your account',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppConfig.textDark),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Find your next opportunity with SkillLink.',
                  style: TextStyle(fontSize: 14, color: AppConfig.textMuted),
                ),
                const SizedBox(height: 28),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Your full name',
                  labelText: 'Name',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) => Validators.required(v, fieldName: 'Name'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'you@example.com',
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'At least 6 characters',
                  labelText: 'Password',
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: Validators.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: AppConfig.textFaint,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmController,
                  hintText: 'Re-enter your password',
                  labelText: 'Confirm Password',
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) =>
                      Validators.confirmPassword(v, _passwordController.text),
                ),
                const SizedBox(height: 16),
                const Text(
                  'I am a...',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppConfig.textMid),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _RoleOption(
                        label: 'Job Seeker',
                        icon: Icons.work_outline_rounded,
                        isSelected: _role == 'seeker',
                        onTap: () => setState(() => _role = 'seeker'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _RoleOption(
                        label: 'Job Provider',
                        icon: Icons.business_center_outlined,
                        isSelected: _role == 'provider',
                        onTap: () => setState(() => _role = 'provider'),
                      ),
                    ),
                  ],
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                          color: Color(0xFFDC2626), fontSize: 12.5),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                CustomButton(
                  label: 'Create Account',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: widget.onSwitchToLogin,
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style:
                            TextStyle(color: AppConfig.textMuted, fontSize: 13),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                                color: AppConfig.primaryBlue,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConfig.primaryBlue.withOpacity(0.08)
              : AppConfig.chipBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppConfig.primaryBlue : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppConfig.primaryBlue : AppConfig.textMuted,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppConfig.primaryBlue : AppConfig.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
