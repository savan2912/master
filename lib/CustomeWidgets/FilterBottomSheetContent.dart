import 'package:flutter/material.dart';
import 'package:gotilo_new/CustomeWidgets/AppColors.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';

class FilterBottomSheetContent extends StatefulWidget {
  const FilterBottomSheetContent({super.key});

  @override
  State<FilterBottomSheetContent> createState() =>
      _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState extends State<FilterBottomSheetContent> {
  String? selectedLocation;
  String? selectedCategory;
  String? selectedSubcategory;

  final locations = ['Rajkot', 'Ahmedabad', 'Surat', 'Vadodara'];
  final categories = ['Electronics', 'Fashion', 'Food', 'Travel'];
  final subcategories = ['Mobile', 'Clothes', 'Restaurants', 'Hotels'];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Transparent background
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(color: Colors.black54),
        ),
        // Bottom Sheet
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: height * 0.7, // adaptive max height
                minHeight: height * 0.4, // adaptive min height
              ),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const Text(
                      "Filter",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Location Dropdown
                    buildModernDropdown(
                      label: "Location",
                      icon: Icons.location_on,
                      value: selectedLocation,
                      items: locations,
                      onChanged: (val) =>
                          setState(() => selectedLocation = val),
                    ),
                    if (selectedLocation != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Selected Location: $selectedLocation",
                          style: const TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),

                    // Category Dropdown
                    buildModernDropdown(
                      label: "Category",
                      icon: Icons.category,
                      value: selectedCategory,
                      items: categories,
                      onChanged: (val) =>
                          setState(() => selectedCategory = val),
                    ),
                    if (selectedCategory != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Selected Category: $selectedCategory",
                          style: const TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),

                    // Subcategory Dropdown
                    buildModernDropdown(
                      label: "Subcategory",
                      icon: Icons.subdirectory_arrow_right,
                      value: selectedSubcategory,
                      items: subcategories,
                      onChanged: (val) =>
                          setState(() => selectedSubcategory = val),
                    ),
                    if (selectedSubcategory != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Selected Subcategory: $selectedSubcategory",
                          style: const TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Responsive Button
                    SharedWidgets.buttonBg(
                      height: 50,
                      width: double.infinity, // responsive full width
                      text: "Apply Filter",
                      onPressed: () {
                        Navigator.pop(context, {
                          'location': selectedLocation,
                          'category': selectedCategory,
                          'subcategory': selectedSubcategory,
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildModernDropdown({
  required String label,
  required IconData icon,
  required String? value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: AppColors.gradientEnd),
        ),
        initialValue: value,
        items: items
            .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}
