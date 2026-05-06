import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuTap;
  final VoidCallback? onActionTap;
  final VoidCallback? onFilterTap;
  final Function(String)? onSearchChanged;

  final bool showMenu;
  final bool showAction;
  final bool showSearchIcon;
  final bool showFilterIcon;
  final bool showBackButton; // 🔥 નવો પેરામીટર

  const CustomAppBar({
    super.key,
    required this.title,
    this.onMenuTap,
    this.onActionTap,
    this.onFilterTap,
    this.onSearchChanged,
    this.showMenu = true,
    this.showAction = true,
    this.showSearchIcon = false,
    this.showFilterIcon = false,
    this.showBackButton = false, // 🔥 Default false રાખ્યું છે
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final Color secondaryDark = const Color(0xFF1E293B);
  final Color cyanAccent = Colors.cyan;

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark, // Status bar icons light રાખવા માટે
      flexibleSpace: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: secondaryDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cyanAccent.withOpacity(0.2),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isSearching ? _buildSearchBar() : _buildNormalAppBar(),
          ),
        ),
      ),
    );
  }

  /// --- NORMAL VIEW ---
  Widget _buildNormalAppBar() {
    return Row(
      key: const ValueKey(1),
      children: [
        /// BACK BUTTON અથવા MENU ICON
        if (widget.showBackButton)
          _buildCircleIcon(Icons.arrow_back_ios_new, () {
            Navigator.pop(context);
          })
        else if (widget.showMenu)
          _buildCircleIcon(Icons.menu, widget.onMenuTap)
        else
          const SizedBox(width: 36),

        const SizedBox(width: 12),

        /// TITLE
        Expanded(
          child: Text(
            widget.title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),

        /// SEARCH ICON
        if (widget.showSearchIcon)
          _buildCircleIcon(Icons.search, () {
            setState(() => isSearching = true);
          }),

        if (widget.showSearchIcon && (widget.showFilterIcon || widget.showAction))
          const SizedBox(width: 8),

        /// FILTER ICON
        if (widget.showFilterIcon)
          _buildCircleIcon(Icons.filter_alt, widget.onFilterTap),

        if (widget.showFilterIcon && widget.showAction) const SizedBox(width: 8),

        /// ACTION ICON (Key)
        if (widget.showAction)
          _buildCircleIcon(Icons.key, widget.onActionTap)
        else if (!widget.showSearchIcon && !widget.showFilterIcon)
          const SizedBox(width: 36),
      ],
    );
  }

  /// --- SEARCH BAR VIEW ---
  Widget _buildSearchBar() {
    return Row(
      key: const ValueKey(2),
      children: [
        Icon(Icons.search, color: cyanAccent, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText: "Search here...",
              hintStyle: GoogleFonts.montserrat(color: Colors.white54, fontSize: 14),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              if (widget.onSearchChanged != null) {
                widget.onSearchChanged!(value);
              }
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isSearching = false;
              _searchController.clear();
              if (widget.onSearchChanged != null) widget.onSearchChanged!("");
            });
          },
          child: const Icon(Icons.close, color: Colors.white, size: 22),
        ),
      ],
    );
  }

  /// આઈકોન બેકગ્રાઉન્ડ
  Widget _buildCircleIcon(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: cyanAccent.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}