import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(DeveloperProfile());
}

class DeveloperProfile extends StatefulWidget {
  @override
  State<DeveloperProfile> createState() => _DeveloperProfileState();
}

class _DeveloperProfileState extends State<DeveloperProfile> {
  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          foregroundColor: Colors.white,
          toolbarHeight: 40.0,
          titleTextStyle: const TextStyle(
            fontFamily: 'verdana',
            fontSize: 16.0,
          ),
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
          title: const Text(
            'Elias Asefa',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              SizedBox(height: 15),
              Text(
                'Elias Asefa',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Software Developer',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(240, 91, 6, 1),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'A passionate Software developer eager to build mobile applications. \nI enjoy learning new technologies and solving challenging problems. Software Engineering Student @haramaya university(4th year.)',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey[900],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Skills',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Chip(
                      backgroundColor: Colors.green[50],
                      label: Text('Flutter')),
                  Chip(backgroundColor: Colors.green[50], label: Text('Dart')),
                  Chip(
                      backgroundColor: Colors.green[50],
                      label: Text('Bootstrap')),
                  Chip(
                      backgroundColor: Colors.green[50],
                      label: Text('React.js')),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Contact Information',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildContactInfoWidget(
                icon: Icons.email,
                text: 'eliasasefa3@gmail.com',
                onTap: () {
                  launchUrl(Uri.parse('mailto:eliasasefa3@gmail.com'));
                },
              ),
              _buildContactInfoWidget(
                icon: Icons.phone,
                text: '+251931690612',
                onTap: () {
                  launchUrl(Uri.parse('tel:+251931690612'));
                },
              ),
              SizedBox(height: 10),
              Text(
                'Follow Me on Social Media',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.linkedin,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _launchURL('https://www.linkedin.com/in/eliasasefa3/');
                    },
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.telegram,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _launchURL('https://t.me/eliasasefa3');
                    },
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.github,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _launchURL('https://github.com/eliasasefa');
                    },
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.facebook,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _launchURL('https://www.facebook.com/elias.asefa.940');
                    },
                  ),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfoWidget({
    required IconData icon,
    required String text,
    required Function() onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
