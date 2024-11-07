import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: CampusesPage(),
  ));
}

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haramaya University Campuses'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: campuses.length,
        itemBuilder: (context, index) {
          final campus = campuses[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: Image.asset(
                campus.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              title: Text(campus.name,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(campus.address),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CampusDetailPage(campus: campus),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CampusDetailPage extends StatelessWidget {
  final Campus campus;

  const CampusDetailPage({Key? key, required this.campus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(campus.name),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                campus.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                campus.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                campus.address,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Text(
                campus.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
