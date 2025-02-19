import 'package:url_launcher/url_launcher.dart';

///Service class for forwarding users to external services like 'teams'
class ForwardToExternal {
  /// Opens a Microsoft Teams chat with the given [userEmail].
  ///
  /// If the Teams app is installed, it will open directly in Teams.
  /// Otherwise, it falls back to the web version.
  static Future<void> openTeamsChat(String userEmail) async {
    // Deep link for Microsoft Teams
    final teamsDeepLink = Uri.parse(
      'msteams://teams.microsoft.com/l/chat/0/0?users=$userEmail',
    );

    // Check if the device can handle the deep link (Teams installed)
    if (await canLaunchUrl(teamsDeepLink)) {
      await launchUrl(teamsDeepLink, mode: LaunchMode.externalApplication);
    } else {
      // Fallback to Teams web if the app is not installed
      final webLink = Uri.parse(
        'https://teams.microsoft.com/l/chat/0/0?users=$userEmail',
      );
      await launchUrl(webLink, mode: LaunchMode.externalApplication);
    }
  }
}
