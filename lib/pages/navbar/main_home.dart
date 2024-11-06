import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mywebapp/pages/custom_widgets/custom_webview_navbar.dart';
import 'package:mywebapp/pages/navbar/homepage.dart';
import 'package:mywebapp/pages/navigator.dart';
import 'package:mywebapp/pages/splash/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          '/home': (context) => const MyHomePage(),
        },
        debugShowCheckedModeBanner: false,
        home: const Splash(),
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          primarySwatch: Colors.green,
          appBarTheme: const AppBarTheme(
            color: Colors.blueGrey,
            foregroundColor: Colors.white,
          ),
          textTheme: GoogleFonts.ubuntuTextTheme(
            Theme.of(context).primaryTextTheme,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.teal,
          appBarTheme: const AppBarTheme(
            color: Colors.black87,
            foregroundColor: Colors.white,
          ),
          textTheme: GoogleFonts.ubuntuTextTheme(
            Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
          ),
        ),
        themeMode: ThemeMode.system);
  }
}

class MainHome extends StatefulWidget {
  const MainHome({super.key});

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
    return Scaffold(
      drawer: NavBar(onMenuItemClicked: (dynamic) {}),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Image(
              image: AssetImage('assets/images/hu1-logo.png'),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 15),
        ],
        toolbarHeight: 35.0,
        centerTitle: true,
        title: const Text('Haramaya University'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Stack(
              children: [
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
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.all(3),
                          width: 103,
                          height: 30,
                          decoration: BoxDecoration(
                            color: current == index
                                ? Theme.of(context).primaryColorLight
                                : Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: current == index
                                ? BorderRadius.circular(12)
                                : BorderRadius.circular(7),
                            border: current == index
                                ? Border.all(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2.5)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              items[index],
                              style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.w500,
                                color: current == index
                                    ? Colors.black
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            Expanded(
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
                          url: 'https://www.haramaya.edu.et/student-life/');
                    case 10:
                      return const CustomWebViewNavbar(
                          url: 'https://www.haramaya.edu.et/');
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
