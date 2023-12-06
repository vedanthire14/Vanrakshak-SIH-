// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:vanrakshak/screens/authScreens/loginScreen.dart';

class MyLiquidSwipe extends StatelessWidget {
  final PageController _pageController = PageController();
  final List<Widget> pages = [
    const PageContent(
      imagePath: 'assets/main/logo.png',
      title: 'Welcome',
      titleColor: Color.fromARGB(255, 61, 73, 80),
      Paragraph: "Protect-Preserve-Prosper",
      fit: BoxFit.contain,
      backgroundImagePath: 'assets/introScreen/introbackground.png',
      currentPage: 0,
      totalPage: 4,
    ),
    const PageContent(
      imagePath: 'assets/introScreen/treelogo.png',
      title: 'Tree Enumeration',
      titleColor: Color.fromARGB(255, 61, 73, 80),
      // showButton: false,
      showSkipButton: true,
      Paragraph: "Enumerating the forest's tree population",
      fit: BoxFit.fitHeight,
      backgroundImagePath: 'assets/introScreen/introbackground2.png',
      currentPage: 1,
      totalPage: 4,
    ),
    const PageContent(
      imagePath: 'assets/introScreen/earthsat5.png',
      title: 'Satellite Imagery',
      titleColor: Color.fromARGB(255, 61, 73, 80),
      showButton: false,
      showSkipButton: true,
      Paragraph: "Drop Location- Define Area- Develop Future.",
      fit: BoxFit.contain,
      backgroundImagePath: 'assets/introScreen/introbackground3.png',
      currentPage: 2,
      totalPage: 4,
    ),
    const PageContent(
      imagePath: 'assets/introScreen/dashlogo.png',
      title: 'Dashboard',
      titleColor: Color.fromARGB(255, 61, 73, 80),
      Paragraph: "Analyze - Understand - Act",
      showButton: true,
      fit: BoxFit.fitHeight,
      backgroundImagePath: 'assets/introScreen/introbackground4.png',
      currentPage: 3,
      totalPage: 4,
    ),
  ];

  MyLiquidSwipe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          children: pages,
        ),
      ),
    );
  }
}

class PageContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final Color titleColor;
  final bool showButton;
  final bool showSkipButton;
  final VoidCallback? onSkipPressed;
  final String Paragraph;
  final BoxFit? fit;
  final String backgroundImagePath;
  final int currentPage;
  final int totalPage;

  const PageContent({super.key, 
    required this.imagePath,
    required this.title,
    required this.titleColor,
    this.showButton = false,
    this.showSkipButton = false,
    this.onSkipPressed,
    required this.Paragraph,
    this.fit,
    required this.backgroundImagePath,
    required this.currentPage,
    required this.totalPage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            backgroundImagePath,
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  imagePath,
                  height: 200,
                  width: 300,
                  fit: fit,
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(
                height: 20,
                child: Divider(
                  thickness: 0.5,
                  color: Colors.black,
                  indent: 40,
                  endIndent: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                Paragraph,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 55, 111, 77),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 60),
              (showButton)
                  ? SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 55,
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  totalPage,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == currentPage
                          ? Colors.teal // Active dot color
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showSkipButton)
          Positioned(
            top: 50,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Skip >',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 55, 111, 77),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
