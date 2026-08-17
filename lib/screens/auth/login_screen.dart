import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/app_state.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'auth_layout.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onSwitchToRegister;
  const LoginScreen({super.key, required this.onSwitchToRegister});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    context
        .read<AppState>()
        .login(_emailController.text.trim(), _passwordController.text);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) => AuthLayout(
        eyebrow: 'Welcome back',
        title: 'Sign in to your account',
        subtitle:
            'Continue exploring opportunities and managing your progress.',
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                hintText: 'Enter your password',
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
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Password recovery will be added later.'))),
                    child: const Text('Forgot password?',
                        style: TextStyle(
                            fontSize: 12.5, fontWeight: FontWeight.w700)))),
            const SizedBox(height: 8),
            CustomButton(
                label: 'Sign In',
                onPressed: _handleLogin,
                isLoading: _isLoading,
                icon: Icons.arrow_forward_rounded),
            const SizedBox(height: 12),
            AuthSwitchPrompt(
                prompt: "New to SkillLink?",
                action: 'Create account',
                onTap: widget.onSwitchToRegister),
          ]),
        ),
      );
}
