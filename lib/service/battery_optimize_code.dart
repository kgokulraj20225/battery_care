import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';


Future<void> openBatteryOptimizationSettings() async {
  const intent = AndroidIntent(
    action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
  );
  await intent.launch();
}



// Future<void> requestIgnoreBatteryOptimizations() async {
//   const url = 'package:'; // Better: use Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
//   // Recommended: Use a package like 'device_apps' or implement via MethodChannel
//   // Simple way:
//   if (await canLaunchUrl(Uri.parse('android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS'))) {
//     await launchUrl(Uri.parse('android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS'));
//   } else {
//     // Fallback: open general battery optimization settings
//     await launchUrl(Uri.parse('android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS'));
//   }
// }