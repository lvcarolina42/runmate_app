import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';
import 'package:runmate_app/shared/constants/app_images.dart';
import 'package:runmate_app/shared/themes/app_fonts.dart';

// --- Classes de exemplo para compilação ---
// No seu app real, você importaria estas classes dos seus arquivos de tema.
class AppColors {
  static const Color blue950 = Color(0xFF0D1B2A);
  static const Color blue900 = Color(0xFF1B263B);
  static const Color blue700 = Color(0xFF415A77);
  static const Color blue300 = Color(0xFFB4C3D6);
  static const Color blue200 = Color(0xFFDDE4ED);
  static const Color gray800 = Color(0xFF222E3E);
  static const Color orange600 = Color(0xFFF77F00);
  static const Color orange500 = Color(0xFFFF9829);
  static const Color white = Colors.white;
}

// -----------------------------------------

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Lógica de Responsividade ---
    // Verifica a largura da tela para determinar se é um layout móvel
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 800; // Ponto de quebra para layout móvel

    // Define o preenchimento horizontal com base no tamanho da tela
    final double horizontalPadding = isMobile ? 24.0 : 80.0;
    const double contentWidth = 1100;

    return Scaffold(
      backgroundColor: AppColors.blue950,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: isMobile, // Centraliza o título no modo móvel
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : horizontalPadding / 2),
          child: const Text(
            'RunMate',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: AppFonts.poppinsBold,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        actions: [
          // Esconde o botão de login do AppBar em telas móveis para economizar espaço
          if (!isMobile)
            Padding(
              padding: EdgeInsets.only(right: horizontalPadding),
              child: TextButton(
                onPressed: () => Get.toNamed(Paths.loginPage),
                child: const Text(
                  'Entrar',
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: AppFonts.poppinsSemiBold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: contentWidth),
            child: Column(
              children: [
                _HeroSection(
                  isMobile: isMobile,
                  horizontalPadding: horizontalPadding,
                  onLogin: () => Get.toNamed(Paths.loginPage),
                ),
                _FeaturesSection(isMobile: isMobile, horizontalPadding: horizontalPadding),
                _AppShowcaseSection(isMobile: isMobile, horizontalPadding: horizontalPadding),
                _CallToActionSection(horizontalPadding: horizontalPadding),
                _Footer(isMobile: isMobile, horizontalPadding: horizontalPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final bool isMobile;
  final double horizontalPadding;
  final VoidCallback onLogin;

  const _HeroSection({
    required this.isMobile,
    required this.horizontalPadding,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Sua Corrida, Sua Comunidade, Seu Desafio.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              // Ajusta o tamanho da fonte para telas móveis
              fontSize: isMobile ? 38 : 56,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.poppinsBold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Junte-se a uma comunidade vibrante de corredores. Monitore seu progresso com assistência de áudio, conquiste desafios, defina metas pessoais e participe de eventos. Todo o seu universo da corrida, em um só aplicativo.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blue200,
              // Ajusta o tamanho da fonte para telas móveis
              fontSize: isMobile ? 16 : 20,
              fontFamily: AppFonts.poppinsRegular,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          Column(
            children: [
              const Text(
                'BAIXE O APLICATIVO',
                style: TextStyle(
                    color: AppColors.blue300,
                    fontFamily: AppFonts.poppinsRegular,
                    fontSize: 12,
                    letterSpacing: 1.1),
              ),
              const SizedBox(height: 16),
              // Usa Wrap para que os botões quebrem a linha em telas menores
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.blue700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {/* Link para Google Play */},
                    child: const Text(
                      'Google Play',
                      style: TextStyle(
                        color: AppColors.white,
                        fontFamily: AppFonts.poppinsBold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.blue700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {/* Link para App Store */},
                    child: const Text(
                      'App Store',
                      style: TextStyle(
                        color: AppColors.white,
                        fontFamily: AppFonts.poppinsBold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child:
                          Divider(color: AppColors.blue700, endIndent: 16)),
                  Text('OU', style: TextStyle(color: AppColors.blue300)),
                  Expanded(
                      child: Divider(color: AppColors.blue700, indent: 16)),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange600,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: onLogin,
                child: const Text(
                  'Entrar na Versão Web',
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: AppFonts.poppinsBold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  final bool isMobile;
  final double horizontalPadding;
  const _FeaturesSection({required this.isMobile, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.gray800,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 60),
      child: Column(
        children: [
          Text(
            'Tudo que Você Precisa para Vencer',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              // Ajuste de fonte para telas móveis
              fontSize: isMobile ? 28 : 32,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.poppinsBold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Da sua primeira caminhada à sua próxima maratona, nós temos o que você precisa.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blue300,
              fontSize: isMobile ? 16 : 18,
              fontFamily: AppFonts.poppinsRegular,
            ),
          ),
          const SizedBox(height: 48),
          // O widget Wrap é naturalmente responsivo, não precisa de grandes alterações
          const Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _FeatureCard(
                icon: Icons.track_changes,
                title: 'Corridas com Assistência de Áudio',
                description: 'Receba feedback em tempo real sobre seu ritmo e distância sem precisar olhar para a tela.',
              ),
              _FeatureCard(
                icon: Icons.emoji_events,
                title: 'Desafios Envolventes',
                description: 'Compita com amigos ou com a comunidade. Suba no ranking e ganhe o direito de se gabar.',
              ),
              _FeatureCard(
                icon: Icons.people_alt,
                title: 'Feed Social e Amigos',
                description: 'Compartilhe suas conquistas, incentive seus amigos e monte sua equipe de corrida.',
              ),
              _FeatureCard(
                icon: Icons.flag,
                title: 'Metas Pessoais',
                description: 'Defina metas semanais de distância ou frequência e veja o app monitorar sua consistência.',
              ),
              _FeatureCard(
                icon: Icons.wb_sunny,
                title: 'Previsão do Tempo',
                description: 'Planeje suas corridas perfeitamente com a previsão do tempo integrada para as próximas horas e dias.',
              ),
              _FeatureCard(
                icon: Icons.event_available,
                title: 'Eventos da Comunidade',
                description: 'Descubra e participe de eventos de corrida locais, de corridas divertidas a provas oficiais.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 340),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.blue950,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.orange500, size: 36),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontFamily: AppFonts.poppinsSemiBold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: AppColors.blue300,
                fontFamily: AppFonts.poppinsRegular,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppShowcaseSection extends StatelessWidget {
  final bool isMobile;
  final double horizontalPadding;
  const _AppShowcaseSection({required this.isMobile, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 80),
      // Usa o widget Flex para mudar a direção do layout (Row -> Column)
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Expanded garante que o texto ocupe o espaço disponível
          Expanded(
            child: Column(
              crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  'Uma Interface que Você Vai Amar',
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: isMobile ? 28 : 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.poppinsBold,
                  ),
                ),
                const SizedBox(height: 16),
                 Text(
                  'Nossa interface limpa, intuitiva e com tema escuro mantém o foco no que mais importa: seus dados e sua comunidade. As experiências na web e no celular são perfeitamente conectadas.',
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                  style: TextStyle(
                    color: AppColors.blue300,
                    fontSize: isMobile ? 16 : 18,
                    fontFamily: AppFonts.poppinsRegular,
                    height: 1.6
                  ),
                ),
              ],
            ),
          ),
          // Adiciona um espaçamento vertical no modo móvel e horizontal no desktop
          SizedBox(width: isMobile ? 0 : 60, height: isMobile ? 40 : 0),
          // A imagem não deve estar dentro de um Expanded para evitar erros de layout na Coluna
          Container(
            constraints: BoxConstraints(
              // Limita a largura da imagem no modo móvel
              maxWidth: isMobile ? 320 : 300,
            ),
            height: isMobile ? 550 : 600,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.blue700, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              // Tratamento de erro para caso a imagem não carregue
              child: Image.asset(
                AppImages.app,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.phone_android, color: AppColors.blue700, size: 80));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _CallToActionSection extends StatelessWidget {
  final double horizontalPadding;

  const _CallToActionSection({required this.horizontalPadding});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 800;
    
    return Container(
       color: AppColors.gray800,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 80),
      child: Column(
        children: [
           Text(
            'Pronto para Começar sua Jornada?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: isMobile ? 28 : 32,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.poppinsBold,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange600,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () { /* Poderia abrir o link da loja de apps */ },
                child: const Text(
                  'Baixe Agora de Graça',
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: AppFonts.poppinsBold,
                    fontSize: 16,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}


class _Footer extends StatelessWidget {
  final bool isMobile;
  final double horizontalPadding;
  const _Footer({required this.isMobile, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text(
            '© ${DateTime.now().year} RunMate. Todos os direitos reservados.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.blue700,
              fontFamily: AppFonts.poppinsRegular,
              fontSize: 14,
            ),
          ),
          if (isMobile) const SizedBox(height: 16),
          // Adicione links para redes sociais aqui se necessário
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.facebook, color: AppColors.blue700)),
              IconButton(onPressed: (){}, icon: const Icon(Icons.code, color: AppColors.blue700)), // Ícone de exemplo para Twitter/X
            ],
          )
        ],
      ),
    );
  }
}