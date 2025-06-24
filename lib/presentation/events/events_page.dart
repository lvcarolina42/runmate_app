import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:runmate_app/domain/events/model/event_model.dart';
import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/presentation/events/controller/events_controller.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/shared/themes/app_fonts.dart';
import 'package:flutter/scheduler.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  final EventsController _eventsController = Get.find<EventsController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _eventsController.onInitialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7), // Fundo mais escuro
      builder: (BuildContext dialogContext) {
        // Chamando o novo diálogo "bonito"
        return _BeautifulAddEventDialog(
          createEvent: _eventsController.createEvent,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = GetPlatform.isWeb;
    return Scaffold(
      backgroundColor: AppColors.blue950,
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.orange500,
            indicatorWeight: 3.0,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            labelStyle: const TextStyle(
              fontFamily: AppFonts.poppinsMedium,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'Meus eventos'),
              Tab(text: 'Explorar'),
            ],
          ),
          Expanded(
            child: Observer(builder: (context) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _EventsContent(
                    isMyEvents: true,
                    events: _eventsController.myEvents,
                    joinEvent: _eventsController.joinEvent,
                    leaveEvent: _eventsController.leaveEvent,
                    onInialize: _eventsController.onInitialize,
                  ),
                  _EventsContent(
                    isMyEvents: false,
                    events: _eventsController.allEvents,
                    joinEvent: _eventsController.joinEvent,
                    leaveEvent: _eventsController.leaveEvent,
                    onInialize: _eventsController.onInitialize,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
      floatingActionButton: isWeb ? null : FloatingActionButton(
        onPressed: () => _showAddEventDialog(context),
        backgroundColor: AppColors.orange500,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// =======================================================================
// NOVO WIDGET PARA O DIÁLOGO DE CADASTRO (VERSÃO MAIS BONITA)
// =======================================================================
class _BeautifulAddEventDialog extends StatefulWidget {
  final Future<void> Function({required String title, required DateTime date}) createEvent;

  const _BeautifulAddEventDialog({required this.createEvent});

  @override
  State<_BeautifulAddEventDialog> createState() => _BeautifulAddEventDialogState();
}

class _BeautifulAddEventDialogState extends State<_BeautifulAddEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          _selectedDateTime?.hour ?? 19, // Padrão 19:00
          _selectedDateTime?.minute ?? 0,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now().add(const Duration(hours: 1))),
    );
    if (time != null) {
      setState(() {
        final date = _selectedDateTime ?? DateTime.now();
        _selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione a data e a hora do evento.')),
        );
        return;
      }
      widget.createEvent(title: _titleController.text, date: _selectedDateTime!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.gray800,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.gray700,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.edit_calendar_outlined, color: AppColors.orange500, size: 28),
          const SizedBox(width: 12),
          const Text(
            'Novo Evento',
            style: TextStyle(
              color: Colors.white,
              fontFamily: AppFonts.poppinsSemiBold,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.blue200),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Título do evento',
                labelStyle: const TextStyle(color: AppColors.blue200),
                prefixIcon: const Icon(Icons.title, color: AppColors.blue300, size: 20),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppColors.gray700), borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppColors.orange500), borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'O título é obrigatório.' : null,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildDatePicker()),
                const SizedBox(width: 16),
                Expanded(child: _buildTimePicker()),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text('CRIAR EVENTO', style: TextStyle(color: Colors.white, fontFamily: AppFonts.poppinsBold)),
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.orange500,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Data', style: TextStyle(color: AppColors.blue200, fontSize: 12)),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.calendar_today, size: 16),
          label: Text(_selectedDateTime == null ? 'Selecionar' : DateFormat('dd/MM/yy').format(_selectedDateTime!)),
          onPressed: _pickDate,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.orange400,
            side: const BorderSide(color: AppColors.gray700),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        )
      ],
    );
  }
  
  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hora', style: TextStyle(color: AppColors.blue200, fontSize: 12)),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.access_time, size: 16),
          label: Text(_selectedDateTime == null ? 'Selecionar' : DateFormat('HH:mm').format(_selectedDateTime!)),
          onPressed: _pickTime,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.orange400,
            side: const BorderSide(color: AppColors.gray700),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        )
      ],
    );
  }
}

// =======================================================================
// SEU CÓDIGO ORIGINAL (NÃO MODIFICADO)
// =======================================================================
class _EventsContent extends StatelessWidget {
  final bool isMyEvents;
  final VoidCallback onInialize;
  final Function(String) joinEvent;
  final Function(String) leaveEvent;
  final List<EventModel> events;

  const _EventsContent({
    required this.events,
    required this.onInialize,
    required this.joinEvent,
    required this.leaveEvent,
    required this.isMyEvents,
  });

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy \'às\' HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Expanded(
                child: events.isEmpty
                    ? Center(
                        child: Text(
                          isMyEvents
                              ? 'Você ainda não participa de nenhum evento.'
                              : 'Nenhum evento encontrado.',
                          style: const TextStyle(color: AppColors.blue200),
                        ),
                      )
                    : RefreshIndicator.adaptive(
                        onRefresh: () async {
                          onInialize();
                        },
                        child: ListView.separated(
                          padding: const EdgeInsets.only(top: 8, bottom: 80), // Padding para o FAB
                          itemCount: events.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = events[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                backgroundColor: AppColors.gray800,
                                collapsedBackgroundColor: AppColors.gray800,
                                iconColor: AppColors.orange500,
                                collapsedIconColor: AppColors.orange500,
                                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: AppFonts.poppinsSemiBold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: item.finished ? Colors.red[600] : Colors.green[600],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        item.finished ? 'Finalizado' : 'Aberto',
                                        style: const TextStyle(fontSize: 10, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today, color: AppColors.blue300, size: 14),
                                      const SizedBox(width: 6),
                                      Text(
                                        formatDate(item.date),
                                        style: const TextStyle(color: AppColors.blue300, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Divider(color: AppColors.gray700),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Participantes (${item.participants.length})',
                                          style: const TextStyle(
                                            fontFamily: AppFonts.poppinsMedium,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        item.participants.isEmpty
                                            ? const Padding(
                                                padding: EdgeInsets.only(bottom: 8.0),
                                                child: Text(
                                                  'Ninguém entrou no evento ainda. Seja o primeiro!',
                                                  style: TextStyle(color: AppColors.blue200, fontSize: 12),
                                                ),
                                              )
                                            : Column(
                                                children: item.participants
                                                  .map((user) => _ParticipantTile(user: user))
                                                  .toList(),
                                              ),

                                        if (!item.finished) ...[
                                          const SizedBox(height: 16),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: isMyEvents
                                                ? TextButton.icon(
                                                    icon: const Icon(Icons.exit_to_app, size: 16, color: AppColors.blue200),
                                                    label: const Text('Sair do evento', style: TextStyle(color: AppColors.blue200)),
                                                    onPressed: () => leaveEvent(item.id),
                                                  )
                                                : !isMyEvents
                                                    ? ElevatedButton.icon(
                                                        icon: const Icon(Icons.login, size: 16),
                                                        label: const Text('Entrar no evento'),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: AppColors.orange500.withOpacity(0.8),
                                                          foregroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                        ),
                                                        onPressed: () => joinEvent(item.id),
                                                      )
                                                    : const SizedBox.shrink(),
                                          ),
                                        ],
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final User user;
  const _ParticipantTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Paths.userProfile, arguments: user),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/600?u=${user.id}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: AppFonts.poppinsRegular
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${user.username}',
                    style: const TextStyle(
                      color: AppColors.blue300,
                      fontSize: 12,
                      fontFamily: AppFonts.poppinsRegular
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}