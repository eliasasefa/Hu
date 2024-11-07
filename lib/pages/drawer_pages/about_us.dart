import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AboutPage(),
  ));
}

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Haramaya University'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Image.asset(
              'assets/images/hu1-logo.png',
              width: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Section(
                title: 'Our History',
                content:
                    'Founded in 1954, Haramaya University has a proud legacy of providing quality education and fostering a culture of excellence in teaching, research, and community engagement. Over the years, we have evolved into a premier institution of higher learning in Ethiopia, with a commitment to advancing knowledge and addressing societal challenges.',
              ),
              Section(
                title: 'Academic Excellence',
                content:
                    'At Haramaya University, we offer a diverse range of undergraduate, postgraduate, and doctoral programs across various disciplines. Our esteemed faculty members are dedicated to nurturing the next generation of leaders and innovators through rigorous academic training and research mentorship.',
              ),
              Section(
                title: 'Research and Innovation',
                content:
                    'Research is at the heart of our mission at Haramaya University. Our scholars engage in cutting-edge research across fields such as agriculture, health sciences, engineering, social sciences, and humanities. Through collaboration and innovation, we strive to generate new knowledge, solve complex problems, and make meaningful contributions to sustainable development.',
              ),
              Section(
                title: 'Community Engagement',
                content:
                    'Haramaya University is deeply committed to serving our local and global communities. Through outreach programs, partnerships with industry and government agencies, and initiatives aimed at addressing societal needs, we seek to create positive change and empower individuals to reach their full potential.',
              ),
              Section(
                title: 'Our Vision',
                content:
                    'To be a leading center of academic excellence, research innovation, and community development in Ethiopia and beyond.',
              ),
              Section(
                title: 'Our Mission',
                content:
                    'To provide quality education, conduct impactful research, and foster holistic development for the betterment of society.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final String content;

  const Section({
    required this.title,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
