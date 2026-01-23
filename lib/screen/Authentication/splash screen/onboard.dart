import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../widgets/constant.dart';
import '../welcome_screen.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({
    Key? key,
  }) : super(key: key);

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;

  // Onboarding data - can be loaded from API/JSON
  List<Map<String, dynamic>> onboardingData = [
    {
      "image": 'assets/onBorder0.png',
      "title": 'Réservez maintenant\net payez sur place',
    },
    {
      "image": 'assets/onBorder1.png',
      "title": 'Trouvez les meilleurs\nvols au meilleur prix',
    },
    {
      "image": 'assets/onBorder2.png',
      "title": 'Voyagez en toute\nsérénité',
    },
  ];

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  ),
                  child: Text(
                    'Passer',
                    style: GoogleFonts.poppins(
                      color: kSubTitleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),

            // PageView content
            Expanded(
              child: PageView.builder(
                itemCount: onboardingData.length,
                controller: pageController,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndexPage = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      // Main image
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Image.asset(
                            onboardingData[i]['image'],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: kSecondaryColor,
                                child: const Center(
                                  child: Icon(Icons.image, size: 100, color: kSubTitleColor),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Page indicator dots
                      SmoothPageIndicator(
                        controller: pageController,
                        count: onboardingData.length,
                        axisDirection: Axis.horizontal,
                        effect: ExpandingDotsEffect(
                          spacing: 6.0,
                          radius: 10.0,
                          dotWidth: 8.0,
                          dotHeight: 8.0,
                          paintStyle: PaintingStyle.fill,
                          dotColor: kSubTitleColor.withOpacity(0.3),
                          activeDotColor: kPrimaryColor,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Logo
                      Image.asset(
                        'assets/h24_logo.png',
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'H24',
                                  style: GoogleFonts.poppins(
                                    color: kTitleColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Voyages',
                                  style: GoogleFonts.poppins(
                                    color: kPrimaryColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                TextSpan(
                                  text: '.com',
                                  style: GoogleFonts.poppins(
                                    color: kTitleColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 4),

                      // Tagline
                      Text(
                        'À vous de fixer l\'heure',
                        style: GoogleFonts.poppins(
                          color: kPrimaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          onboardingData[i]['title'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: kTitleColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ),

                      const Spacer(),
                    ],
                  );
                },
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 50),
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                ),
                // onTap: () {
                //   // if (currentIndexPage < onboardingData.length - 1) {
                //   //   pageController.nextPage(
                //   //     duration: const Duration(milliseconds: 300),
                //   //     curve: Curves.easeInOut,
                //   //   );
                //   // } else {
                //   //   Navigator.pushReplacement(
                //   //     context,
                //   //     MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                //   //   );
                //   // }
                // },
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Continuer',
                      style: GoogleFonts.poppins(
                        color: kWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
