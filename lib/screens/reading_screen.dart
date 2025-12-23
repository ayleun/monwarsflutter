import 'package:flutter/material.dart';
import 'package:page_curl_effect/page_curl_effect.dart';
import '../models/page_item.dart';
import '../services/juzz_data_service.dart';
import '../services/reading_progress_service.dart';
import '../services/favorites_service.dart';

class ReadingScreen extends StatefulWidget {
  final int juzzNumber;
  final int lastPosition;
  final String sourateDescription;

  const ReadingScreen({
    super.key,
    required this.juzzNumber,
    this.lastPosition = 0,
    required this.sourateDescription,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  List<PageItem> pages = [];
  int currentPage = 0;
  bool isLoading = true;
  bool isAutoScrolling = false;
  PageCurlController? pageCurlController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadPages();
  }


  // Convert index to actual page number (for RTL reading)
  int _getActualPageNumber(int pageIndex) {
    if (pages.isEmpty) return 0;
    // For RTL: pages are reversed, so we need to convert back
    // pageIndex 0 = last page, pageIndex (length-1) = first page
    // Page numbers start from 1, not 0
    return pages.length - pageIndex;
  }

  // Get actual page index (for saving progress) - convert RTL index to LTR index
  int _getActualPageIndex(int pageIndex) {
    if (pages.isEmpty) return 0;
    // Convert RTL index (0 = last page) to LTR index (0 = first page)
    return pages.length - 1 - pageIndex;
  }
  
  // Convert LTR index to RTL index
  int _getRTLIndex(int ltrIndex) {
    if (pages.isEmpty) return 0;
    return pages.length - 1 - ltrIndex;
  }
  
  // Save progress immediately
  Future<void> _saveReadingProgress() async {
    // currentPage is already the actual index for LTR reading
    final actualPageIndex = _getActualPageIndex(currentPage);
    final actualPageNumber = _getActualPageNumber(currentPage);
    
    await ReadingProgressService.saveReadingPosition(
      lastPosition: actualPageIndex,
      juzzNumber: widget.juzzNumber,
      lastReadInfo: 'Juzz ${widget.juzzNumber} - Page $actualPageNumber',
      readingProgress: pages.isEmpty ? 0 : ((actualPageIndex / pages.length) * 100).round(),
      lastPage: actualPageNumber,
      lastSourate: widget.sourateDescription,
    );
  }

  @override
  void dispose() {
    pageCurlController?.dispose();
    // Save progress when closing the screen - ensure it completes
    _saveReadingProgress().catchError((error) {
      // Ignore errors during save on dispose
    });
    super.dispose();
  }

  Future<void> _loadPages() async {
    setState(() {
      isLoading = true;
    });

    // Load pages for this Juzz
    final pageCount = JuzzDataService.getPagesInJuzz(widget.juzzNumber);
    final ltrPages = List.generate(pageCount, (index) {
      return PageItem(
        imageResource: index + 1,
        pageNumber: index + 1,
      );
    });

    // For RTL reading: reverse the pages so we read from right to left
    // Last page (highest number) should be first in the list
    pages = ltrPages.reversed.toList();

    // Convert LTR position to RTL position
    // widget.lastPosition is the LTR page index (0 = page 1, 44 = page 45)
    final ltrPosition = pages.length > 0 
        ? widget.lastPosition.clamp(0, pages.length - 1)
        : 0;
    final rtlPosition = _getRTLIndex(ltrPosition);

    setState(() {
      isLoading = false;
      currentPage = rtlPosition;
    });

    await _refreshFavoriteState();
  }

  void _initializePageCurlController(Size screenSize) {
    if (pageCurlController == null && pages.isNotEmpty) {
      pageCurlController = PageCurlController(
        screenSize,
        pageCurlIndex: currentPage,
        numberOfPage: pages.length,
      );
      // Listen to page changes
      pageCurlController!.addListener(() {
        if (pageCurlController!.pageCurlIndex != currentPage) {
          setState(() {
            currentPage = pageCurlController!.pageCurlIndex;
          });
          _saveReadingProgress();
          _refreshFavoriteState();
        }
      });
    }
  }

  void _toggleAutoScroll() {
    setState(() {
      isAutoScrolling = !isAutoScrolling;
    });

    if (isAutoScrolling) {
      _startAutoScroll();
    } else {
      _stopAutoScroll();
    }
  }

  void _startAutoScroll() {
    if (isAutoScrolling && pageCurlController != null) {
      // For RTL reading: on lit de droite à gauche
      // currentPage = 0 = dernière page (numéro le plus élevé)
      // currentPage augmente = pages avec numéros plus petits
      // Pour que le compteur augmente (1, 2, 3...), on doit diminuer currentPage
      if (currentPage > 0) {
        // Utiliser le contrôleur pour changer de page programmatiquement
        Future.delayed(const Duration(seconds: 7), () {
          if (isAutoScrolling && mounted && pageCurlController != null) {
            final nextPage = currentPage - 1; // Diminuer pour augmenter le numéro de page
            if (nextPage >= 0) {
              // Mettre à jour le contrôleur pour déclencher le changement de page
              pageCurlController!.pageCurlIndex = nextPage;
            setState(() {
                currentPage = nextPage;
            });
            _saveReadingProgress();
            _refreshFavoriteState();
              // Continuer le défilement automatique
            _startAutoScroll();
            } else {
              _stopAutoScroll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fin du Juzz atteinte'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        });
      } else {
        _stopAutoScroll();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fin du Juzz atteinte'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _refreshFavoriteState() async {
    if (pages.isEmpty) return;
    final page = _getActualPageNumber(currentPage);
    final isFav = await FavoritesService.isFavorite(widget.juzzNumber, page);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  void _stopAutoScroll() {
    setState(() {
      isAutoScrolling = false;
    });
  }


  Widget _buildPageContent(int actualIndex) {
    return GestureDetector(
      onDoubleTap: _toggleAutoScroll,
      child: Image.asset(
        'images/j${widget.juzzNumber}_${actualIndex + 1}.webp',
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 500,
            alignment: Alignment.center,
            color: Colors.grey[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Juzz ${widget.juzzNumber} - Page ${actualIndex + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Image non disponible',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          // Reading content with page curl effect
          isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
                    _initializePageCurlController(screenSize);
                    
                    if (pageCurlController == null) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }
                    
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: Transform.scale(
                        scale: 1.0,
                        child: PageCurlEffect(
                      pageCurlController: pageCurlController!,
                      pages: pages.asMap().entries.map((entry) {
                        final index = entry.key;
                            // Get the actual page number for the image
                            final actualPageNumber = _getActualPageNumber(index);
                            return _buildPageContent(actualPageNumber - 1);
                      }).toList(),
                      onForwardComplete: () {
                        if (pageCurlController != null) {
                              // Délai augmenté pour ralentir la transition du curl
                              Future.delayed(const Duration(milliseconds: 400), () {
                                if (mounted && pageCurlController != null) {
                          setState(() {
                            currentPage = pageCurlController!.pageCurlIndex;
                          });
                          _saveReadingProgress();
                                  _refreshFavoriteState();
                                }
                              });
                        }
                      },
                      onBackwardComplete: () {
                        if (pageCurlController != null) {
                              // Délai augmenté pour ralentir la transition du curl
                              Future.delayed(const Duration(milliseconds: 400), () {
                                if (mounted && pageCurlController != null) {
                          setState(() {
                            currentPage = pageCurlController!.pageCurlIndex;
                          });
                          _saveReadingProgress();
                                  _refreshFavoriteState();
                                }
                              });
                        }
                      },
                        ),
                      ),
                    );
                  },
                ),

          // Top bar with Juzz info
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black87,
                      Colors.black87.withOpacity(0.0),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () async {
                        // Save progress before leaving
                        await _saveReadingProgress();
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    Column(
                      children: [
                        Text(
                          'Juzz ${widget.juzzNumber}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (pages.isNotEmpty)
                          Text(
                            'Page ${_getActualPageNumber(currentPage)} / ${pages.length}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Ajouter aux favoris',
                          icon: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.redAccent : Colors.white,
                          ),
                          onPressed: () async {
                            if (pages.isEmpty) return;
                            final page = _getActualPageNumber(currentPage);
                            if (_isFavorite) {
                              await FavoritesService.removeFavorite(widget.juzzNumber, page);
                              if (!mounted) return;
                              setState(() => _isFavorite = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Retiré des favoris')),
                              );
                            } else {
                              await FavoritesService.addFavorite(
                                juzzNumber: widget.juzzNumber,
                                pageNumber: page,
                                title: 'Juzz ${widget.juzzNumber} - Page $page',
                                subtitle: widget.sourateDescription,
                              );
                              if (!mounted) return;
                              setState(() => _isFavorite = true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Ajouté aux favoris')),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            isAutoScrolling ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: _toggleAutoScroll,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
