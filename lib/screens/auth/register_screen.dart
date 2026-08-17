import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/app_state.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'auth_layout.dart';

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
  String _role = 'seeker';

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
    setState(() => _isLoading = true);
    context.read<AppState>().register(_nameController.text.trim(),
        _emailController.text.trim(), _passwordController.text, _role);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) => AuthLayout(
        eyebrow: 'Join SkillLink',
        title: 'Create your account',
        subtitle:
            'Tell us a little about yourself to personalize your experience.',
        leading: AuthBackButton(onPressed: widget.onSwitchToLogin),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('How will you use SkillLink?',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppConfig.textMid)),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                  child: _RoleOption(
                      label: 'Find work',
                      subtitle: 'Job seeker',
                      icon: Icons.search_rounded,
                      isSelected: _role == 'seeker',
                      onTap: () => setState(() => _role = 'seeker'))),
              const SizedBox(width: 12),
              Expanded(
                  child: _RoleOption(
                      label: 'Hire talent',
                      subtitle: 'Job provider',
                      icon: Icons.business_center_outlined,
                      isSelected: _role == 'provider',
                      onTap: () => setState(() => _role = 'provider'))),
            ]),
            const SizedBox(height: 24),
            CustomTextField(
                controller: _nameController,
                hintText: 'Your full name',
                labelText: 'Full name',
                prefixIcon: Icons.person_outline_rounded,
                validator: (value) =>
                    Validators.required(value, fieldName: 'Name')),
            const SizedBox(height: 18),
            CustomTextField(
                controller: _emailController,
                hintText: 'you@example.com',
                labelText: 'Email address',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline_rounded,
                validator: Validators.email),
            const SizedBox(height: 18),
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
                        color: AppConfig.textFaint),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword))),
            const SizedBox(height: 18),
            CustomTextField(
                controller: _confirmController,
                hintText: 'Enter it again',
                labelText: 'Confirm password',
                obscureText: _obscurePassword,
                prefixIcon: Icons.verified_user_outlined,
                validator: (value) => Validators.confirmPassword(
                    value, _passwordController.text)),
            const SizedBox(height: 26),
            CustomButton(
                label: 'Create Account',
                onPressed: _handleRegister,
                isLoading: _isLoading,
                icon: Icons.arrow_forward_rounded),
            const SizedBox(height: 12),
            AuthSwitchPrompt(
                prompt: 'Already have an account?',
                action: 'Sign in',
                onTap: widget.onSwitchToLogin),
          ]),
        ),
      );
}

class _RoleOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  const _RoleOption(
      {required this.label,
      required this.subtitle,
      required this.icon,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: isSelected ? AppConfig.chipBg : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: isSelected
                        ? AppConfig.primaryBlue
                        : AppConfig.cardBorder,
                    width: isSelected ? 1.5 : 1)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Icon(icon,
                    color: isSelected
                        ? AppConfig.primaryBlue
                        : AppConfig.textMuted,
                    size: 22),
                Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color:
                        isSelected ? AppConfig.primaryBlue : AppConfig.border,
                    size: 18)
              ]),
              const SizedBox(height: 14),
              Text(label,
                  style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: AppConfig.textDark)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 11.5, color: AppConfig.textMuted)),
            ]),
          ),
        ),
      );
}
