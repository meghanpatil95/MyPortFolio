import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';

class ThemeNotifier extends ChangeNotifier {
  bool isDark = true;

  void toggle() {
    isDark = !isDark;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MeghanArchitectPortfolio(),
    ),
  );
}

class MeghanArchitectPortfolio extends StatefulWidget {
  const MeghanArchitectPortfolio({super.key});

  @override
  State<MeghanArchitectPortfolio> createState() =>
      _MeghanArchitectPortfolioState();
}

class _MeghanArchitectPortfolioState extends State<MeghanArchitectPortfolio> {
  late final theme = context.watch<ThemeNotifier>();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0066FF),
          onSurface: Color(0xFF111827),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF111827)),
          bodySmall: TextStyle(color: Color(0xFF374151)),
          titleLarge: TextStyle(color: Color(0xFF111827)),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF08080A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D2FF),
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
      ),

      home: const PortfolioCanvas(),
    );
  }
}

class PortfolioCanvas extends StatefulWidget {
  const PortfolioCanvas({super.key});

  @override
  State<PortfolioCanvas> createState() => _PortfolioCanvasState();
}

class _PortfolioCanvasState extends State<PortfolioCanvas>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  bool _showNavBar = true;
  bool _showMobileMenu = false;
  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showNavBar) {
        setState(() => _showNavBar = true);
      } else if (_scrollController.offset <= 300 && _showNavBar) {
        setState(() => _showNavBar = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    setState(() => _showMobileMenu = false);
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    return Scaffold(
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _buildHeroBanner(isMobile, isTablet),
                  _buildBentoStats(isMobile, isTablet),
                  sectionReveal(
                    delay: 100,
                    child: _buildAboutSection(isMobile, isTablet),
                  ),
                  sectionReveal(
                    delay: 100,
                    child: _buildDetailedTechStack(isMobile, isTablet),
                  ),
                  sectionReveal(
                    delay: 100,
                    child: _buildExperienceTimeline(isMobile, isTablet),
                  ),
                  sectionReveal(
                    delay: 100,
                    child: _buildProjectShowcase(isMobile, isTablet),
                  ),
                  sectionReveal(
                    delay: 100,
                    child: _buildEducationCerts(isMobile, isTablet),
                  ),
                  sectionReveal(
                    delay: 100,
                    child: _buildSkillsMatrix(isMobile, isTablet),
                  ),
                  sectionReveal(
                    delay: 100,
                    child: _buildAchievements(isMobile, isTablet),
                  ),
                  sectionReveal(
                    delay: 100,
                    child: _buildContactFooter(isMobile, isTablet),
                  ),
                ],
              ),
            ),
          ),
          if (_showNavBar) _buildFloatingNavBar(isMobile),
          if (isMobile) _buildMobileMenuButton(),
          _buildScrollToTopButton(),
        ],
      ),
    );
  }

  // Mobile Menu Button
  Widget _buildMobileMenuButton() {
    return Positioned(
      top: 20,
      right: 20,
      child: FadeInDown(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF00D2FF).withOpacity(0.3)),
          ),
          child: IconButton(
            onPressed: () => setState(() => _showMobileMenu = !_showMobileMenu),
            icon: Icon(
              _showMobileMenu ? Icons.close : Icons.menu,
              color: const Color(0xFF00D2FF),
            ),
          ),
        ),
      ),
    );
  }

  // Floating Navigation Bar
  Widget _buildFloatingNavBar(bool isMobile) {
    if (isMobile && _showMobileMenu) {
      return Positioned(
        top: 80,
        right: 20,
        child: FadeInDown(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.95),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color(0xFF00D2FF).withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                _navItemMobile("About", _aboutKey),
                _navItemMobile("Skills", _skillsKey),
                _navItemMobile("Experience", _experienceKey),
                _navItemMobile("Projects", _projectsKey),
                _navItemMobile("Education", _educationKey),
                _navItemMobile("Contact", _contactKey),
              ],
            ),
          ),
        ),
      );
    }

    if (isMobile) return const SizedBox.shrink();

    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: FadeInDown(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: const Color(0xFF00D2FF).withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D2FF).withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _navItem("About", _aboutKey),
                _navItem("Skills", _skillsKey),
                _navItem("Experience", _experienceKey),
                _navItem("Projects", _projectsKey),
                _navItem("Education", _educationKey),
                _navItem("Contact", _contactKey),
                IconButton(
                  tooltip: "Toggle theme",
                  onPressed: () => context.read<ThemeNotifier>().toggle(),
                  icon: Icon(
                    Icons.brightness_6,
                    color: const Color(0xFF00D2FF),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(String label, GlobalKey key) {
    return InkWell(
      onTap: () => _scrollToSection(key),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          label,
          style: GoogleFonts.robotoMono(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget sectionReveal({required Widget child, int delay = 0}) {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      delay: Duration(milliseconds: delay),
      curve: Curves.easeOutCubic,
      child: child,
    );
  }

  Widget subtleHover({required Widget child}) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 200),
        child: child,
      ),
    );
  }

  Widget _navItemMobile(String label, GlobalKey key) {
    return InkWell(
      onTap: () => _scrollToSection(key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Text(
          label,
          style: GoogleFonts.robotoMono(
            fontSize: 16,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Scroll to Top Button
  Widget _buildScrollToTopButton() {
    return Positioned(
      bottom: 30,
      right: 30,
      child:
          _showNavBar
              ? FadeInUp(
                child: FloatingActionButton(
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                    );
                  },
                  backgroundColor: const Color(0xFF00D2FF),
                  child: const Icon(Icons.arrow_upward, color: Colors.black),
                ),
              )
              : const SizedBox.shrink(),
    );
  }

  // Hero Banner
  Widget _buildHeroBanner(bool isMobile, bool isTablet) {
    return Container(
      height: isMobile ? 600 : 700,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00D2FF).withOpacity(0.15),
            Colors.purple.withOpacity(0.1),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          if (!isMobile)
            ...List.generate(30, (index) => _floatingParticle(index)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 1200),
                  child: AnimatedBuilder(
                    animation: _floatingController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 10 * _floatingController.value),
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.blueAccent, Colors.purpleAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: isMobile ? 60 : 90,
                        backgroundImage: const AssetImage('assets/meghan.jpeg'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeIn(
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    "MEGHAN M. PATIL",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.syncopate(
                      fontSize: isMobile ? 28 : (isTablet ? 40 : 56),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 15 : 30,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.blueAccent.withOpacity(0.3),
                      ),
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(milliseconds: 1500),
                      animatedTexts: [
                        TypewriterAnimatedText(
                          "Senior Flutter Developer & Technical Lead",
                          speed: const Duration(milliseconds: 80),
                          cursor: ".", // 🔥 blinking cursor
                          textAlign: TextAlign.center,
                          textStyle: GoogleFonts.robotoMono(
                            fontSize: isMobile ? 12 : 18,
                            color: Colors.blueAccent,
                            letterSpacing: isMobile ? 2 : 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                FadeInUp(
                  delay: const Duration(milliseconds: 1000),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white54,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Belagavi, Karnataka",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: isMobile ? 12 : 14,
                            ),
                          ),
                        ],
                      ),
                      /*Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.phone, color: Colors.white54, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            "+91 7795200057",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: isMobile ? 12 : 14,
                            ),
                          ),
                        ],
                      ),*/
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                FadeInUp(
                  delay: const Duration(milliseconds: 1200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialBtn(
                        FontAwesomeIcons.linkedin,
                        "https://linkedin.com/in/meghan-patil",
                      ),
                      _socialBtn(
                        FontAwesomeIcons.github,
                        "https://github.com/meghan5-at-github",
                      ),
                      _socialBtn(
                        FontAwesomeIcons.gitlab,
                        "https://gitlab.com/meghanpatil5",
                      ),
                      _socialBtn(
                        FontAwesomeIcons.envelope,
                        "mailto:meghanpatil95@gmail.com",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingParticle(int index) {
    return Positioned(
      left: (index * 47) % 400,
      top: (index * 71) % 600,
      child: Pulse(
        infinite: true,
        duration: Duration(milliseconds: 2000 + (index * 200)),
        child: Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  // Bento Stats
  Widget _buildBentoStats(bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 100),
        vertical: 50,
      ),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: isMobile ? 2 : 4,
        crossAxisSpacing: isMobile ? 10 : 20,
        mainAxisSpacing: isMobile ? 10 : 20,
        childAspectRatio: isMobile ? 1.2 : 1.5,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HoverStatCard(
            val: '15+',
            desc: 'Production Apps',
            icon: Icons.apps,
            isMobile: isMobile,
          ),
          HoverStatCard(
            val: '99.5%',
            desc: 'Crash-free Rate',
            icon: Icons.security,
            isMobile: isMobile,
          ),
          HoverStatCard(
            val: '7 Years',
            desc: 'Experience',
            icon: Icons.workspace_premium,
            isMobile: isMobile,
          ),
          HoverStatCard(
            val: '10+',
            desc: 'Developers Mentored',
            icon: Icons.people,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  // About Section
  Widget _buildAboutSection(bool isMobile, bool isTablet) {
    return Container(
      key: _aboutKey,
      padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 40 : 100)),
      color: Colors.white.withOpacity(0.02),
      child:
          isMobile || isTablet
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInLeft(
                    child: Text(
                      "PHILOSOPHY",
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInRight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "I specialize in architecting enterprise-grade mobile applications using advanced state management patterns like BLoC. My approach combines engineering precision with business value, integrating complex systems like SAP ERP, RFID technologies, and secure payment gateways (Stripe/Razorpay) to modernize legacy infrastructure.",
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 18,
                            height: 1.8,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildPhilosophyPoints(isMobile),
                      ],
                    ),
                  ),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: FadeInLeft(
                      child: const Text(
                        "PHILOSOPHY",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00D2FF),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: FadeInRight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "I specialize in architecting enterprise-grade mobile applications using advanced state management patterns like BLoC. My approach combines engineering precision with business value, integrating complex systems like SAP ERP, RFID technologies, and secure payment gateways (Stripe/Razorpay) to modernize legacy infrastructure.",
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.8,
                              color: Colors.grey[300],
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildPhilosophyPoints(false),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildPhilosophyPoints(bool isMobile) {
    final points = [
      {
        "icon": Icons.architecture,
        "text": "Clean Architecture & Scalable Design",
      },
      {"icon": Icons.security, "text": "Security-First Development"},
      {"icon": Icons.speed, "text": "Performance Optimization"},
      {"icon": Icons.group, "text": "Team Leadership & Mentoring"},
    ];

    return Column(
      children:
          points.map((point) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    point["icon"] as IconData,
                    color: const Color(0xFF00D2FF),
                    size: isMobile ? 16 : 20,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      point["text"] as String,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        // color: Colors.white70,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  // Tech Stack
  Widget _buildDetailedTechStack(bool isMobile, bool isTablet) {
    return Container(
      key: _skillsKey,
      padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 40 : 100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInLeft(
            child: Text(
              "TECHNICAL ARSENAL",
              style: TextStyle(
                fontSize: isMobile ? 24 : 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 50),
          _stackRow(
            "Mobile Development",
            [
              {"name": "Flutter", "url": "https://flutter.dev"},
              {"name": "Android SDK", "url": "https://developer.android.com"},
              {"name": "Dart", "url": "https://dart.dev"},
              {"name": "Swift", "url": "https://swift.org"},
              {"name": "BLoC Pattern", "url": "https://bloclibrary.dev"},
              {"name": "Provider", "url": "https://pub.dev/packages/provider"},
            ],
            isMobile,
            isTablet,
          ),
          _stackRow(
            "Languages",
            [
              {"name": "Java", "url": "https://www.oracle.com/java/"},
              {
                "name": "JavaScript",
                "url":
                    "https://developer.mozilla.org/en-US/docs/Web/JavaScript",
              },
              {"name": "Node.js", "url": "https://nodejs.org"},
              {"name": "C++", "url": "https://isocpp.org"},
              {
                "name": "HTML5",
                "url": "https://developer.mozilla.org/en-US/docs/Web/HTML",
              },
              {
                "name": "CSS",
                "url": "https://developer.mozilla.org/en-US/docs/Web/CSS",
              },
            ],
            isMobile,
            isTablet,
          ),
          _stackRow(
            "Cloud & Backend",
            [
              {"name": "Google Cloud", "url": "https://cloud.google.com"},
              {"name": "Firebase", "url": "https://firebase.google.com"},
              {"name": "MySQL", "url": "https://www.mysql.com"},
              {
                "name": "Firestore",
                "url": "https://firebase.google.com/products/firestore",
              },
              {"name": "REST APIs", "url": "https://restfulapi.net"},
            ],
            isMobile,
            isTablet,
          ),
          _stackRow(
            "Payment & Security",
            [
              {"name": "Stripe", "url": "https://stripe.com"},
              {"name": "Razorpay", "url": "https://razorpay.com"},
              {
                "name": "PCI DSS",
                "url": "https://www.pcisecuritystandards.org",
              },
              {
                "name": "AES-256",
                "url":
                    "https://en.wikipedia.org/wiki/Advanced_Encryption_Standard",
              },
            ],
            isMobile,
            isTablet,
          ),
          _stackRow(
            "Tools & DevOps",
            [
              {"name": "Git", "url": "https://git-scm.com"},
              {"name": "GitHub", "url": "https://github.com"},
              {
                "name": "Android Studio",
                "url": "https://developer.android.com/studio",
              },
              {"name": "VS Code", "url": "https://code.visualstudio.com"},
              {"name": "Postman", "url": "https://www.postman.com"},
              {
                "name": "JIRA",
                "url": "https://www.atlassian.com/software/jira",
              },
            ],
            isMobile,
            isTablet,
          ),
          _stackRow(
            "Specialized",
            [
              {
                "name": "SAP ERP",
                "url": "https://www.sap.com/products/erp.html",
              },
              {
                "name": "RFID Tech",
                "url":
                    "https://en.wikipedia.org/wiki/Radio-frequency_identification",
              },
              {"name": "QR Codes", "url": "https://www.qr-code-generator.com"},
              {
                "name": "Google Maps",
                "url": "https://developers.google.com/maps",
              },
            ],
            isMobile,
            isTablet,
          ),
        ],
      ),
    );
  }

  Widget _stackRow(
    String title,
    List<Map<String, String>> items,
    bool isMobile,
    bool isTablet,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child:
          isMobile || isTablet
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.robotoMono(
                      // color: const Color(0xFF00D2FF),
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 14 : 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        items.map((item) {
                          return _clickableSkillChip(
                            item["name"]!,
                            item["url"]!,
                            isMobile,
                          );
                        }).toList(),
                  ),
                ],
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      title,
                      style: GoogleFonts.robotoMono(
                        // color: const Color(0xFF00D2FF),
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                          items.map((item) {
                            return _clickableSkillChip(
                              item["name"]!,
                              item["url"]!,
                              false,
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
    );
  }

  /*Widget _clickableSkillChip(String name, String url, bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launch(url),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10 : 15,
            vertical: isMobile ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF00D2FF).withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.open_in_new,
                size: isMobile ? 10 : 12,
                color: const Color(0xFF00D2FF),
              ),
            ],
          ),
        ),
      ),
    );
  }*/

  Widget _clickableSkillChip(String name, String url, bool isMobile) {
    return _HoverSkillChip(name: name, url: url, isMobile: isMobile);
  }

  // Experience Timeline
  Widget _buildExperienceTimeline(bool isMobile, bool isTablet) {
    return Container(
      key: _experienceKey,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 100),
        vertical: 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInLeft(
            child: Text(
              "PROFESSIONAL JOURNEY",
              style: TextStyle(
                fontSize: isMobile ? 24 : 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 50),
          _timelineItem(
            "Senior Flutter Developer & Team Lead",
            "Ajinkya Technologies",
            "Jan 2023 - Present",
            [
              "Led 5-member engineering team delivering enterprise Flutter solutions",
              "Architected secure payment systems with Stripe & Razorpay integration",
              "Managed GCP infrastructure with auto-scaling and load balancing",
              "Built IoT platforms with RFID/QR scanner integration",
              "Mentored junior developers through code reviews and best practices",
            ],
            Icons.work,
            const Color(0xFF00D2FF),
            isMobile,
          ),
          _timelineItem(
            "Application Developer",
            "Motocross India Pvt. Ltd.",
            "Mar 2021 - Dec 2022",
            [
              "Developed bike rental marketplace with 10,000+ downloads",
              "Created garage management platform supporting 50+ partners",
              "Implemented GPS tracking and real-time location features",
              "Integrated multi-currency payment systems",
              "Set up Firebase services including authentication and Crashlytics",
            ],
            Icons.motorcycle,
            Colors.purple,
            isMobile,
          ),
          _timelineItem(
            "Programmer",
            "Acceltree Software Pvt. Ltd.",
            "Feb 2018 - Feb 2021",
            [
              "Built 10+ hybrid mobile applications using HTML5, JS, Angular",
              "Developed YAML-driven chatbot solution for customer engagement",
              "Created Java-based AES-256 encryption utility",
              "Implemented voice-controlled forms using Android Speech APIs",
              "Automated workflows using RPA tools",
            ],
            Icons.code,
            Colors.indigo,
            isMobile,
          ),
        ],
      ),
    );
  }

  Widget _timelineItem(
    String role,
    String company,
    String date,
    List<String> achievements,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 40 : 60),
      child: FadeInUp(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 2),
                    ),
                    child: Icon(icon, color: color, size: 30),
                  ),
                  Container(
                    width: 2,
                    height: 200,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ],
              ),
            SizedBox(width: isMobile ? 0 : 40),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isMobile)
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: color, width: 2),
                          ),
                          child: Icon(icon, color: color, size: 20),
                        ),
                      Expanded(
                        child: Text(
                          date,
                          style: GoogleFonts.robotoMono(
                            color: Colors.white24,
                            fontSize: isMobile ? 10 : 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    company,
                    style: TextStyle(
                      color: color,
                      fontSize: isMobile ? 14 : 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...achievements.map(
                    (achievement) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: isMobile ? 4 : 6,
                            height: isMobile ? 4 : 6,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              achievement,
                              style: TextStyle(
                                color: Colors.grey,
                                height: 1.5,
                                fontSize: isMobile ? 13 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Project Showcase
  Widget _buildProjectShowcase(bool isMobile, bool isTablet) {
    return Container(
      key: _projectsKey,
      padding: EdgeInsets.symmetric(
        vertical: 50,
        horizontal: isMobile ? 0 : (isTablet ? 20 : 0),
      ),
      child: Column(
        children: [
          Text(
            "FEATURED PROJECTS",
            style: TextStyle(
              fontSize: isMobile ? 24 : 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          _projectCard(
            "IoT Inventory Management System",
            "Enterprise platform integrating RFID readers and QR scanners for real-time inventory tracking across multiple warehouses",
            ["Flutter", "RFID", "QR Tech", "Node.js", "MySQL"],
            Colors.blue,
            Icons.inventory,
            isMobile,
            isTablet,
          ),
          _projectCard(
            "Secure Payment Gateway Integration",
            "Multi-payment processor architecture supporting Stripe and Razorpay with PCI DSS compliance and transaction monitoring",
            ["Flutter", "Stripe", "Razorpay", "PCI DSS", "Node.js"],
            Colors.green,
            Icons.payment,
            isMobile,
            isTablet,
          ),
          _projectCard(
            "GPS-Enabled Bike Rental Marketplace",
            "Full-stack rental platform with real-time GPS tracking, booking management, and multi-currency support (10,000+ downloads)",
            ["Flutter", "BLoC", "Firebase", "Google Maps", "GPS"],
            Colors.purple,
            Icons.pedal_bike,
            isMobile,
            isTablet,
          ),
          _projectCard(
            "Enterprise Garage Management System",
            "Scalable platform managing 50+ service partners with appointment scheduling, inventory tracking, and billing automation",
            ["Flutter", "Firebase", "Node.js", "SAP ERP", "REST API"],
            Colors.orange,
            Icons.build,
            isMobile,
            isTablet,
          ),
        ],
      ),
    );
  }

  Widget _projectCard(
    String title,
    String description,
    List<String> tech,
    Color color,
    IconData icon,
    bool isMobile,
    bool isTablet,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 100),
        vertical: 15,
      ),
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child:
          isMobile
              ? Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(icon, color: color, size: 30),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.grey,
                          height: 1.6,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children:
                            tech
                                .map(
                                  (t) => Chip(
                                    label: Text(
                                      t,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    backgroundColor: color.withOpacity(0.2),
                                    side: BorderSide(
                                      color: color.withOpacity(0.5),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ],
              )
              : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(icon, color: color, size: 40),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          description,
                          style: const TextStyle(
                            color: Colors.grey,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              tech
                                  .map(
                                    (t) => Chip(
                                      label: Text(
                                        t,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      backgroundColor: color.withOpacity(0.2),
                                      side: BorderSide(
                                        color: color.withOpacity(0.5),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  // Education & Certifications
  Widget _buildEducationCerts(bool isMobile, bool isTablet) {
    return Container(
      key: _educationKey,
      padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 40 : 100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "EDUCATION & CERTIFICATIONS",
            style: TextStyle(
              fontSize: isMobile ? 20 : 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          isMobile || isTablet
              ? Column(
                children: [
                  subtleHover(
                    child: _eduCard(
                      "PG Diploma in Mobile Computing",
                      "CDAC, Sunbeam Institute, Pune",
                      "2018",
                      "Specialized in Mobile OS Architecture & Hybrid Development",
                      isMobile,
                    ),
                  ),
                  const SizedBox(height: 20),
                  subtleHover(
                    child: _eduCard(
                      "Bachelor of Engineering (Computer Science)",
                      "S.G. Balekundri Institute, Belagavi",
                      "2013 - 2017",
                      "Focus on Core CS, Algorithms, and Software Engineering",
                      isMobile,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _certCard(
                    "AI Tools Specialist",
                    "BE10X Workshop (2025)",
                    "ID: 0270772f-3809-4400-b29b-1e1c61cd0997866471",
                    "Focus: Prompt Engineering, ChatGPT for Developers, & Automation",
                    isMobile,
                  ),
                  const SizedBox(height: 20),
                  subtleHover(
                    child: _certCard(
                      "Technical Leadership Program",
                      "Ajinkya Technologies",
                      "",
                      "Managing cross-functional teams, Agile delivery, and mentoring junior developers",
                      isMobile,
                    ),
                  ),
                ],
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        subtleHover(
                          child: _eduCard(
                            "PG Diploma in Mobile Computing",
                            "CDAC, Sunbeam Institute, Pune",
                            "2018",
                            "Specialized in Mobile OS Architecture & Hybrid Development",
                            false,
                          ),
                        ),
                        const SizedBox(height: 20),
                        subtleHover(
                          child: _eduCard(
                            "Bachelor of Engineering (Computer Science)",
                            "S.G. Balekundri Institute, Belagavi",
                            "2013 - 2017",
                            "Focus on Core CS, Algorithms, and Software Engineering",
                            false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Column(
                      children: [
                        subtleHover(
                          child: _certCard(
                            "AI Tools Specialist",
                            "BE10X Workshop (2025)",
                            "ID: 0270772f-3809-4400-b29b-1e1c61cd0997866471",
                            "Focus: Prompt Engineering, ChatGPT for Developers, & Automation",
                            false,
                          ),
                        ),
                        const SizedBox(height: 20),
                        subtleHover(
                          child: _certCard(
                            "Technical Leadership Program",
                            "Ajinkya Technologies",
                            "",
                            "Managing cross-functional teams, Agile delivery, and mentoring junior developers",
                            false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _eduCard(
    String title,
    String school,
    String year,
    String detail,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                year,
                style: GoogleFonts.robotoMono(
                  color: const Color(0xFF00D2FF),
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 12 : 14,
                ),
              ),
              const Icon(Icons.school_outlined, color: Colors.white24),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            school,
            style: TextStyle(
              color: Colors.white54,
              fontSize: isMobile ? 13 : 14,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            detail,
            style: TextStyle(
              color: Colors.grey,
              fontSize: isMobile ? 12 : 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _certCard(
    String title,
    String issuer,
    String id,
    String focus,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00D2FF).withOpacity(0.05),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF00D2FF).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user_outlined, color: Color(0xFF00D2FF)),
          const SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            issuer,
            style: TextStyle(
              color: Colors.white54,
              fontSize: isMobile ? 13 : 14,
            ),
          ),
          const Divider(height: 30, color: Colors.white10),
          Text(
            focus,
            style: TextStyle(
              color: Colors.grey,
              fontSize: isMobile ? 11 : 12,
              height: 1.4,
            ),
          ),
          if (id.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              id,
              style: GoogleFonts.robotoMono(
                fontSize: isMobile ? 9 : 10,
                color: Colors.white24,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Skills Matrix
  Widget _buildSkillsMatrix(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 40 : 100)),
      color: Colors.white.withOpacity(0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CORE COMPETENCIES",
            style: TextStyle(
              fontSize: isMobile ? 24 : 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: isMobile ? 10 : 15,
            runSpacing: isMobile ? 10 : 15,
            children: [
              _competencyCard(
                "Mobile Architecture",
                Icons.architecture,
                isMobile,
              ),
              _competencyCard(
                "Technical Leadership",
                Icons.people_outline,
                isMobile,
              ),
              _competencyCard("Team Management", Icons.groups, isMobile),
              _competencyCard("State Management", Icons.layers, isMobile),
              _competencyCard(
                "Payment Integration",
                Icons.credit_card,
                isMobile,
              ),
              _competencyCard("Cloud Infrastructure", Icons.cloud, isMobile),
              _competencyCard("API Design", Icons.api, isMobile),
              _competencyCard("Backend Development", Icons.storage, isMobile),
              _competencyCard("Agile Management", Icons.print, isMobile),
              _competencyCard(
                "Technical Documentation",
                Icons.description,
                isMobile,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _competencyCard(String title, IconData icon, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 20,
        vertical: isMobile ? 10 : 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF00D2FF), size: isMobile ? 16 : 20),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Achievements
  Widget _buildAchievements(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 40 : 100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "KEY ACHIEVEMENTS",
            style: TextStyle(
              fontSize: isMobile ? 24 : 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          _achievementTile(
            "Production Excellence",
            "Delivered 15+ production-grade mobile applications with consistently high user satisfaction",
            Icons.star,
            Colors.amber,
            isMobile,
          ),
          _achievementTile(
            "Rapid Delivery",
            "Recognized for rapid delivery under aggressive timelines across multiple client engagements",
            Icons.speed,
            Colors.blue,
            isMobile,
          ),
          _achievementTile(
            "Stability Champion",
            "Maintained 99.5% crash-free stability through proactive monitoring and defensive coding",
            Icons.security,
            Colors.green,
            isMobile,
          ),
          _achievementTile(
            "Team Builder",
            "Mentored 10+ junior developers, elevating team capability and code quality benchmarks",
            Icons.group_add,
            Colors.purple,
            isMobile,
          ),
        ],
      ),
    );
  }

  Widget _achievementTile(
    String title,
    String desc,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 15 : 20),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 15 : 25),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child:
            isMobile
                ? Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          desc,
                          style: const TextStyle(
                            color: Colors.grey,
                            height: 1.5,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                : Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 30),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            desc,
                            style: const TextStyle(
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _socialBtn(IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: IconButton(
        onPressed: () => _launch(url),
        icon: FaIcon(icon, color: const Color(0xFF00D2FF)),
        iconSize: 24,
        tooltip: url,
      ),
    );
  }

  Widget _buildContactFooter(bool isMobile, bool isTablet) {
    return Container(
      key: _contactKey,
      padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 40 : 100)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00D2FF).withOpacity(0.05),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Text(
            "LET'S BUILD SOMETHING AMAZING",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 24 : 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Open to exciting opportunities and collaborations",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: isMobile ? 14 : 16),
          ),
          const SizedBox(height: 40),
          isMobile || isTablet
              ? Column(
                children: [
                  _contactCard(
                    Icons.location_on,
                    "Location",
                    "Belagavi, Karnataka, IN",
                    isMobile,
                  ),
                  const SizedBox(height: 15),
                  _contactCard(
                    Icons.email,
                    "Email",
                    "meghanpatil95@gmail.com",
                    isMobile,
                  ),
                  const SizedBox(height: 15),
                  _contactCard(
                    Icons.phone,
                    "Phone",
                    "+91 7795200057",
                    isMobile,
                  ),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _contactCard(
                    Icons.location_on,
                    "Location",
                    "Belagavi, Karnataka, IN",
                    false,
                  ),
                  const SizedBox(width: 30),
                  _contactCard(
                    Icons.email,
                    "Email",
                    "meghanpatil95@gmail.com",
                    false,
                  ),
                  const SizedBox(width: 30),
                  _contactCard(Icons.phone, "Phone", "+91 7795200057", false),
                ],
              ),
          const SizedBox(height: 50),
          const Divider(color: Colors.white10),
          const SizedBox(height: 30),
          isMobile
              ? Column(
                children: [
                  Text(
                    "© 2025 MEGHAN M. PATIL",
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Built with Flutter & ❤️",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "© 2025 MEGHAN M. PATIL",
                    style: TextStyle(color: Colors.white24),
                  ),
                  const SizedBox(width: 30),
                  Text(
                    "Built with Flutter & ❤️",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _contactCard(
    IconData icon,
    String label,
    String value,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 15 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF00D2FF), size: isMobile ? 24 : 30),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.white54,
              fontSize: isMobile ? 11 : 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class HoverStatCard extends StatefulWidget {
  final String val;
  final String desc;
  final IconData icon;
  final bool isMobile;

  const HoverStatCard({
    super.key,
    required this.val,
    required this.desc,
    required this.icon,
    required this.isMobile,
  });

  @override
  State<HoverStatCard> createState() => _HoverStatCardState();
}

class _HoverStatCardState extends State<HoverStatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -6.0 : 0.0),
        padding: EdgeInsets.all(widget.isMobile ? 15 : 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(_isHovered ? 0.09 : 0.05),
              Colors.white.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                _isHovered
                    ? Colors.white.withOpacity(0.25)
                    : Colors.white.withOpacity(0.1),
          ),
          boxShadow:
              _isHovered
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                  : [],
        ),
        child: AnimatedScale(
          scale: _isHovered ? 1.025 : 1.0,
          duration: const Duration(milliseconds: 220),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSlide(
                duration: const Duration(milliseconds: 220),
                offset: _isHovered ? const Offset(0, -0.05) : Offset.zero,
                child: Icon(
                  widget.icon,
                  color: const Color(0xFF00D2FF),
                  size: widget.isMobile ? 24 : 30,
                ),
              ),
              SizedBox(height: widget.isMobile ? 5 : 10),
              Text(
                widget.val,
                style: TextStyle(
                  fontSize: widget.isMobile ? 20 : 30,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00D2FF),
                ),
              ),
              SizedBox(height: widget.isMobile ? 5 : 10),
              Text(
                widget.desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: widget.isMobile ? 10 : 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoverSkillChip extends StatefulWidget {
  final String name;
  final String url;
  final bool isMobile;

  const _HoverSkillChip({
    required this.name,
    required this.url,
    required this.isMobile,
  });

  @override
  State<_HoverSkillChip> createState() => _HoverSkillChipState();
}

class _HoverSkillChipState extends State<_HoverSkillChip> {
  bool _hovered = false;
  late final textColor = Theme.of(context).colorScheme.onSurface;
  late final borderColor =
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withOpacity(0.25)
          : Colors.black.withOpacity(0.15);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _launch(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..translate(0.0, _hovered ? -4.0 : 0.0),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 12 : 16,
            vertical: widget.isMobile ? 7 : 9,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  _hovered
                      ? [
                        Colors.white.withOpacity(0.12),
                        Colors.white.withOpacity(0.04),
                      ]
                      : [
                        Colors.white.withOpacity(0.06),
                        Colors.white.withOpacity(0.02),
                      ],
            ),
            borderRadius: BorderRadius.circular(22),
            /*border: Border.all(
              color:
                  _hovered
                      ? Colors.white.withOpacity(0.35)
                      : const Color(0xFF00D2FF).withOpacity(0.25),
            ),*/
            border: Border.all(color: borderColor),
            boxShadow:
                _hovered
                    ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                    : [],
          ),
          child: AnimatedScale(
            scale: _hovered ? 1.06 : 1.0,
            duration: const Duration(milliseconds: 220),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: widget.isMobile ? 12 : 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 6),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 220),
                  offset: _hovered ? const Offset(0.2, 0) : Offset.zero,
                  child: Icon(
                    Icons.open_in_new,
                    size: widget.isMobile ? 11 : 13,
                    color: const Color(0xFF00D2FF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _launch(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
