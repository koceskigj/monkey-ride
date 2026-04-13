import 'package:flutter/material.dart';

import '../../../models/info_slide_model.dart';
import '../../../widgets/common/app_surface_styles.dart';

class InfoSlideCard extends StatefulWidget {
  final InfoSlideModel slide;

  const InfoSlideCard({
    super.key,
    required this.slide,
  });

  @override
  State<InfoSlideCard> createState() => _InfoSlideCardState();
}

class _InfoSlideCardState extends State<InfoSlideCard> {
  late final ScrollController _textScrollController;

  @override
  void initState() {
    super.initState();
    _textScrollController = ScrollController();
  }

  @override
  void dispose() {
    _textScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scrollbarThumbColor = isDark
        ? colorScheme.primary.withOpacity(0.85)
        : colorScheme.outline.withOpacity(0.9);

    final dividerColor = isDark
        ? colorScheme.primary.withOpacity(0.55)
        : colorScheme.outline.withOpacity(0.75);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Container(
        decoration: AppSurfaceStyles.card(
          context,
          backgroundColor: colorScheme.surface,
          radius: 28,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 18),
                child: Column(
                  children: [
                    Text(
                      widget.slide.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ScrollbarTheme(
                        data: ScrollbarTheme.of(context).copyWith(
                          thumbVisibility:
                          const WidgetStatePropertyAll(true),
                          thickness:
                          const WidgetStatePropertyAll(4),
                          radius: const Radius.circular(999),
                          thumbColor:
                          WidgetStatePropertyAll(scrollbarThumbColor),
                          trackVisibility:
                          const WidgetStatePropertyAll(false),
                        ),
                        child: Scrollbar(
                          controller: _textScrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _textScrollController,
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              widget.slide.description,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                height: 1.45,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1.4,
              color: dividerColor,
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Image.asset(
                    widget.slide.imageAssetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 72,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Image not found',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}