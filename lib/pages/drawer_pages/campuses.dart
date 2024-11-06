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

  const Campus({
    required this.name,
    required this.imageUrl,
    required this.address,
  });
}

class CampusesPage extends StatelessWidget {
  const CampusesPage({Key? key}) : super(key: key);

  // Example campus data
  static const List<Campus> campuses = [
    Campus(
      name: 'Main Campus',
      imageUrl: 'assets/images/HrU-Main-Gate.png',
      address: 'Haramaya University, Main Campus, Haramaya, Ethiopia',
    ),
    Campus(
      name: 'Station Campus(VET)',
      imageUrl: 'assets/images/cvm-gate.jpg',
      address:
          'Haramaya University, Station(Veterinary Medicine) Campus, Haramaya, Ethiopia',
    ),
    Campus(
      name: 'Gendeje Campus(HiT)',
      imageUrl: 'assets/images/HIt-Dorm.jpg',
      address: 'Haramaya University, Haramaya, Ethiopia',
    ),
    Campus(
      name: 'Health Campus',
      imageUrl: 'assets/images/Health-center.png',
      address: 'Haramaya University, Harar, Ethiopia',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
              //alignment: Alignment.topLeft,
              icon: const Image(
                image: AssetImage('assets/images/hu1-logo.png'),
              ),
              onPressed: () {}),
          const SizedBox(
            width: 5,
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
          'Haramaya University Campuses',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: campuses.length,
        itemBuilder: (context, index) {
          final campus = campuses[index];
          return Column(
            children: [
              ListTile(
                tileColor: Color.fromARGB(255, 73, 71, 71),
                textColor: Colors.white,
                iconColor: Colors.blue,
                trailing: Icon(Icons.arrow_forward),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                leading: Image(
                  filterQuality: FilterQuality.high,
                  alignment: Alignment.centerLeft,
                  image: AssetImage(
                    campus.imageUrl,
                  ),
                  height: 400,
                  fit: BoxFit.contain,
                ),
                title: Text(campus.name),
                subtitle: Text(campus.address),
                onTap: () {
                  switch (index) {
                    case 0:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainCampus()),
                      );
                      break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StationCampus()),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GendejeCampus()),
                      );
                      break;
                    case 3:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HealthCampus()),
                      );
                      break;
                    default:
                      break;
                  }
                },
              ),
              if (index != campuses.length - 1)
                SizedBox(
                  height: 5,
                ),
            ],
          );
        },
      ),
    );
  }
}

class MainCampus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Haramaya University Main Campus',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image(
                image: AssetImage('assets/images/main_gate.jpg'),
                fit: BoxFit.cover,
                width: 400,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 400,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                    shape: BoxShape.rectangle,
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Container(
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
                          'Main Campus',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            'The Main Campus of Haramaya University is a vibrant hub of academic excellence nestled in the heart of Haramaya, Ethiopia. With its sprawling grounds and iconic main gate, it serves as the nucleus of the university, offering a diverse range of educational programs and research opportunities. Surrounded by lush greenery, the Main Campus provides a serene environment conducive to learning and innovation. It is home to state-of-the-art facilities, including modern classrooms, research laboratories, and libraries, fostering an enriching academic experience for students and faculty alike.'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StationCampus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Haramaya University Station Campus',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image(
                image: AssetImage('assets/images/cvm-gate.jpg'),
                fit: BoxFit.cover,
                width: 400,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 400,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                    shape: BoxShape.rectangle,
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Container(
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
                          'Station(VET) Campus',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            'The Station Campus, home to the Veterinary Medicine program at Haramaya University, is dedicated to the advancement of animal health and welfare in Ethiopia. Situated in Haramaya, Ethiopia, this campus boasts state-of-the-art veterinary teaching hospitals, diagnostic laboratories, and research centers. Students enrolled in the Veterinary Medicine program benefit from hands-on training opportunities and mentorship from experienced faculty members. The Station Campus also collaborates closely with local farmers and veterinary practitioners to address emerging issues in livestock management and disease prevention, making a significant impact on agriculture and animal husbandry practices in the region.'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GendejeCampus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Haramaya University Gendeje Campus',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image(
                semanticLabel: 'Haramaya University Gendeje Campus',
                image: AssetImage('assets/images/HIt-Dorm.jpg'),
                fit: BoxFit.cover,
                width: 400,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 400,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                    shape: BoxShape.rectangle,
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Container(
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
                          'Gendeje(HiT) Campus',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            'The Gendeje Campus, also known as the HiT (Haramaya Institute of Technology) Campus, is a center of technological innovation and engineering excellence within Haramaya University. Located in Haramaya, Ethiopia, this campus is renowned for its cutting-edge research facilities and multidisciplinary approach to engineering education. From computer science to electrical engineering, HiT offers a diverse array of undergraduate and graduate programs designed to meet the evolving demands of the technology industry. With a focus on practical learning and industry partnerships, the Gendeje Campus prepares students to tackle real-world challenges and drive technological innovation in Ethiopia and beyond.'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HealthCampus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Haramaya University Health Campus',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image(
                image: AssetImage('assets/images/Health-center.png'),
                fit: BoxFit.cover,
                width: 400,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 400,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                    shape: BoxShape.rectangle,
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Container(
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
                          'Health Campus',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            'The Health Campus of Haramaya University is dedicated to the advancement of healthcare education and research in Ethiopia. Situated in Harar, Ethiopia, this campus plays a pivotal role in training the next generation of healthcare professionals and promoting community health initiatives. Equipped with modern medical facilities and simulation labs, the Health Campus offers comprehensive programs in medicine, nursing, and public health. Its strategic location facilitates collaboration with local healthcare institutions, enabling students to gain hands-on experience and make meaningful contributions to healthcare delivery in the region.'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
