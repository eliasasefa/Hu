import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

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
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage('assets/images/hu1-logo.png'),
              radius: 18,
              backgroundColor: theme.colorScheme.surface,
            ),
            const SizedBox(width: 10),
            Text(
              'Haramaya University',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [theme.colorScheme.surface, theme.colorScheme.background]
                : [
                    theme.colorScheme.primary.withOpacity(0.07),
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
                    horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Section(
                      title: 'Our History',
                      icon: Icons.history_edu,
                      accentColor: theme.colorScheme.primary,
                      content:
                          'Founded in 1954, Haramaya University has a proud legacy of providing quality education and fostering a culture of excellence in teaching, research, and community engagement. Over the years, we have evolved into a premier institution of higher learning in Ethiopia, with a commitment to advancing knowledge and addressing societal challenges.',
                    ),
                    Section(
                      title: 'Academic Excellence',
                      icon: Icons.school,
                      accentColor: Colors.teal,
                      content:
                          'At Haramaya University, we offer a diverse range of undergraduate, postgraduate, and doctoral programs across various disciplines. Our esteemed faculty members are dedicated to nurturing the next generation of leaders and innovators through rigorous academic training and research mentorship.',
                    ),
                    Section(
                      title: 'Research and Innovation',
                      icon: Icons.science,
                      accentColor: Colors.deepPurple,
                      content:
                          'Research is at the heart of our mission at Haramaya University. Our scholars engage in cutting-edge research across fields such as agriculture, health sciences, engineering, social sciences, and humanities. Through collaboration and innovation, we strive to generate new knowledge, solve complex problems, and make meaningful contributions to sustainable development.',
                    ),
                    Section(
                      title: 'Community Engagement',
                      icon: Icons.people_alt,
                      accentColor: Colors.orange,
                      content:
                          'Haramaya University is deeply committed to serving our local and global communities. Through outreach programs, partnerships with industry and government agencies, and initiatives aimed at addressing societal needs, we seek to create positive change and empower individuals to reach their full potential.',
                    ),
                    Section(
                      title: 'Our Vision',
                      icon: Icons.visibility,
                      accentColor: Colors.blue,
                      content:
                          'To be a leading center of academic excellence, research innovation, and community development in Ethiopia and beyond.',
                    ),
                    Section(
                      title: 'Our Mission',
                      icon: Icons.flag,
                      accentColor: Colors.green,
                      content:
                          'To provide quality education, conduct impactful research, and foster holistic development for the betterment of society.',
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
}

class Section extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color accentColor;

  const Section({
    required this.title,
    required this.content,
    required this.icon,
    required this.accentColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(icon, color: accentColor, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                        letterSpacing: 1.05,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
