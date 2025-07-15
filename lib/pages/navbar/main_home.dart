import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hu/pages/custom_widgets/custom_webview_navbar.dart';
import 'package:hu/pages/navbar/homepage.dart';
import 'package:hu/pages/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key, required this.toggleTheme});
  final VoidCallback toggleTheme;

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  List<String> items = [
    "Home",
    "Academics",
    "Admission",
    "Research",
    "Administration",
    "Library",
    "Community",
    "Partnership",
    "Services",
    "Student",
    "HU Home",
  ];
  int current = 0;
  PageController pageController = PageController();
  ScrollController _scrollController = ScrollController();
  bool _showRememberMeBanner = false;
  bool _rememberMeBannerChecked = false;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        current = pageController.page!.round();
      });
    });
    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;
    final bannerShown = prefs.getBool('remember_me_banner_shown') ?? false;
    setState(() {
      _showRememberMeBanner = !rememberMe && !bannerShown;
      _rememberMeBannerChecked = true;
    });
    if (!bannerShown && !rememberMe) {
      await prefs.setBool('remember_me_banner_shown', true);
    }
  }

  Future<void> _enableRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', true);
    setState(() {
      _showRememberMeBanner = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Remember Me enabled! You will stay signed in.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      drawer: NavBar(
        onMenuItemClicked: (dynamic) {},
        toggleTheme: widget.toggleTheme,
      ),
      appBar: AppBar(
        elevation: 4,
        backgroundColor: theme.colorScheme.surface,
        actions: [
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: theme.colorScheme.primary,
            ),
            tooltip: theme.brightness == Brightness.dark
                ? 'Switch to Light Mode'
                : 'Switch to Dark Mode',
            onPressed: widget.toggleTheme,
          ),
          const SizedBox(width: 15),
        ],
        toolbarHeight: 56.0,
        centerTitle: true,
        title: Text(
          'Haramaya University',
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: theme.colorScheme.background,
        child: Column(
          children: [
            if (_showRememberMeBanner && _rememberMeBannerChecked)
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Want to stay signed in? Enable "Remember Me" to skip login next time.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Dismiss',
                      onPressed: () {
                        setState(() {
                          _showRememberMeBanner = false;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: _enableRememberMe,
                      child: const Text('Enable'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                      left: current * 107.0,
                      top: 0,
                      child: Container(
                        width: 103,
                        height: 36,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: Row(
                        children: List.generate(items.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                current = index;
                              });
                              pageController.animateToPage(
                                current,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.ease,
                              );
                            },
                            child: Container(
                              width: 103,
                              height: 36,
                              alignment: Alignment.center,
                              child: Text(
                                items[index],
                                style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: current == index
                                      ? theme.colorScheme.primary
                                      : theme.textTheme.bodyMedium?.color
                                          ?.withOpacity(0.7),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: PageView.builder(
                      itemCount: items.length,
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return const MyHomePage();
                          case 1:
                            return const CustomWebViewNavbar(
                                url: 'https://www.haramaya.edu.et/academics/');
                          case 2:
                            return const CustomWebViewNavbar(
                                url: 'https://www.haramaya.edu.et/admission/');
                          case 3:
                            return const CustomWebViewNavbar(
                                url: 'http://researchaffairs.haramaya.edu.et');
                          case 4:
                            return const CustomWebViewNavbar(
                                url: 'https://www.haramaya.edu.et/admin/');
                          case 5:
                            return const CustomWebViewNavbar(
                                url:
                                    'https://www.haramaya.edu.et/library-information-system/');
                          case 6:
                            return const CustomWebViewNavbar(
                                url: 'https://www.haramaya.edu.et/community/');
                          case 7:
                            return const CustomWebViewNavbar(
                                url: 'https://www.haramaya.edu.et/partners/#');
                          case 8:
                            return const CustomWebViewNavbar(
                                url: 'https://www.haramaya.edu.et/services/');
                          case 9:
                            return const CustomWebViewNavbar(
                                url:
                                    'https://www.haramaya.edu.et/student-life/');
                          case 10:
                            return const CustomWebViewNavbar(
                                url: 'https://www.haramaya.edu.et/');
                          default:
                            return Container();
                        }
                      },
                    ),
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
