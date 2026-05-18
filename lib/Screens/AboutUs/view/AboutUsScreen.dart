import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Api/ApiCalls.dart';
import '../../../Api/Response/AboutUs/ResponseAboutUs.dart';
import '../../../MyApplication/MyApplication.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  static const Color appBg = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color primaryCyan = Color(0xFF00ACC1);
  static const Color subtleGrey = Color(0xFF64748B);

  AboutUs? aboutData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    callAboutUs();
  }

  Future<void> callAboutUs() async {
    MyApplication.checkInternet().then((value) async {
      if (value) {
        try {
          ResponseAboutUs? response = await ApiCalls.callAboutUs();
          if (response != null && response.result == "pass") {
            setState(() {
              aboutData = response.data;
              isLoading = false;
            });
          } else {
            setState(() => isLoading = false);
          }
        } catch (e) {
          setState(() => isLoading = false);
          debugPrint("API Error: $e");
        }
      } else {
        setState(() => isLoading = false);
      }
    });
  }

  String cleanHtml(String? html) {
    if (html == null) return "";
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBg,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryCyan))
          : aboutData == null
          ? const Center(child: Text("Data not found!"))
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 80,
                  backgroundColor: appBg,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      aboutData?.aboutTitle ?? "About Us",
                      style: GoogleFonts.plusJakartaSans(
                        color: textDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),


                        _buildPremiumHero(),

                        const SizedBox(height: 40),

                        if (aboutData?.stats != null)
                          _buildStatsSection(aboutData!.stats!),

                        const SizedBox(height: 40),

                        _buildWhyChooseCard(),

                        const SizedBox(height: 40),

                        if (aboutData?.howItWorks != null)
                          _buildTimelineSection(
                            aboutData!.howItWorksTitle,
                            aboutData!.howItWorks!,
                          ),

                        const SizedBox(height: 40),

                        if (aboutData?.faq != null)
                          _buildFaqSection(aboutData!.faq!),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPremiumHero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: aboutData?.aboutImage !=null ? DecorationImage(
              image: NetworkImage(aboutData?.aboutImage ?? ""),
              fit: BoxFit.cover,
            ): DecorationImage(image: AssetImage("assets/gotilo_logo.png")),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Container(width: 15, height: 2, color: primaryCyan),
            const SizedBox(width: 8),
            Text(
              "ABOUT OUR COMPANY",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: primaryCyan,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          aboutData?.aboutSubtitle ?? "",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: textDark,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          cleanHtml(aboutData?.aboutContent),
          style: GoogleFonts.plusJakartaSans(
            color: subtleGrey,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(List<Stats> stats) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((s) {
          return Expanded(
            child: _statTile(s.count ?? "0", s.label ?? ""),
          );
        }).toList(),
      ),
    );
  }

  Widget _statTile(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.stars_rounded, color: primaryCyan, size: 24),
        const SizedBox(height: 8),
        Text(
          count,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize:
                14,
            color: textDark,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            color: subtleGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildWhyChooseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryCyan, Color(0xFF00838F)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 30),
          const SizedBox(height: 15),
          Text(
            aboutData?.whyChooseTitle ?? "Why Choose Us",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            aboutData?.whyChooseContent ?? "",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(String? title, List<HowItWorks> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title?.toUpperCase() ?? "HOW IT WORKS",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: primaryCyan,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 25),
        ...steps.asMap().entries.map((entry) {
          int idx = entry.key;
          var step = entry.value;
          return _timelineStep(
            step.stepNo ?? "0${idx + 1}",
            step.title ?? "",
            step.description ?? "",
            idx != steps.length - 1,
          );
        }),
      ],
    );
  }

  Widget _timelineStep(String num, String title, String desc, bool showLine) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: textDark,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  num,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (showLine)
                Expanded(child: Container(width: 2, color: Colors.grey[200])),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: subtleGrey,
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqSection(List<Faq> faqs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "FAQs",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: textDark,
          ),
        ),
        const SizedBox(height: 20),
        ...faqs.map((f) => _faqItem(f.question ?? "", f.answer ?? "")),
      ],
    );
  }

  Widget _faqItem(String q, String a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ExpansionTile(
        shape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 15),
        title: Text(
          q,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Text(
              a,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: subtleGrey,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
