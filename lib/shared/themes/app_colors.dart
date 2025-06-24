import 'package:flutter/material.dart';

class AppColors {
  static const Color transparent = Colors.transparent;


  // ****** Brand colors ******
  static const Color primaryBrand = blue500;
  static const Color secondaryBrand = blue600;
  static const Color dangerBrand = red500;
  static const Color warningBrand = orange500;
  static const Color successBrand = green500;
  static const Color infoBrand = gray800;
  static const Color whiteBrand = Color(0xFFFFFFFF);
  static const Color whiteLight = Color(0xFFFAFAFA);

  // ****** Gray ******

  static const Color gray42 = Color(0xFF424242);

  static const Color gray50 = Color(0xFFF5F5F6);
  static const Color gray100 = Color(0xFFE6E6E7);
  static const Color gray200 = Color(0xFFCFD0D2);
  static const Color gray300 = Color(0xFFADADB3);
  static const Color gray400 = Color(0xFF84858C);
  static const Color gray500 = Color(0xFF696A71);
  static const Color gray600 = Color(0xFF58585F);
  static const Color gray700 = Color(0xFF4C4C52);
  static const Color gray800 = Color(0xFF434347);
  static const Color gray900 = Color(0xFF3B3B3E);
  static const Color gray950 = Color(0xFF252527);

  // ****** Blue ******

  static const Color buttonLogin = Color(0xFF537A95);
  static const Color bgColor = Color(0xFF0A1F2F);

  static const Color blue50 = Color(0xFFF0F9FF);
  static const Color blue100 = Color(0xFFE0F1FE);
  static const Color blue200 = Color(0xFFB9E4FE);
  static const Color blue300 = Color(0xFF7CCFFD);
  static const Color blue400 = Color(0xFF36B8FA);
  static const Color blue500 = Color(0xFF009FEB);
  static const Color blue600 = Color(0xFF007DC7);
  static const Color blue700 = Color(0xFF0164A3);
  static const Color blue800 = Color(0xFF065586);
  static const Color blue900 = Color(0xFF0B476F);
  static const Color blue950 = Color(0xFF072D4A);

  // ****** Green ******

  static const Color green50 = Color(0xFFEAFFF5);
  static const Color green100 = Color(0xFFCDFEE5);
  static const Color green200 = Color(0xFFA0FAD1);
  static const Color green300 = Color(0xFF63F2B9);
  static const Color green400 = Color(0xFF25E29D);
  static const Color green500 = Color(0xFF00C785);
  static const Color green600 = Color(0xFF00A46E);
  static const Color green700 = Color(0xFF00835C);
  static const Color green800 = Color(0xFF00674A);
  static const Color green900 = Color(0xFF00553E);
  static const Color green950 = Color(0xFF003024);
  static const Color greenPix = Color(0xFF77B6A8);

  // ****** Red ******

  static const Color red50 = Color(0xFFFFF0F0);
  static const Color red100 = Color(0xFFFFDDDD);
  static const Color red200 = Color(0xFFFFC1C1);
  static const Color red300 = Color(0xFFFFA7A7);
  static const Color red400 = Color(0xFFFA7676);
  static const Color red500 = Color(0xFFF44444);
  static const Color red600 = Color(0xFFED0B0B);
  static const Color red700 = Color(0xFFC70000);
  static const Color red800 = Color(0xFFAF0505);
  static const Color red900 = Color(0xFF900C0C);
  static const Color red950 = Color(0xFF500000);

  // ****** Orange ******

  static const Color orange50 = Color(0xFFFEF8EC);
  static const Color orange100 = Color(0xFFFCE9C9);
  static const Color orange200 = Color(0xFFF9D28E);
  static const Color orange300 = Color(0xFFF6B453);
  static const Color orange400 = Color(0xFFF5A23D);
  static const Color orange500 = Color(0xFFED7713);
  static const Color orange600 = Color(0xFFD2550D);
  static const Color orange700 = Color(0xFFAE390F);
  static const Color orange800 = Color(0xFF8E2C12);
  static const Color orange900 = Color(0xFF752512);
  static const Color orange950 = Color(0xFF431005);

  // ****** Yellow ******

  static const Color yellow50 = Color(0xFFFEFEE8);
  static const Color yellow100 = Color(0xFFFFFEC2);
  static const Color yellow200 = Color(0xFFFFFB88);
  static const Color yellow300 = Color(0xFFFFF143);
  static const Color yellow400 = Color(0xFFFFE010);
  static const Color yellow500 = Color(0xFFEFC603);
  static const Color yellow600 = Color(0xFFC79500);
  static const Color yellow700 = Color(0xFFA46F04);
  static const Color yellow800 = Color(0xFF87560C);
  static const Color yellow900 = Color(0xFF734610);
  static const Color yellow950 = Color(0xFF432405);

  // ****** Purple ******

  static const Color purple50 = Color(0xFFF5F0FF);
  static const Color purple100 = Color(0xFFEDE4FF);
  static const Color purple200 = Color(0xFFDDCDFF);
  static const Color purple300 = Color(0xFFC7A5FF);
  static const Color purple400 = Color(0xFFAD72FF);
  static const Color purple500 = Color(0xFF973AFF);
  static const Color purple600 = Color(0xFF9012FF);
  static const Color purple700 = Color(0xFF8501FF);
  static const Color purple800 = Color(0xFF6700C7);
  static const Color purple900 = Color(0xFF5C02B0);
  static const Color purple950 = Color(0xFF370078);

  // ****** White ******
  static const Color background1 = Color(0xFFFBFBFB);

  // ****** Shimmer ******
  static Gradient shimmerGradient = LinearGradient(colors: [
    transparent,
    whiteBrand.withOpacity(0.4),
    transparent,
  ]);
}
