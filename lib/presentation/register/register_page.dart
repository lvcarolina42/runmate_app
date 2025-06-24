import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:runmate_app/presentation/register/controller/register_controller.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/shared/themes/app_text_themes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController controller = Get.find<RegisterController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        backgroundColor: AppColors.blue950,
        appBar: AppBar(
          backgroundColor: AppColors.blue950,
          elevation: 0,
          title: Text(
            'Cadastro',
            style: subtitleLgMedium.customColor(Colors.white),
          ),
          leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: GetPlatform.isWeb ? 480 : 24, vertical: 48),
            child: Center(
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Crie sua conta para entrar na comunidade Runmate',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 32),
                      _buildTextField(
                        controller: controller.fullNameController,
                        label: 'Nome completo',
                        icon: Icons.person_outline,
                        validator: (v) => _validateRequired(v, 'Nome completo'),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: controller.usernameController,
                        label: 'Nome de usuário',
                        icon: Icons.account_circle_outlined,
                        validator: (v) => _validateUsername(v),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: controller.emailController,
                        label: 'E-mail',
                        icon: Icons.email_outlined,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 20),
                      _buildDatePicker(context),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: controller.passwordController,
                        label: 'Senha',
                        icon: Icons.lock_outline,
                        obscureText: controller.showPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.showPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: controller.toggleShowPassword,
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: controller.confirmPasswordController,
                        label: 'Confirmar senha',
                        icon: Icons.lock_outline,
                        obscureText: controller.showConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: controller.toggleShowConfirmPassword,
                        ),
                        validator: _validateConfirmPassword,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.onTapRegister();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue900,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: controller.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white),
                              )
                            : Text(
                                'Criar conta',
                                style: subtitleLgMedium.customColor(Colors.white),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
        _formKey.currentState!.validate();
      },
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    final formatted = controller.birthDate == null
        ? ''
        : DateFormat('dd/MM/yyyy').format(controller.birthDate!);
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(1900),
          lastDate: now,
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.whiteBrand,
                  onPrimary: AppColors.blue950,
                  surface: AppColors.blue950,
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          _formKey.currentState!.validate();
          setState(() {
            controller.birthDate = picked;
          });
          _formKey.currentState!.validate();
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(text: formatted),
          style: const TextStyle(color: Colors.white),
          validator: (_) {
            if (controller.birthDate == null) return 'Data de nascimento é obrigatória';
            return null;
          },
          decoration: InputDecoration(
            labelText: 'Data de nascimento',
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            prefixIcon: const Icon(Icons.calendar_today, color: Colors.white70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  String? _validateUsername(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Nome de usuário é obrigatório';
    }
    if (text.length < 3) {
      return 'O nome de usuário deve ter no mínimo 3 caracteres';
    }
    if (text.length > 100) {
      return 'O nome de usuário deve ter no máximo 100 caracteres';
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'E-mail é obrigatório';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) return 'E-mail inválido';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != controller.passwordController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }
}
