import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/CustomeWidgets/AppColors.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import '../../../Api/Response/CompanyLogo/ResponseCompanyLogo.dart';
import '../../../Routes/app_routes.dart';

class ContactUsScreen extends StatefulWidget {

   ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  CompanyLogo? logo;
  bool? isSearch=false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: SharedWidgets.customAppBar(
          centerImagePath: logo?.siteLogo,
          searchVisible: true,
          showSearch: isSearch!,
          onSearchTap: () {
            isSearch = true;
            setState(() {

            });
          },
          onSearchChanged: (value) {
            print("search value is :- $value");
          },
          onCloseSearch: () {
            isSearch = false;
            setState(() {

            });
          },
          showSignInIcon: true,
          showJoinUsIcon: false,
          onSignInTap: () {
            Get.toNamed(AppRoutes.login);
          },
          onJoinUsTap: () {
            Get.toNamed(AppRoutes.joinUs);
          },
          gradient: const LinearGradient(colors: [
            AppColors.gradientStart,AppColors.gradientEnd
            // AppColors.gradientStart,AppColors.gradientMid,AppColors.gradientEnd
          ])
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                    image: AssetImage("assets/contact_banner.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: contactCard(
                      icon: Icons.phone,
                      title: "Phone Number",
                      subtitle: "83 82 86 82 88\n1800 2022 101",
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: contactCard(
                      icon: Icons.email,
                      title: "Email Address",
                      subtitle: "info@gotilo.net",
                    ),
                  ),



                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: contactCard(
                      icon: Icons.location_on,
                      title: "Address",
                      subtitle:
                      "401, Shree Hari Empire,\nRaiya Road, opp. Tulsi Super Market,\nRajkot - 360007",
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              Container(
                                height: 12,
                                width: 12,
                                decoration: const BoxDecoration(
                                  color: Colors.pink,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Get In Touch",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          buildTextField(
                            controller: nameController,
                            hint: "Enter Name",
                          ),

                          const SizedBox(height: 12),

                          buildTextField(
                            controller: emailController,
                            hint: "Your Email Address",
                          ),

                          const SizedBox(height: 12),

                          buildTextField(
                            controller: phoneController,
                            hint: "Enter Phone Number",
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 12),

                          buildTextField(
                            controller: messageController,
                            hint: "Type Message",
                            maxLines: 4,
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: 160,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                print(nameController.text);
                                print(emailController.text);
                                print(phoneController.text);
                                print(messageController.text);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Message Sent Successfully"),
                                  ),
                                );
                              },
                              child: const Text(
                                "Send Message",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
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

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget contactCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.06),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.pink,
              size: 24,
            ),
          ),

          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}