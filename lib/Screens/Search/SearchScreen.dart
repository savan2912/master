import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/Search/RequestSearch.dart';
import 'package:gotilo_new/Api/Response/Search/ResponseSearch.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingDetailScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;
  bool isSearching = false;
  List<SearchData> searchResults = [];
  Timer? _debouncer;

  // Voice Search Variables
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _listeningText = "Speak now, we are listening...";

  // એનિમેશન કંટ્રોલર (માઇક ગ્લો ઇફેક્ટ માટે)
  AnimationController? _pulseController;

  // Jio Hotstar / AI સ્ટાઈલ મોર્ડન લીનિયર ગ્રેડિયન્ટ
  final LinearGradient _aiGradient = const LinearGradient(
    colors: [
      Color(0xFF00F2FE), // બ્રાઇટ સિયાન
      Color(0xFF4FACFE), // સ્કાઇ બ્લુ
      Color(0xFF0000FF), // ડીપ બ્લુ / પર્પલ શેડ
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _callSearchData("");

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.6,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer?.cancel();
    _pulseController?.dispose();
    super.dispose();
  }

  // નવી પ્રીમિયમ Bottom Sheet ડિઝાઇન
  void _showListeningBottomSheet() {
    _pulseController?.repeat(reverse: true); // એનિમેશન સ્ટાર્ટ કરો

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A), // ડાર્ક સ્લેટ બ્લેક પ્રીમિયમ લુક
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ટોપ હેન્ડલ બાર
                  Container(
                    width: 45, height: 4,
                    decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 30),

                  // Jio Hotstar AI સ્ટાઇલ ગ્રેડિયન્ટ પલ્સ ગ્લો એનિમેશન
                  AnimatedBuilder(
                    animation: _pulseController!,
                    builder: (context, child) {
                      return Container(
                        padding: EdgeInsets.all(24 * _pulseController!.value),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00F2FE).withOpacity(0.15 * (1 - _pulseController!.value + 0.2)),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(3), // બોર્ડર ગ્રેડિયન્ટ લુક માટે
                          decoration: BoxDecoration(
                            gradient: _aiGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: const BoxDecoration(
                              color: Color(0xFF0F172A), // અંદર ડાર્ક કલર
                              shape: BoxShape.circle,
                            ),
                            // આઇકોન પર ગ્રેડિયન્ટ ઇફેક્ટ આપવા માટે ShaderMask
                            child: ShaderMask(
                              shaderCallback: (bounds) => _aiGradient.createShader(bounds),
                              child: const Icon(Icons.mic_rounded, size: 42, color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),

                  // મુખ્ય હેડિંગ
                  ShaderMask(
                    shaderCallback: (bounds) => _aiGradient.createShader(bounds),
                    child: const Text(
                      "AI VOICE SEARCH",
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 2.0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _listeningText,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      _pulseController?.stop();
      if (_isListening) {
        setState(() => _isListening = false);
        _speech.stop();
      }
    });
  }

  // Voice Search ફંક્શન
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          log('Speech Status: $val');
          if (val == 'done' || val == 'notListening') {
            if (mounted && _isListening) {
              setState(() => _isListening = false);
              Navigator.pop(context); // બોલવાનું પૂરું થતાં શીટ ક્લોઝ કરો
            }
          }
        },
        onError: (val) {
          log('Speech Error: $val');
          if (mounted) {
            setState(() => _isListening = false);
            _pulseController?.stop();
            if (Navigator.canPop(context)) Navigator.pop(context);
          }
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
          _listeningText = "Speak now, we are listening...";
        });

        _showListeningBottomSheet();

        _speech.listen(
          onResult: (val) {
            setState(() {
              _searchController.text = val.recognizedWords;
              _listeningText = val.recognizedWords.isEmpty ? "Speak now, we are listening..." : val.recognizedWords;

              _searchController.selection = TextSelection.fromPosition(
                TextPosition(offset: _searchController.text.length),
              );
            });

            if (val.finalResult) {
              _pulseController?.stop();
              if (_isListening) {
                setState(() => _isListening = false);
                _speech.stop();
              }
              Navigator.pop(context);
              _callSearchData(val.recognizedWords);
            }
          },
        );
      }
    } else {
      _pulseController?.stop();
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _callSearchData(String query) async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        if (query.isEmpty) {
          setState(() => isLoading = true);
        } else {
          setState(() => isSearching = true);
        }

        ResponseSearchData? response = await ApiCalls.callSearchData(
            RequestSearch(search: query)
        );

        setState(() {
          searchResults = response?.data ?? [];
        });
      } on Exception catch (e) {
        log("Exception: $e");
      } finally {
        setState(() {
          isLoading = false;
          isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isLoading && !isSearching && searchResults.isNotEmpty)
            _buildSectionTitle(_searchController.text.isEmpty ? "Popular Choices" : "Found Results"),

          Expanded(
            child: isLoading
                ? _buildListShimmer()
                : _buildBodyContent(),
          ),
        ],
      ),
      // પ્રીમિયમ ગ્રેડિયન્ટ લુક વાળું Floating Action Button
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: _aiGradient, // ગ્રેડિયન્ટ બેકગ્રાઉન્ડ
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00F2FE).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: FloatingActionButton(
          onPressed: _listen,
          backgroundColor: Colors.transparent, // ગ્રેડિયન્ટ દેખાય તે માટે ટ્રાન્સપરન્ટ
          elevation: 0,
          highlightElevation: 0,
          shape: const CircleBorder(),
          child: Icon(
            _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
            color: Colors.white, // ગ્રેડિયન્ટ પર વ્હાઇટ આઇકોન એકદમ ક્લાસી લાગશે
            size: 26,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Container(
        height: 44,
        margin: const EdgeInsets.only(right: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) {
            if (_debouncer?.isActive ?? false) _debouncer!.cancel();
            _debouncer = Timer(const Duration(milliseconds: 700), () => _callSearchData(val));
            setState(() {});
          },
          style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: "Explore premium services...",
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            prefixIcon: ShaderMask(
              shaderCallback: (bounds) => _aiGradient.createShader(bounds),
              child: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    if (isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 45, width: 45,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF00F2FE)),
              ),
            ),
            const SizedBox(height: 20),
            Text("Searching for you...",
                style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    if (searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF00F2FE).withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => _aiGradient.createShader(bounds),
                child: const Icon(Icons.search_off_rounded, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 25),
            const Text("No Results Found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text("We couldn't find what you're looking for. Try another keyword.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[500], fontSize: 14, height: 1.5)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      physics: const BouncingScrollPhysics(),
      itemCount: searchResults.length,
      itemBuilder: (context, index) => _buildCleanCard(searchResults[index]),
    );
  }

  Widget _buildCleanCard(SearchData item) {
    return GestureDetector(
      onTap: () {
        Get.to(()=> AllListingDetailScreen(listId: item.listingId,));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 60, height: 60,
                  color: const Color(0xFFF1F5F9),
                  child: Image.network(
                    item.imageUrl ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.storefront_outlined, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => _aiGradient.createShader(bounds),
                    child: Text(item.categoryName?.toUpperCase() ?? "GENERAL",
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                  ),
                  const SizedBox(height: 2),
                  Text(item.listingTitle ?? "",
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => _aiGradient.createShader(bounds),
                        child: const Icon(Icons.verified_user_rounded, size: 12, color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      Text("Verified Service", style: TextStyle(color: Colors.grey[500], fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFFCBD5E1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: 8,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.white,
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          height: 85,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 18, 10),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black)),
    );
  }
}