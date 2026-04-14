import 'package:flutter/material.dart';
import 'package:monkey_ride/screens/info/widgets/info_slide_card.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_error_messages.dart';
import '../../providers/info_provider.dart';
import '../../widgets/common/app_error_state.dart';


class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InfoProvider>();
    final slides = provider.slides;

    if (provider.isLoading && slides.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && !provider.hasData) {
      return AppErrorState(
        message: provider.errorMessage!,
        imageAssetPath: AppErrorMessages.imageForType(provider.errorType),
        onRetry: provider.loadSlides,
      );
    }

    if (slides.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: provider.loadSlides,
            child: PageView.builder(
              controller: _pageController,
              itemCount: slides.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.72,
                      child: InfoSlideCard(
                        slide: slides[index],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              slides.length,
                  (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}