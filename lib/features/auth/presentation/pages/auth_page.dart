import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sura_app/core/presentation/main_layout.dart';
import 'package:sura_app/features/auth/presentation/riverpod/auth_controller.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  String _selectedRole = 'student';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit(bool isLogin) {
    if (!_formKey.currentState!.validate()) return;
    if (isLogin) {
      ref.read(authControllerProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    } else {
      ref.read(authControllerProvider.notifier).signUp(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            role: _selectedRole,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authControllerProvider, (previous, state) {
      if (state is AuthSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
        );
      } else if (state is AuthFailed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error), backgroundColor: Colors.red),
        );
      }
    });

    final state = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);
    final isLogin = controller.formType == AuthFormType.login;
    final isLoading = state is AuthLoading;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white54 : Colors.black54;
    final fillColor = isDark ? theme.colorScheme.surface : Colors.white;
    final borderColor = isDark ? Colors.white30 : Colors.black26;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 220,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/login_image.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        isLogin ? 'Tekrar hoş geldin' : 'Yeni hesap oluştur',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Ezber ve tefekkür yolculuğu buradan başlar',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: textColor),
                      ),
                      const SizedBox(height: 24),
                      if (!isLogin) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _RoleButton(
                                label: 'Öğrenci',
                                icon: Icons.school,
                                isSelected: _selectedRole == 'student',
                                onTap: () => setState(
                                  () => _selectedRole = 'student',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _RoleButton(
                                label: 'Öğretmen',
                                icon: Icons.person,
                                isSelected: _selectedRole == 'teacher',
                                onTap: () => setState(
                                  () => _selectedRole = 'teacher',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('Ad Soyad', textColor),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: _nameController,
                          hint: 'Adınızı girin',
                          icon: Icons.person_outline,
                          fillColor: fillColor,
                          hintColor: hintColor,
                          borderColor: borderColor,
                          textColor: textColor,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Ad gerekli' : null,
                        ),
                        const SizedBox(height: 16),
                      ],
                      _buildLabel('E-posta', textColor),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: _emailController,
                        hint: 'name@example.com',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        fillColor: fillColor,
                        hintColor: hintColor,
                        borderColor: borderColor,
                        textColor: textColor,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'E-posta gerekli';
                          }
                          if (!v.contains('@')) {
                            return 'Geçersiz e-posta';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLabel('Şifre', textColor),
                          if (isLogin)
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Şifremi unuttum?',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: _passwordController,
                        hint: '••••••••',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscure: _obscurePassword,
                        fillColor: fillColor,
                        hintColor: hintColor,
                        borderColor: borderColor,
                        textColor: textColor,
                        onToggleObscure: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Şifre gerekli';
                          }
                          if (v.length < 6) {
                            return 'En az 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : () => _submit(isLogin),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isLogin ? 'Giriş yap' : 'Hesap oluştur',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.login,
                                        size: 20, color: Colors.white),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                                color: theme.colorScheme.primary
                                    .withOpacity(0.5)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'veya',
                              style: TextStyle(color: hintColor),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                                color: theme.colorScheme.primary
                                    .withOpacity(0.5)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: theme.colorScheme.primary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.g_mobiledata,
                            color: Colors.blue,
                            size: 28,
                          ),
                          label: Text(
                            'Google ile devam et',
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLogin
                                ? 'Hesabın yok mu?'
                                : 'Zaten hesabın var mı?',
                            style: TextStyle(color: hintColor),
                          ),
                          TextButton(
                            onPressed: () => controller.toggleFormType(),
                            child: Text(
                              isLogin ? 'Şimdi kaydol' : 'Giriş yap',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color fillColor,
    required Color hintColor,
    required Color borderColor,
    required Color textColor,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscure : false,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.blueGrey,
                ),
                onPressed: onToggleObscure,
              )
            : Icon(icon, color: hintColor),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedBg = isDark
        ? const Color(0xFF953735)
        : theme.colorScheme.primary.withOpacity(0.1);
    final unselectedBg = isDark ? const Color(0xFF1a2535) : Colors.white;
    final selectedBorder =
        isDark ? const Color(0xFF481A19) : theme.colorScheme.primary;
    final unselectedBorder = isDark ? Colors.white30 : Colors.black26;
    final selectedText = isDark ? Colors.white : theme.colorScheme.primary;
    final unselectedText = isDark ? Colors.white70 : Colors.black54;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : unselectedBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isSelected ? selectedBorder : unselectedBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 18, color: isSelected ? selectedText : unselectedText),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedText : unselectedText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
