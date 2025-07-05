import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mywebapp/pages/custom_widgets/custom_webview_navbar.dart';
import 'package:mywebapp/pages/navbar/homepage.dart';
import 'package:mywebapp/pages/navigator.dart';
import 'package:mywebapp/pages/splash/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        current = pageController.page!.round();
      });
    });
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
            fontSize: 22,
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
