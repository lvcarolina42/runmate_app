import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:runmate_app/presentation/running_monitor/controller/running_monitor_controller.dart';
import 'package:runmate_app/presentation/running_monitor/widgets/maps_widget.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/shared/themes/app_text_themes.dart';

class RunningMonitorPage extends StatefulWidget {
  const RunningMonitorPage({super.key});

  @override
  State<RunningMonitorPage> createState() => _RunningMonitorPageState();
}

class _RunningMonitorPageState extends State<RunningMonitorPage> {
  final _controller = Get.find<RunningMonitorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue950,
      appBar: AppBar(
        leadingWidth: 100,
        backgroundColor: AppColors.blue950,
        centerTitle: true,
        title: Text(
          "Monitoramento",
          style: titleSmMedium.customColor(AppColors.whiteBrand),
        ),
        leading: TextButton(
          onPressed: () => Get.back(),
          child: Text("Fechar", style: subtitleSmRegular.customColor(AppColors.whiteBrand)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AudioSettingsDialog(
                  formKey: _controller.formKey,
                  saveSettings: _controller.saveSettings,
                  timeController: _controller.timeController,
                  distanceController: _controller.distanceController,
                ),
              );
            },
            color: AppColors.whiteBrand,
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          return Stack(
            children: [
              Positioned.fill(
                child: MapsWidget(
                  cameraOptions: _controller.camera,
                  onMapCreatedCallback: _controller.attachMap,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  bottom: false,
                  child: Container(
                    margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: const BoxDecoration(
                      color: AppColors.blue900,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Pronto para começar?",
                          style: titleLgSemiBold.customColor(AppColors.whiteBrand),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => Get.toNamed(Paths.running),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text("Iniciar Corrida", style: subtitleLgMedium.customColor(AppColors.whiteBrand)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange500,
                            foregroundColor: AppColors.blue950,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AudioSettingsDialog extends StatefulWidget {
  final TextEditingController distanceController;
  final TextEditingController timeController;
  final GlobalKey<FormState> formKey;
  final Function() saveSettings;

  const AudioSettingsDialog({super.key, required this.distanceController, required this.timeController, required this.formKey, required this.saveSettings});

  @override
  State<AudioSettingsDialog> createState() => _AudioSettingsDialogState();
}

class _AudioSettingsDialogState extends State<AudioSettingsDialog> {
  bool audioByDistance = false;
  bool audioByTime = false;

  @override
  void initState() {
    super.initState();
    audioByDistance = widget.distanceController.text.isNotEmpty && widget.distanceController.text != "0";
    audioByTime = widget.timeController.text.isNotEmpty && widget.timeController.text != "0";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.blue900,
      title: Center(child: Text("Configurações de Áudio", style: subtitleLgMedium.customColor(AppColors.whiteBrand))),
      content: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                activeColor: AppColors.blue500,
                activeTrackColor: AppColors.whiteBrand,
                contentPadding: const EdgeInsets.all(0),
                title: Text("Habilitar assistente de áudio por distância", style: subtitleSmRegular.customColor(AppColors.whiteBrand)),
                value: audioByDistance,
                onChanged: (value) {
                  setState(() => audioByDistance = value);
                },
              ),
              if (audioByDistance)
                Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildTextField(
                      suffix: "m",
                      controller: widget.distanceController,
                      label: "Distância em metros",
                      icon: Icons.location_on_outlined,
                      validator: (value) {
                        if (int.tryParse(value ?? '') == null) {
                          return "Distância inválida";
                        }
                        return null;
                      }
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              SwitchListTile(
                activeColor: AppColors.blue500,
                activeTrackColor: AppColors.whiteBrand,
                contentPadding: const EdgeInsets.all(0),
                title: Text("Habilitar assistente de áudio por tempo", style: subtitleSmRegular.customColor(AppColors.whiteBrand)),
                value: audioByTime,
                onChanged: (value) {
                  setState(() => audioByTime = value);
                },
              ),
              if (audioByTime)
                Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildTextField(
                      suffix: "min",
                      controller: widget.timeController,
                      label: "Tempo em minutos",
                      icon: Icons.timer_outlined,
                      validator: (value) {
                        if (int.tryParse(value ?? '') == null) {
                          return "Tempo inválido";
                        }
                        return null;
                      },
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("Cancelar", style: subtitleSmMedium.customColor(AppColors.whiteBrand)),
        ),
        ElevatedButton(
          onPressed: () {
            if (!audioByDistance) {
              widget.distanceController.clear();
            }

            if (!audioByTime) {
              widget.timeController.clear();
            }

            if (!widget.formKey.currentState!.validate()) {
              return;
            }
            
            widget.saveSettings();
            Get.back();
          },
          child: Text("Salvar", style: subtitleSmMedium.customColor(AppColors.blue900)),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
        // _formKey.currentState!.validate();
      },
      style: subtitleLgMedium.customColor(AppColors.whiteBrand),
      validator: validator,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: subtitleSmMedium.customColor(AppColors.gray300),
        suffix: Text(suffix, style: subtitleLgMedium.customColor(AppColors.whiteBrand)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.whiteBrand),
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.whiteBrand),
          borderRadius: BorderRadius.circular(16),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.whiteBrand),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

