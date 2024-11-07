import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mywebapp/pages/custom_widgets/custom_webview.dart';
import 'package:mywebapp/pages/custom_widgets/custom_widget.dart';
import 'package:mywebapp/pages/drawer_pages/home_screen_image_scroller.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((v) {
    runApp(const MyApp());
  });
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.system,
            home: const MyHomePage(),
          )
        : WebViewPage(url: 'https://google.com');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  late double screenWidth;
  late double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        height: screenHeight,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.2,
              child: AutoImageChangerWidget(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.8),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(200),
                        ),
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: screenWidth < 600 ? 3 : 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        children: [
                          itemDashboard(
                            'Student Portal',
                            'StudentPortal',
                            Icons.school_rounded,
                            Theme.of(context).colorScheme.primary,
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.blue,
                            ),
                          ),
                          itemDashboard(
                            'Dormitory',
                            'Dormitory',
                            CupertinoIcons.building_2_fill,
                            Colors.greenAccent,
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.blue,
                            ),
                          ),
                          itemDashboard(
                            'Exit Exam',
                            'ExitExam',
                            CupertinoIcons.text_badge_star,
                            Colors.purple,
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.blue,
                            ),
                          ),
                          itemDashboard(
                            'E-learning',
                            'Elearning',
                            CupertinoIcons.book_fill,
                            Colors.brown,
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.blue,
                            ),
                          ),
                          itemDashboard(
                            'Registrar Office',
                            'Registrar',
                            Icons.admin_panel_settings_outlined,
                            Colors.indigo,
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.blue,
                            ),
                          ),
                          itemDashboard(
                            'Freshman Program',
                            'Freshman',
                            Icons.houseboat_outlined,
                            Colors.teal,
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.blue,
                            ),
                          ),
                          itemDashboard(
                            'Placement',
                            'Placement',
                            CupertinoIcons.person_crop_circle_badge_checkmark,
                            Colors.blue,
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.blue,
                            ),
                          ),
                          itemDashboard(
                            'Registration',
                            'Registration',
                            CupertinoIcons.add_circled_solid,
                            Colors.pinkAccent,
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.blue,
                            ),
                          ),
                          itemDashboard(
                            'Academic Calendar',
                            'Calendar',
                            CupertinoIcons.calendar,
                            Colors.pinkAccent,
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 0),
                ],
              ),
            ),
            Container(
              color: Theme.of(context).cardColor.withOpacity(0.1),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'SOCIAL MEDIA',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    const SizedBox(height: 0),
                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      children: [
                        IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.twitter,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _launchURL('https://twitter.com/haramayauniver4');
                          },
                        ),
                        IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.telegram,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _launchURL('https://t.me/hufmp');
                          },
                        ),
                        IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.youtube,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () {
                            _launchURL(
                                'https://www.youtube.com/@haramayauniversity1295');
                          },
                        ),
                        IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.facebook,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _launchURL(
                                'https://www.facebook.com/profile.php?id=100063738112856');
                          },
                        ),
                        SizedBox(
                          height: 60,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      launchUrl(Uri.parse(url));
    }
  }

  Widget itemDashboard(String title, String routes, IconData iconData,
      Color background, Icon trailing) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              switch (routes) {
                case 'StudentPortal':
                  return const CustomWebView(
                      url: 'http://studentportal.haramaya.edu.et/');
                case 'Dormitory':
                  return const CustomWebView(
                    url: 'http://dormitoryps.haramaya.edu.et/DormSearch.aspx',
                  );
                case 'ExitExam':
                  return const CustomWebView(
                      url: 'https://exit.haramaya.edu.et/');
                case 'Elearning':
                  return const CustomWebView(
                      url:
                          'http://huelearning.haramaya.edu.et/login/index.php');
                case 'Registrar':
                  return const CustomWebView(
                      url:
                          'https://www.haramaya.edu.et/registrar-directorate/');
                case 'Freshman':
                  return const CustomWebView(
                      url: 'https://www.haramaya.edu.et/freshmandirectorate/');
                case 'Placement':
                  return const CustomWebView(
                      url: 'http://placementportal.haramaya.edu.et');
                case 'Registration':
                  return const CustomWebView(
                      url: 'https://isimsregistrar.haramaya.edu.et');
                case 'Calendar':
                  return CustomWebView(
                      url: 'https://www.haramaya.edu.et/academic-calendar-2/');
                default:
                  return const Center(
                    child: Text('Unable to find Resources'),
                  );
              }
            },
          ),
        );
      },
      child: Container(
        height: screenHeight,
        margin: const EdgeInsets.all(5),
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(1, 5),
              color: Theme.of(context).primaryColor.withOpacity(.3),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: MediaQuery.of(context).size.height * 0.055,
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 5),
            Text(
              title.trim(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 5),
            trailing,
          ],
        ),
      ),
    );
  }
}
