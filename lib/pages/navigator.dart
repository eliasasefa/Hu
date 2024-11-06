import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mywebapp/pages/drawer_pages/about_us.dart';
import 'package:mywebapp/pages/drawer_pages/campuses.dart';
import 'package:mywebapp/pages/drawer_pages/developer_profile.dart';
import '../theme/theme_provider.dart';
import '../theme/themes.dart';

class NavBar extends StatefulWidget {
  final Function(int) onMenuItemClicked;

  const NavBar({super.key, required this.onMenuItemClicked});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueGrey,
      child: ListView(
        padding: EdgeInsets.all(2),
        children: [
          const UserAccountsDrawerHeader(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            accountName: Text('Haramaya University'),
            accountEmail: Text('haramaya@haramaya.edu.et'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image(
                  alignment: Alignment.center,
                  image: AssetImage('assets/images/hu1-logo.png'),
                ),
              ),
            ),
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            tileColor: Color.fromARGB(255, 73, 71, 71),
            iconColor: Colors.blue,
            leading: const Icon(Icons.person_3_rounded),
            title: const Text(
              'About',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
              widget.onMenuItemClicked(0);
            },
          ),
          SizedBox(
            height: 5,
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            tileColor: Color.fromARGB(255, 73, 71, 71),
            iconColor: Colors.blue,
            leading: const FaIcon(FontAwesomeIcons.buildingColumns),
            title: const Text(
              'Campuses',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CampusesPage()),
              );
              widget.onMenuItemClicked(1);
            },
          ),
          SizedBox(
            height: 5,
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            tileColor: Color.fromARGB(255, 73, 71, 71),
            iconColor: Colors.blue,
            leading: const Icon(Icons.person_2_outlined),
            //const Image(image: AssetImage('assets/images/profile.jpg')),
            title: const Text(
              'Developer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeveloperProfile()),
              );
            },
          ),
          const Divider(color: Colors.white54),
          // Add Dark/Light Mode Switch
          GetBuilder<ThemeController>(
            builder: (controller) => SwitchListTile(
              title: Text(
                controller.isLightMode ? "Light Mode" : "Dark Mode",
                style: TextStyle(color: Colors.white),
              ),
              value: controller.isLightMode,
              activeColor: Colors.blue,
              onChanged: (value) {
                controller.updateThemeMode(
                  value ? ThemeModeType.light : ThemeModeType.dark,
                );
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
