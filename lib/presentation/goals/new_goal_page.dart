import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/shared/themes/app_fonts.dart';

class NewGoalPage extends StatelessWidget {
  const NewGoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.blue950,
        title: const Text(
          'Definir meta',
          style: TextStyle(
            color: Colors.white,
            fontFamily: AppFonts.poppinsSemiBold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.gray800,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.flag, size: 60, color: AppColors.blue100),
              ),
            ),
            const SizedBox(height: 24),
            const _GoalInputField(
              label: 'Nome',
              hint: 'Ex: Meta de 5km',
            ),
            const SizedBox(height: 16),
            const _GoalInputField(
              label: 'Descrição',
              hint: 'Ex: Quero correr 5km 3x por semana',
              maxLines: 3,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // salvar meta aqui
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Salvar meta',
                  style: TextStyle(
                    color: AppColors.whiteBrand,
                    fontFamily: AppFonts.poppinsSemiBold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalInputField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;

  const _GoalInputField({
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.blue100,
            fontFamily: AppFonts.poppinsRegular,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.blue200,
              fontFamily: AppFonts.poppinsRegular,
            ),
            filled: true,
            fillColor: AppColors.gray800,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
