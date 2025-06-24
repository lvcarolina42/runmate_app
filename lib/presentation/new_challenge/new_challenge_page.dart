import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:runmate_app/domain/challenge/model/challenge_model.dart';
import 'package:runmate_app/presentation/new_challenge/controller/new_challenge_controller.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/shared/themes/app_fonts.dart';
import 'package:runmate_app/shared/themes/app_text_themes.dart';

class NewChallengePage extends StatefulWidget {
  const NewChallengePage({super.key});

  @override
  State<NewChallengePage> createState() => _NewChallengePageState();
}

class _NewChallengePageState extends State<NewChallengePage> {
  final NewChallengeController controller = Get.find<NewChallengeController>();
  final _formKey = GlobalKey<FormState>();

  String selectedType = 'period';

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.blue100,
        fontFamily: AppFonts.poppinsRegular,
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String? Function(String?)? validator,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      readOnly: readOnly,
      maxLines: maxLines,
      onTap: onTap,
      style: bodyLgMedium.customColor(AppColors.whiteBrand),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[800],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedType = 'period'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selectedType == 'period'
                        ? Colors.orange
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: const Center(
                child: Text(
                  'Por período',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: AppFonts.poppinsMedium,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedType = 'distance'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selectedType == 'distance'
                        ? Colors.orange
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: const Center(
                child: Text(
                  'Por distância',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: AppFonts.poppinsMedium,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      controller.createChallenge(
        title: controller.nameController.text.trim(),
        description: controller.descriptionController.text.trim(),
        startDate: controller.startDateController.text.trim(),
        endDate: controller.endDateController.text.trim(),
        distance: selectedType == 'distance'
            ? int.tryParse(controller.distanceController.text.trim())
            : null,
        type: selectedType == 'period'
            ? ChallengeType.date
            : ChallengeType.distance,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue950,
      appBar: AppBar(
        backgroundColor: AppColors.blue950,
        title: const Text(
          'Criar desafio',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildLabel('Título'),
              const SizedBox(height: 8),
              _buildInput(
                controller: controller.nameController,
                validator: (value) {
                  if (selectedType == 'period' && (value == null || value.isEmpty)) {
                    return 'O título é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildLabel('Descrição'),
              const SizedBox(height: 8),
              _buildInput(
                controller: controller.descriptionController,
                maxLines: 3,
                validator: (value) {
                  if (selectedType == 'period' && (value == null || value.isEmpty)) {
                    return 'A descrição é obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTabSelector(),
              if (selectedType == 'distance') ...[
                const SizedBox(height: 16),
                _buildLabel('Distância (metros)'),
                const SizedBox(height: 8),
                _buildInput(
                  controller: controller.distanceController,
                  validator: (value) {
                    if (selectedType == 'distance') {
                      if (value == null || value.isEmpty) {
                        return 'A distância é obrigatória';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Informe um número válido';
                      }
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Data inicial'),
                        const SizedBox(height: 8),
                        _buildInput(
                          controller: controller.startDateController,
                          readOnly: true,
                          onTap: () =>
                              _selectDate(context, controller.startDateController),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe a data inicial';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Data final'),
                        const SizedBox(height: 8),
                        _buildInput(
                          controller: controller.endDateController,
                          readOnly: true,
                          onTap: () =>
                              _selectDate(context, controller.endDateController),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe a data final';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Salvar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: AppFonts.poppinsMedium,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
