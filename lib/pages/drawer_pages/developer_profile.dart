import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperProfile extends StatelessWidget {
  const DeveloperProfile({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Developer Profile'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [theme.colorScheme.surface, theme.colorScheme.background]
                : [
                    theme.colorScheme.primary.withOpacity(0.10),
                    theme.colorScheme.background
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Card
                    Container(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Card(
                        elevation: 10,
                        color: theme.colorScheme.surface
                            .withOpacity(isDark ? 0.85 : 0.75),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28.0, vertical: 36.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Profile Image with border/glow
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.25),
                                      blurRadius: 24,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 64,
                                  backgroundImage: const AssetImage(
                                      'assets/images/profile.jpg'),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                'Elias Asefa',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  fontSize: 30,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Software Engineer | Mobile & Web Developer',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '"Building digital experiences, one pixel at a time."',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: theme.hintColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 22),
                              // About Section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info_outline,
                                      color: theme.colorScheme.primary,
                                      size: 22),
                                  const SizedBox(width: 8),
                                  Text('About',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Recent Software Engineering graduate with a strong foundation in developing innovative mobile and web applications. Proficient in Flutter, Dart, Firebase, and contemporary web technologies.",
                                textAlign: TextAlign.left,
                                style: theme.textTheme.bodyLarge
                                    ?.copyWith(height: 1.5),
                              ),
                              const SizedBox(height: 22),
                              // Skills Section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.code,
                                      color: theme.colorScheme.primary,
                                      size: 22),
                                  const SizedBox(width: 8),
                                  Text('Skills',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 5,
                                runSpacing: 0,
                                alignment: WrapAlignment.center,
                                children: [
                                  _buildSkillChip('Flutter', theme,
                                      icon: FontAwesomeIcons.mobileScreen),
                                  _buildSkillChip('Dart', theme,
                                      icon: FontAwesomeIcons.code),
                                  _buildSkillChip('Firebase', theme,
                                      icon: FontAwesomeIcons.fire),
                                  _buildSkillChip('React.js', theme,
                                      icon: FontAwesomeIcons.react),
                                  _buildSkillChip('Node.js', theme,
                                      icon: FontAwesomeIcons.nodeJs),
                                  _buildSkillChip('Git', theme,
                                      icon: FontAwesomeIcons.gitAlt),
                                ],
                              ),
                              const SizedBox(height: 22),
                              // Social Links
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.link,
                                      color: theme.colorScheme.primary,
                                      size: 22),
                                  const SizedBox(width: 8),
                                  Text('Social',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildSocialIcon(
                                      FontAwesomeIcons.linkedin,
                                      'https://www.linkedin.com/in/eliasasefa3/',
                                      theme,
                                      'LinkedIn'),
                                  _buildSocialIcon(
                                      FontAwesomeIcons.github,
                                      'https://github.com/eliasasefa',
                                      theme,
                                      'GitHub'),
                                  _buildSocialIcon(
                                      FontAwesomeIcons.telegram,
                                      'https://t.me/eliasasefa3',
                                      theme,
                                      'Telegram'),
                                  _buildSocialIcon(
                                      FontAwesomeIcons.facebook,
                                      'https://www.facebook.com/elias.asefa.940',
                                      theme,
                                      'Facebook'),
                                ],
                              ),
                              const SizedBox(height: 22),
                              // Contact Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildContactButton(
                                    icon: Icons.email,
                                    label: 'Email',
                                    url: 'mailto:eliasasefa3@gmail.com',
                                    theme: theme,
                                  ),
                                  const SizedBox(width: 16),
                                  _buildContactButton(
                                    icon: Icons.phone,
                                    label: 'Call',
                                    url: 'tel:+251931690612',
                                    theme: theme,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),
                              // Portfolio Button
                              FilledButton.tonal(
                                onPressed: () => _launchURL(
                                    'https://eliasasefa.netlify.app'),
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 16),
                                  textStyle: theme.textTheme.labelLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.open_in_new,
                                        color: theme.colorScheme.primary,
                                        size: 22),
                                    const SizedBox(width: 10),
                                    Text('View Portfolio',
                                        style: TextStyle(
                                            color: theme.colorScheme.primary)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill, ThemeData theme, {IconData? icon}) {
    return Chip(
      avatar: icon != null
          ? FaIcon(icon, size: 16, color: theme.colorScheme.primary)
          : null,
      label: Text(skill,
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
      backgroundColor: theme.colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    );
  }

  Widget _buildSocialIcon(
      IconData icon, String url, ThemeData theme, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: () => _launchURL(url),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: CircleAvatar(
            backgroundColor: theme.colorScheme.primary.withOpacity(0.10),
            radius: 22,
            child: FaIcon(icon, color: theme.colorScheme.primary, size: 22),
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required String url,
    required ThemeData theme,
  }) {
    return Tooltip(
      message: label,
      child: FilledButton(
        onPressed: () => _launchURL(url),
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle:
              theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
