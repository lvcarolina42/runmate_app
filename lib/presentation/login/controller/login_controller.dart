import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:runmate_app/domain/user/use_cases/login_use_case.dart';
import 'package:runmate_app/domain/user/use_cases/update_token_use_case.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';

part 'login_controller.g.dart';

class LoginController = LoginControllerStore with _$LoginController;

abstract class LoginControllerStore extends DisposableInterface with Store {
  final LoginUseCase loginUseCase;
  final UpdateTokenUseCase updateTokenUseCase;

  LoginControllerStore({
    required this.loginUseCase,
    required this.updateTokenUseCase,
  });

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @observable
  bool _showPassword = false;

  @computed
  bool get showPassword => _showPassword;

  @observable
  bool _isLoading = false;

  @computed
  bool get isLoading => _isLoading;

  @action
  void toggleShowPassword() {
    _showPassword = !_showPassword;
  }

  @override
  void onInit() {
    super.onInit();
    onInitialize();
  }

  Future<void> onInitialize() async {
    final user = SessionManager().currentUser;
    if (user != null) {
      Get.offAllNamed(Paths.menuPage);
      if (GetPlatform.isAndroid && !GetPlatform.isWeb) await updateTokenUseCase(userId: user.id);
    }
  }

  @action
  Future<void> onTapLogin() async {
    _isLoading = true;
    final result = await loginUseCase(
      email: emailController.text,
      password: passwordController.text,
    );
    
    result.processResult(
      onSuccess: (data) async {
        await SessionManager().saveUser(data);
        if (GetPlatform.isAndroid && !GetPlatform.isWeb) await updateTokenUseCase(userId: data.id);
        Get.offAllNamed(Paths.menuPage);
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
            content: const Text("Não foi possivel realizar o login, verifique suas credenciais e tente novamente"),
          ),
        );
      },
    );

    _isLoading = false;
  }

}
