import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRegister = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email is required.')),
      );
      return;
    }
    Navigator.of(context).pop(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            return Row(
              children: [
                if (isWide)
                  Expanded(
                    flex: 55,
                    child: _BrandPanel(),
                  ),
                Expanded(
                  flex: 45,
                  child: _AuthPanel(
                    isRegister: _isRegister,
                    nameController: _nameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    onToggle: (value) => setState(() => _isRegister = value),
                    onSubmit: _submit,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  static const String _imageUrl =
      'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=1400&q=80';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      color: const Color(0xFFEEEEEE),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(_imageUrl, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Text(
              'Curated simplicity for the discerning minimalist.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthPanel extends StatelessWidget {
  const _AuthPanel({
    required this.isRegister,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.onToggle,
    required this.onSubmit,
  });

  final bool isRegister;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueChanged<bool> onToggle;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ESTHETIQUE',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(letterSpacing: 2),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _AuthToggleButton(
                      label: 'Sign In',
                      isActive: !isRegister,
                      onTap: () => onToggle(false),
                    ),
                  ),
                  Expanded(
                    child: _AuthToggleButton(
                      label: 'Create Account',
                      isActive: isRegister,
                      onTap: () => onToggle(true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (isRegister)
                _UnderlineField(
                  label: 'Full Name',
                  controller: nameController,
                  hintText: 'Eleanor Vance',
                  keyboardType: TextInputType.name,
                ),
              if (isRegister) const SizedBox(height: 16),
              _UnderlineField(
                label: 'Email Address',
                controller: emailController,
                hintText: 'hello@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _UnderlineField(
                label: 'Password',
                controller: passwordController,
                hintText: '........',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Text(isRegister ? 'Create Account' : 'Sign In'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or continue with',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: const Color(0xFF4C4546)),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              _SocialButton(
                icon: Icons.g_mobiledata,
                label: 'Google',
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              _SocialButton(
                icon: Icons.apple,
                label: 'Apple',
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              Text(
                'This is a local-only login screen for now. Connect your API later.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: const Color(0xFF4C4546)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthToggleButton extends StatelessWidget {
  const _AuthToggleButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.black : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isActive ? Colors.black : const Color(0xFF4C4546),
              ),
        ),
      ),
    );
  }
}

class _UnderlineField extends StatelessWidget {
  const _UnderlineField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: const Color(0xFF4C4546)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFCFC4C5)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: const BorderSide(color: Color(0xFFCFC4C5)),
        foregroundColor: Colors.black,
      ),
    );
  }
}
