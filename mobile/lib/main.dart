import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/controller_screen.dart';
import 'theme/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const UplinkPadApp());
}

class UplinkPadApp extends StatelessWidget {
  const UplinkPadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uplink Pad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: PadColors.background,
      ),
      home: const ControllerScreen(),
    );
  }
}
