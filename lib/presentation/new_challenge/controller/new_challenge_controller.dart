import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:runmate_app/domain/challenge/model/challenge_model.dart';
import 'package:runmate_app/domain/challenge/use_cases/create_challenge_use_case.dart';
import 'package:runmate_app/shared/events/app_listener_events.dart';

part 'new_challenge_controller.g.dart';

class NewChallengeController = NewChallengeControllerStore with _$NewChallengeController;

abstract class NewChallengeControllerStore extends DisposableInterface with Store {
  final CreateChallengeUseCase createChallengeUseCase;

  NewChallengeControllerStore({required this.createChallengeUseCase});

  final User? _user = SessionManager().currentUser;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  Future<void> createChallenge({
    int? distance,
    required String title,
    required String endDate,
    required String startDate,
    required String description,
    required ChallengeType type,
  }) async {

    if (_user == null) return;

    DateFormat format = DateFormat("dd/MM/yyyy");
  
    DateTime parsedStartDate = format.parse(startDate);
    DateTime parsedEndDate = format.parse(endDate);

    final challenge = ChallengeModel(
      id: "",
      type: type,
      ranking: [],
      title: title,
      distance: distance,
      createBy: _user.id,
      endDate: parsedEndDate,
      description: description,
      startDate: parsedStartDate,
    );

    final result = await createChallengeUseCase(challenge: challenge);

    result.processResult(
      onSuccess: (data) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.green,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Desafio criado com sucesso"),
          ),
        );
        AppListenerEvents().add(ChallengeEvent());
        Get.back();
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
            content: const Text("Erro ao criar o desafio"),
          ),
        );
      },
    );
  }
}

