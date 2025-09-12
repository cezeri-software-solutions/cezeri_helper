import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

@RoutePage()
class CezeriImageViewPage extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;

  const CezeriImageViewPage({required this.urls, this.initialIndex = 0, super.key});

  @override
  State<CezeriImageViewPage> createState() => _CezeriImageViewPageState();
}

class _CezeriImageViewPageState extends State<CezeriImageViewPage> with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late AnimationController _resetController;
  late Animation<double> _resetAnimation;
  late int _currentIndex;
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _resetController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _resetController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final velocity = details.primaryVelocity ?? 0;
    final shouldClose = velocity > 700 || _dragOffset.abs() > screenHeight * 0.25;

    if (shouldClose) {
      context.pop();
    } else {
      // Reset animation back to zero
      _resetAnimation = Tween<double>(begin: _dragOffset, end: 0.0).animate(CurvedAnimation(parent: _resetController, curve: Curves.easeOut))
        ..addListener(() {
          setState(() {
            _dragOffset = _resetAnimation.value;
          });
        });
      _resetController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Background opacity changes during drag
    final opacity = (1 - (_dragOffset.abs() / screenHeight)).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onVerticalDragUpdate: _onDragUpdate,
        onVerticalDragEnd: _onDragEnd,
        child: Stack(
          children: [
            // Hintergrund mit dynamischer Opazität
            Container(color: Colors.black.withOpacity(opacity)),

            // Bild-Content verschiebt sich beim Ziehen
            Transform.translate(
              offset: Offset(0, _dragOffset),
              child: SafeArea(
                child: Stack(
                  children: [
                    Center(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.urls.length,
                        onPageChanged: (index) {
                          setState(() => _currentIndex = index);
                        },
                        itemBuilder: (context, index) {
                          return PhotoView(
                            imageProvider: NetworkImage(widget.urls[index]),
                            loadingBuilder: (context, event) => const Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    ),

                    // Close-Button
                    Positioned(top: 20, right: 20, child: IconButton.filled(onPressed: () => context.pop(), icon: const Icon(Icons.close))),

                    // Dots-Indicator
                    if (widget.urls.length > 1)
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.urls.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentIndex == index ? 12 : 8,
                              height: _currentIndex == index ? 12 : 8,
                              decoration: BoxDecoration(color: _currentIndex == index ? Colors.white : Colors.white54, shape: BoxShape.circle),
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
    );
  }
}
