import 'package:flutter/material.dart';
import 'package:hu/pages/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
        imageWidget: Image.asset('assets/images/hu1-logo.png',
            width: 180, height: 180, fit: BoxFit.contain),
        title: 'Welcome to Hu+',
        description:
            'Your gateway to campus life, academics, services, and more!'),
    _OnboardingSlide(
        imageWidget: _FeatureIcon(
          icon: Icons.school,
          color: Colors.blueAccent,
          background: Colors.blue.shade50,
        ),
        title: 'Access Student Portals',
        description:
            'Quickly access student portals, resources, and academic tools.'),
    _OnboardingSlide(
        imageWidget: _FeatureIcon(
          icon: Icons.campaign,
          color: Colors.orangeAccent,
          background: Colors.orange.shade50,
        ),
        title: 'Stay Updated',
        description:
            'Get the latest news, events, and announcements from campus.'),
    _OnboardingSlide(
        imageWidget: _FeatureIcon(
          icon: Icons.person,
          color: Colors.green,
          background: Colors.green.shade50,
        ),
        title: 'Manage Your Profile',
        description: 'Update your profile, settings, and preferences easily.'),
    _OnboardingSlide(
        imageWidget: _FeatureIcon(
          icon: Icons.assignment_turned_in,
          color: Colors.purple,
          background: Colors.purple.shade50,
        ),
        title: 'Take Exit Exams',
        description: 'Practice and take exit exams, and view your results.'),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _goToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(onLoginSuccess: () {})),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        slide.imageWidget,
                        const SizedBox(height: 32),
                        Text(
                          slide.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          slide.description,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                  width: _currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: SizedBox(
                width: double.infinity,
                child: _currentPage == _slides.length - 1
                    ? OutlinedButton(
                        onPressed: _goToLogin,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: BorderSide(
                              color: theme.colorScheme.primary, width: 2),
                          foregroundColor: theme.colorScheme.primary,
                          backgroundColor: Colors.transparent,
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Get Started'),
                            const SizedBox(width: 12),
                            const Icon(Icons.check_circle_outline, size: 26),
                          ],
                        ),
                      )
                    : OutlinedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: BorderSide(
                              color: theme.colorScheme.primary, width: 2),
                          foregroundColor: theme.colorScheme.primary,
                          backgroundColor: Colors.transparent,
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Next'),
                            const SizedBox(width: 12),
                            const Icon(Icons.arrow_forward_ios, size: 26),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  final Widget imageWidget;
  final String title;
  final String description;
  const _OnboardingSlide(
      {required this.imageWidget,
      required this.title,
      required this.description});
}

class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color background;
  const _FeatureIcon(
      {required this.icon, required this.color, required this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Icon(icon, size: 72, color: color),
      ),
    );
  }
}
