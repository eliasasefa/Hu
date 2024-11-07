// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:mywebapp/pages/drawer_pages/about_us.dart';
// import 'package:mywebapp/pages/drawer_pages/campuses.dart';
// import 'package:mywebapp/pages/drawer_pages/developer_profile.dart';

// class NavBar extends StatelessWidget {
//   final Function(int) onMenuItemClicked;
//   final VoidCallback toggleTheme;

//   const NavBar(
//       {super.key, required this.onMenuItemClicked, required this.toggleTheme});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Colors.blueGrey,
//       child: ListView(
//         padding: EdgeInsets.all(2),
//         children: [
//           const UserAccountsDrawerHeader(
//             margin: EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               color: Colors.blueGrey,
//             ),
//             accountName: Text('Haramaya University'),
//             accountEmail: Text('haramaya@haramaya.edu.et'),
//             currentAccountPicture: CircleAvatar(
//               child: ClipOval(
//                 child: Image(
//                   alignment: Alignment.center,
//                   image: AssetImage('assets/images/hu1-logo.png'),
//                 ),
//               ),
//             ),
//           ),
//           ListTile(
//             trailing: Icon(Icons.arrow_forward),
//             contentPadding:
//                 EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//             tileColor: Color.fromARGB(255, 73, 71, 71),
//             iconColor: Colors.blue,
//             leading: const Icon(Icons.person_3_rounded),
//             title: const Text(
//               'About',
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => AboutPage()),
//               );
//               onMenuItemClicked(0);
//             },
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           ListTile(
//             trailing: Icon(Icons.arrow_forward),
//             contentPadding:
//                 EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//             tileColor: Color.fromARGB(255, 73, 71, 71),
//             iconColor: Colors.blue,
//             leading: const FaIcon(FontAwesomeIcons.buildingColumns),
//             title: const Text(
//               'Campuses',
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => CampusesPage()),
//               );
//               onMenuItemClicked(1);
//             },
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           ListTile(
//             trailing: Icon(Icons.arrow_forward),
//             contentPadding:
//                 EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//             tileColor: Color.fromARGB(255, 73, 71, 71),
//             iconColor: Colors.blue,
//             leading: const Icon(Icons.person_2_outlined),
//             title: const Text(
//               'Developer',
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => DeveloperProfile()),
//               );
//             },
//           ),
//           const Divider(color: Colors.white54),
//           IconButton(
//             icon: Icon(
//               Theme.of(context).brightness == Brightness.light
//                   ? Icons.brightness_7
//                   : Icons.brightness_3,
//             ),
//             onPressed: toggleTheme,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mywebapp/pages/drawer_pages/about_us.dart';
import 'package:mywebapp/pages/drawer_pages/campuses.dart';
import 'package:mywebapp/pages/drawer_pages/developer_profile.dart';

class NavBar extends StatelessWidget {
  final Function(int) onMenuItemClicked;
  final VoidCallback toggleTheme;

  const NavBar({
    super.key,
    required this.onMenuItemClicked,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(color: theme.primaryColor),
            accountName: const Text(
              'Haramaya University',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text('haramaya@haramaya.edu.et'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/hu1-logo.png'),
            ),
          ),
          _buildNavItem(
            context,
            icon: Icons.info,
            label: 'About',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
              onMenuItemClicked(0);
            },
          ),
          _buildNavItem(
            context,
            icon: FontAwesomeIcons.buildingColumns,
            label: 'Campuses',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CampusesPage()),
              );
              onMenuItemClicked(1);
            },
          ),
          _buildNavItem(
            context,
            icon: Icons.person,
            label: 'Developer',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeveloperProfile()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              theme.brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: theme.iconTheme.color,
            ),
            title: const Text('Toggle Theme'),
            onTap: toggleTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      title: Text(label),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    );
  }
}
