import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.system,
    theme: ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
    ),
    home: DeveloperProfile(),
  ));
}

class DeveloperProfile extends StatelessWidget {
  const DeveloperProfile({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Elias Asefa'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(height: 16),
              Text(
                'Elias Asefa',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Software Developer',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.justify,
                    softWrap: true,
                    'A passionate Software developer eager to build mobile applications. I enjoy learning new technologies and solving challenging problems. Software Engineering Student at Haramaya University.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Skills',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildSkillChip('Flutter', theme),
                  _buildSkillChip('Dart', theme),
                  _buildSkillChip('Firebase', theme),
                  _buildSkillChip('React.js', theme),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Contact Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              _buildContactInfoWidget(
                icon: Icons.email,
                text: 'eliasasefa3@gmail.com',
                url: 'mailto:eliasasefa3@gmail.com',
                theme: theme,
              ),
              _buildContactInfoWidget(
                icon: Icons.phone,
                text: '+251931690612',
                url: 'tel:+251931690612',
                theme: theme,
              ),
              const SizedBox(height: 16),
              Text(
                'Follow me on social media',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildSocialIcon(FontAwesomeIcons.linkedin,
                      'https://www.linkedin.com/in/eliasasefa3/', theme),
                  _buildSocialIcon(FontAwesomeIcons.telegram,
                      'https://t.me/eliasasefa3', theme),
                  _buildSocialIcon(FontAwesomeIcons.github,
                      'https://github.com/eliasasefa', theme),
                  _buildSocialIcon(FontAwesomeIcons.facebook,
                      'https://www.facebook.com/elias.asefa.940', theme),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfoWidget({
    required IconData icon,
    required String text,
    required String url,
    required ThemeData theme,
  }) {
    return ElevatedButton.icon(
      onPressed: () => _launchURL(url),
      icon: Icon(icon, color: theme.colorScheme.onPrimary),
      label: Text(text,
          style: theme.textTheme.labelLarge
              ?.copyWith(color: theme.colorScheme.onPrimary)),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill, ThemeData theme) {
    return Chip(
      label: Text(skill, style: theme.textTheme.bodyMedium),
      backgroundColor: theme.colorScheme.secondaryContainer,
    );
  }

  Widget _buildSocialIcon(IconData icon, String url, ThemeData theme) {
    return IconButton(
      icon: FaIcon(icon, color: theme.colorScheme.primary),
      onPressed: () => _launchURL(url),
    );
  }
}
