import 'package:ams/config/resources/images.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      // Navigator.of(context)
      //     .pushReplacement(MaterialPageRoute(builder: (_) => Login()));
      // Get.to(() => LandingPage());
      Get.off(
        () => const LoginPage(),
        transition: Transition.rightToLeft,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 1),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      AppImages.appLogo,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('"Welcome To Ayata"',
                      textStyle: mediumStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade500,
                      )),
                ],
                totalRepeatCount: 10,
                pause: const Duration(milliseconds: 2000),
              ),
              const Spacer(flex: 2),
              // CircularProgressIndicator(),
              SpinKitFoldingCube(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.red : Colors.green,
                    ),
                  );
                },
              ),
              const Spacer(flex: 2)
            ],
          ),
        ),
      ),
    );
  }
}
