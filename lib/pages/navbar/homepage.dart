import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mywebapp/pages/custom_widgets/custom_webview.dart';
import 'package:mywebapp/pages/drawer_pages/home_screen_image_scroller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mywebapp/pages/exit_exam/exam_center.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header/Image Section
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: screenHeight * 0.18,
                      child: AutoImageChangerWidget(),
                    ),
                  ),
                ),
                // Dashboard Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 2;
                    if (constraints.maxWidth > 900) {
                      crossAxisCount = 4;
                    } else if (constraints.maxWidth > 600) {
                      crossAxisCount = 3;
                    }
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.95,
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
                          'Old Portal',
                          'OldPortal',
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
                    );
                  },
                ),
                const SizedBox(height: 18),
                // Social Media Section
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 8.0),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'SOCIAL MEDIA',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 18,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              Tooltip(
                                message: 'Twitter',
                                child: IconButton(
                                  icon: const FaIcon(
                                    FontAwesomeIcons.twitter,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    _launchURL(
                                        'https://twitter.com/haramayauniver4');
                                  },
                                ),
                              ),
                              Tooltip(
                                message: 'Telegram',
                                child: IconButton(
                                  icon: const FaIcon(
                                    FontAwesomeIcons.telegram,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    _launchURL('https://t.me/hufmp');
                                  },
                                ),
                              ),
                              Tooltip(
                                message: 'YouTube',
                                child: IconButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.youtube,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  onPressed: () {
                                    _launchURL(
                                        'https://www.youtube.com/@haramayauniversity1295');
                                  },
                                ),
                              ),
                              Tooltip(
                                message: 'Facebook',
                                child: IconButton(
                                  icon: const FaIcon(
                                    FontAwesomeIcons.facebook,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    _launchURL(
                                        'https://www.facebook.com/profile.php?id=100063738112856');
                                  },
                                ),
                              ),
                            ],
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
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      launchUrl(Uri.parse(url));
    }
  }

  Widget itemDashboard(String title, String routes, IconData iconData,
      Color background, Icon trailing) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              switch (routes) {
                case 'StudentPortal':
                  return const CustomWebView(
                      url: 'http://isimsregistrar.haramaya.edu.et/');
                case 'OldPortal':
                  return const CustomWebView(
                      url: 'http://studentportal.haramaya.edu.et/');
                case 'Dormitory':
                  return const CustomWebView(
                    url: 'http://dormitoryps.haramaya.edu.et/DormSearch.aspx',
                  );
                case 'ExitExam':
                  return const ExamCenterPage();
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
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: Colors.white, size: 26),
              ),
              const SizedBox(height: 8),
              Text(
                title.trim(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 15,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
