import 'package:flutter/material.dart';
import 'package:recipe_book/helpers/fetch_media_url_helper.dart';
import 'package:recipe_book/models/models.dart';

class ProcedureImageGallery extends StatefulWidget {
  final List<ProcedureStep> procedures;
  final int startIndex;

  const ProcedureImageGallery({
    super.key,
    required this.procedures,
    required this.startIndex,
  });

  @override
  State<ProcedureImageGallery> createState() => _ProcedureImageGalleryState();
}

class _ProcedureImageGalleryState extends State<ProcedureImageGallery> {
  late PageController _pageController;
  int _currentIndex = 0;
  List<String?> _imageUrls = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _fetchAllImageUrls();
  }

  Future<void> _fetchAllImageUrls() async {
    final results = await Future.wait(
      widget.procedures.map((step) async {
        if (step.image != null) {
          return await fetchMediaUrl(step.image!);
        } else {
          return null;
        }
      }),
    );

    if (!mounted) return;

    setState(() {
      _imageUrls = results;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Animated background
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: _imageUrls[_currentIndex] != null &&
                          _imageUrls[_currentIndex]!.isNotEmpty
                      ? Image.network(
                          _imageUrls[_currentIndex]!,
                          key: ValueKey(_imageUrls[_currentIndex]),
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/placeholder.jpg',
                          key: const ValueKey('placeholder'),
                          fit: BoxFit.cover,
                        ),
                ),

                // Dark overlay
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(200),
                  ),
                ),

                // Main content
                Column(
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Procedure',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        CircleAvatar(
                          backgroundColor: Colors.orange[100],
                          child: Text(
                            '${_currentIndex + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.procedures.length,
                        onPageChanged: (index) =>
                            setState(() => _currentIndex = index),
                        itemBuilder: (context, index) {
                          final step = widget.procedures[index];
                          final imageUrl = _imageUrls[index];

                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                    opacity: animation, child: child),
                            child: Column(
                              key: ValueKey(index),
                              children: [
                                SizedBox(
                                  height: height / 3,
                                  width: double.infinity,
                                  child: imageUrl != null && imageUrl.isNotEmpty
                                      ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/images/placeholder.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 12),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Text(
                                              step.description ??
                                                  'No description',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
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
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
