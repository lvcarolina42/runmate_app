import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:runmate_app/domain/user/model/user_for_register.dart';
import 'package:runmate_app/domain/user/use_cases/register_use_case.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';

part 'register_controller.g.dart';

class RegisterController = RegisterControllerStore with _$RegisterController;

abstract class RegisterControllerStore extends DisposableInterface with Store {
  final RegisterUseCase registerUseCase;

  RegisterControllerStore({
    required this.registerUseCase,
  });

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  DateTime? birthDate;

  bool showPassword = false;
  bool showConfirmPassword = false;

  @observable
  bool _isLoading = false;

  @computed
  bool get isLoading => _isLoading;

  @action
  void toggleShowPassword() {
    showPassword = !showPassword;
  }

  @action
  void toggleShowConfirmPassword() {
    showConfirmPassword = !showConfirmPassword;
  }

  @action
  Future<void> onTapRegister() async {
    _isLoading = true;

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          elevation: 16,
          backgroundColor: Colors.red,
          margin: const EdgeInsets.all(16),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: const Text("As senhas não conferem"),
        ),
      );
      _isLoading = false;
      return;
    }

    final result = await registerUseCase(
      userForRegister: UserForRegister(
        birthDate: birthDate!,
        password: passwordController.text,
        email: emailController.text.trim(),
        username: usernameController.text.trim(),
        fullName: fullNameController.text.trim(),
        confirmPassword: confirmPasswordController.text,
      ),
    );
    
    result.processResult(
      onSuccess: (data) async {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.green,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Cadastro realizado com sucesso!"),
          ),
        );
        Get.offAllNamed(Paths.loginPage);
      },
      onFailure: (error) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.red,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Não foi possivel realizar o cadastro, verifique suas credenciais e tente novamente"),
          ),
        );
      },
    );

    _isLoading = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    fullNameController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
