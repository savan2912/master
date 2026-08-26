
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Sharedwidgets.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuTap;
  final VoidCallback? onActionTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onAddTap; // 🔥 Add Tap Callback
  final Function(String)? onSearchChanged;

  final bool showMenu;
  final bool showAction;
  final bool showSearchIcon;
  final bool showFilterIcon;
  final bool showBackButton;
  final bool showAddIcon; // 🔥 Add Icon Boolean

  const CustomAppBar({
    super.key,
    required this.title,
    this.onMenuTap,
    this.onActionTap,
    this.onFilterTap,
    this.onAddTap, // 🔥
    this.onSearchChanged,
    this.showMenu = true,
    this.showAction = true,
    this.showSearchIcon = false,
    this.showFilterIcon = false,
    this.showBackButton = false,
    this.showAddIcon = false, // 🔥 Default false
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final Color secondaryDark = const Color(0xFFFFFFFF);
  final Color cyanAccent = Colors.grey;

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      flexibleSpace: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: SharedWidgets.cardBoxDecoration(),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),

        if (widget.showAddIcon) ...[
          _buildCircleIcon(Icons.add, widget.onAddTap),
          const SizedBox(width: 8),
        ],

        if (widget.showSearchIcon) ...[
          _buildCircleIcon(Icons.search, () {
            setState(() => isSearching = true);
          }),
          if (widget.showFilterIcon || widget.showAction) const SizedBox(width: 8),
        ],

        /// FILTER ICON
        if (widget.showFilterIcon) ...[
          _buildCircleIcon(Icons.filter_alt, widget.onFilterTap),
          if (widget.showAction) const SizedBox(width: 8),
        ],

        /// ACTION ICON (Key)
        if (widget.showAction)
          _buildCircleIcon(Icons.key, widget.onActionTap)
        else if (!widget.showSearchIcon && !widget.showFilterIcon && !widget.showAddIcon)
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
            style: GoogleFonts.montserrat(color: Colors.black, fontSize: 15),
            decoration: InputDecoration(
              hintText: "Search here...",
              hintStyle: GoogleFonts.montserrat(color: Colors.black, fontSize: 14),
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
          child: const Icon(Icons.close, color: Colors.black, size: 22),
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
        child: Icon(icon, color: Colors.black, size: 20),
      ),
    );
  }
}