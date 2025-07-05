import 'package:flutter/material.dart';

class Campus {
  final String name;
  final String imageUrl;
  final String address;
  final String description;

  const Campus({
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.description,
  });
}

class CampusesPage extends StatelessWidget {
  const CampusesPage({Key? key}) : super(key: key);

  static const List<Campus> campuses = [
    Campus(
      name: 'Main Campus',
      imageUrl: 'assets/images/HrU-Main-Gate.png',
      address: 'Haramaya University, Main Campus, Haramaya, Ethiopia',
      description:
          'The Main Campus of Haramaya University is a vibrant hub of academic excellence nestled in the heart of Haramaya, Ethiopia. With its sprawling grounds and iconic main gate, it serves as the nucleus of the university, offering a diverse range of educational programs and research opportunities. Surrounded by lush greenery, the Main Campus provides a serene environment conducive to learning and innovation. It is home to state-of-the-art facilities, including modern classrooms, research laboratories, and libraries, fostering an enriching academic experience for students and faculty alike.',
    ),
    Campus(
      name: 'Station Campus (VET)',
      imageUrl: 'assets/images/cvm-gate.jpg',
      address: 'Haramaya University, Station Campus, Haramaya, Ethiopia',
      description:
          'The Station Campus, home to the Veterinary Medicine program at Haramaya University, is dedicated to the advancement of animal health and welfare in Ethiopia. Situated in Haramaya, Ethiopia, this campus boasts state-of-the-art veterinary teaching hospitals, diagnostic laboratories, and research centers. Students enrolled in the Veterinary Medicine program benefit from hands-on training opportunities and mentorship from experienced faculty members. The Station Campus also collaborates closely with local farmers and veterinary practitioners to address emerging issues in livestock management and disease prevention, making a significant impact on agriculture and animal husbandry practices in the region.',
    ),
    Campus(
      name: 'Gendeje Campus (HiT)',
      imageUrl: 'assets/images/HIt-Dorm.jpg',
      address: 'Haramaya University, Haramaya, Ethiopia',
      description:
          'The Gendeje Campus, also known as the HiT (Haramaya Institute of Technology) Campus, is a center of technological innovation and engineering excellence within Haramaya University. Located in Haramaya, Ethiopia, this campus is renowned for its cutting-edge research facilities and multidisciplinary approach to engineering education. From computer science to electrical engineering, HiT offers a diverse array of undergraduate and graduate programs designed to meet the evolving demands of the technology industry. With a focus on practical learning and industry partnerships, the Gendeje Campus prepares students to tackle real-world challenges and drive technological innovation in Ethiopia and beyond.',
    ),
    Campus(
      name: 'Health Campus',
      imageUrl: 'assets/images/Health-center.png',
      address: 'Haramaya University, Harar, Ethiopia',
      description:
          'The Health Campus of Haramaya University is dedicated to the advancement of healthcare education and research in Ethiopia. Situated in Harar, Ethiopia, this campus plays a pivotal role in training the next generation of healthcare professionals and promoting community health initiatives. Equipped with modern medical facilities and simulation labs, the Health Campus offers comprehensive programs in medicine, nursing, and public health. Its strategic location facilitates collaboration with local healthcare institutions, enabling students to gain hands-on experience and make meaningful contributions to healthcare delivery in the region.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage('assets/images/hu1-logo.png'),
              radius: 16,
              backgroundColor: theme.colorScheme.surface,
            ),
            const SizedBox(width: 10),
            Text(
              'Campuses',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [theme.colorScheme.surface, theme.colorScheme.background]
                : [
                    theme.colorScheme.primary.withOpacity(0.07),
                    theme.colorScheme.background
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            itemCount: campuses.length,
            itemBuilder: (context, index) {
              final campus = campuses[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CampusDetailPage(campus: campus),
                    ),
                  );
                },
                child: Card(
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Hero(
                          tag: campus.imageUrl,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              campus.imageUrl,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      campus.name,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                campus.address,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.hintColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios,
                            color: theme.colorScheme.primary, size: 22),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CampusDetailPage extends StatelessWidget {
  final Campus campus;

  const CampusDetailPage({Key? key, required this.campus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          campus.name,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [theme.colorScheme.surface, theme.colorScheme.background]
                : [
                    theme.colorScheme.primary.withOpacity(0.07),
                    theme.colorScheme.background
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: campus.imageUrl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        campus.imageUrl,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            campus.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: theme.colorScheme.primary, size: 20),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  campus.address,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.hintColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Text(
                            campus.description,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(height: 1.5),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
