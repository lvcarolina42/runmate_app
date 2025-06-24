import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';

part 'menu_controller.g.dart';

class MenuPageController = MenuPageControllerStore with _$MenuPageController;

abstract class MenuPageControllerStore extends DisposableInterface with Store {
  @observable
  int _currentIndex = 0;

  @computed
  int get currentIndex => _currentIndex;

  final PageController controllerPage = PageController(initialPage: 0);

  @action
  void onChangePage(int index) {
    _currentIndex = index;
    if (index == 2) {
      Get.toNamed(Paths.runningMonitor);
      return;
    }
    controllerPage.animateToPage(index, curve: Curves.linear, duration: const Duration(milliseconds: 300));
  }

  void logout() {
    SessionManager().clearUser();
    Get.offAllNamed(Paths.loginPage);
  }
}
