import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/screens/homescreen/home_screen.dart';

class Onboardingscreen extends StatefulWidget {
  const Onboardingscreen({super.key});

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen> {
  final controller = LiquidController();
  int currentPage = 0;

  final List<Map<String, dynamic>> weatherPages = [
    {
      'gradientColors': [Colors.orangeAccent, Colors.blueAccent],
      'lottiePath': 'assets/sunny.json',
      'title': 'Sunny Weather',
      'description':
          'Enjoy the sunny weather with a cup of coffee with your partner or friends/family.',
      'titleColor': Color.fromARGB(255, 236, 230, 47),
      'progress': '1/4',
    },
    {
      'gradientColors': [Color.fromARGB(255, 0, 0, 0), Colors.blueAccent],
      'lottiePath': 'assets/cloudy.json',
      'title': 'Cloudy Weather',
      'description':
          'Enjoy the cloudy weather with a cup of tea with your partner or friends/family.',
      'titleColor': Color.fromARGB(255, 252, 252, 56),
      'progress': '2/4',
    },
    {
      'gradientColors': [
        Color.fromARGB(255, 0, 5, 8),
        Color.fromARGB(255, 64, 84, 145)
      ],
      'lottiePath': 'assets/rain.json',
      'title': 'Rainy Weather',
      'description':
          'Enjoy the rainy weather with a plate of bhajiya with your partner or friends/family.',
      'titleColor': Color.fromARGB(255, 101, 174, 235),
      'progress': '3/4',
    },
    {
      'gradientColors': [Color.fromARGB(255, 53, 121, 247), Colors.white],
      'lottiePath': 'assets/snowfall.json',
      'title': 'Snowy Weather',
      'description':
          'Enjoy the snowfall with burning woods with your partner or friends/family.',
      'titleColor': Color.fromARGB(162, 0, 0, 0),
      'progress': '4/4',
    },
  ];

  bool? canChange = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    canChange = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    canChange = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            pages: weatherPages.map((page) {
              return buildPage(
                gradientColors: page['gradientColors'],
                lottiePath: page['lottiePath'],
                title: page['title'],
                description: page['description'],
                titleColor: page['titleColor'],
                progress: page['progress'],
              );
            }).toList(),
            onPageChangeCallback: onPageChangeCallback,
            liquidController: controller,
            slideIconWidget: const Icon(Icons.arrow_back_ios),
            enableSideReveal: true,
          ),
          Positioned(
            bottom: 60,
            child: IconButton(
              onPressed: () {
                int nextPage = controller.currentPage + 1;
                controller.animateToPage(page: nextPage);
              },
              icon: const Icon(
                size: 38,
                Icons.arrow_forward_rounded,
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MyHomeScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: AnimatedSmoothIndicator(
              activeIndex: controller.currentPage,
              count: weatherPages.length,
              effect: const WormEffect(
                activeDotColor: Colors.black,
                dotHeight: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage({
    required List<Color> gradientColors,
    required String lottiePath,
    required String title,
    required String description,
    required Color titleColor,
    required String progress,
  }) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Lottie.asset(lottiePath),
            ),
            Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Text(
              progress,
              style: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(103, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void onPageChangeCallback(int activePageIndex) {
    if(canChange == true){
      setState(() {
        currentPage = activePageIndex;
      });
    }
  }
}
