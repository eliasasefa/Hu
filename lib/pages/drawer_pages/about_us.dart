import 'package:flutter/material.dart';

void main() {
  runApp(AboutPage());
}

class AboutPage extends StatelessWidget {
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
          actions: [
            IconButton(
                icon: const Image(
                  image: AssetImage('assets/images/hu1-logo.png'),
                ),
                onPressed: () {}),
            const SizedBox(
              width: 15,
            )
          ],
          foregroundColor: Colors.white,
          toolbarHeight: 40.0,
          titleTextStyle: const TextStyle(
            fontFamily: 'verdana',
            fontSize: 16.0,
          ),
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
          title: const Text(
            'Haramaya University',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader('Our History'),
                SizedBox(height: 8),
                SectionContent(
                  'Founded in 1954, Haramaya University has a proud legacy of providing quality education and fostering a culture of excellence in teaching, research, and community engagement. Over the years, we have evolved into a premier institution of higher learning in Ethiopia, with a commitment to advancing knowledge and addressing societal challenges.',
                ),
                SizedBox(height: 16),
                SectionHeader('Academic Excellence'),
                SizedBox(height: 8),
                SectionContent(
                  'At Haramaya University, we offer a diverse range of undergraduate, postgraduate, and doctoral programs across various disciplines. Our esteemed faculty members are dedicated to nurturing the next generation of leaders and innovators through rigorous academic training and research mentorship.',
                ),
                SizedBox(height: 16),
                SectionHeader('Research and Innovation'),
                SizedBox(height: 8),
                SectionContent(
                  'Research is at the heart of our mission at Haramaya University. Our scholars engage in cutting-edge research across fields such as agriculture, health sciences, engineering, social sciences, and humanities. Through collaboration and innovation, we strive to generate new knowledge, solve complex problems, and make meaningful contributions to sustainable development.',
                ),
                SizedBox(height: 16),
                SectionHeader('Community Engagement'),
                SizedBox(height: 8),
                SectionContent(
                  'Haramaya University is deeply committed to serving our local and global communities. Through outreach programs, partnerships with industry and government agencies, and initiatives aimed at addressing societal needs, we seek to create positive change and empower individuals to reach their full potential.',
                ),
                SizedBox(height: 16),
                SectionHeader('Our Vision'),
                SizedBox(height: 8),
                SectionContent(
                  'To be a leading center of academic excellence, research innovation, and community development in Ethiopia and beyond.',
                ),
                SizedBox(height: 16),
                SectionHeader('Our Mission'),
                SizedBox(height: 8),
                SectionContent(
                  'To provide quality education, conduct impactful research, and foster holistic development for the betterment of society.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class SectionContent extends StatelessWidget {
  final String content;

  SectionContent(this.content);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Text(content),
    );
  }
}
