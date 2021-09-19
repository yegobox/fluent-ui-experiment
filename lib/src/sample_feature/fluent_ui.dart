import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sample_item.dart';
import 'screens/colors.dart';
import 'screens/forms.dart';
import 'screens/inputs.dart';
import 'screens/mobile.dart';
import 'screens/others.dart';
import 'screens/settings.dart';
import 'screens/theme.dart';
import 'screens/typography.dart';

const String appTitle = 'Fluent UI Showcase for Flutter';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

/// Displays a list of SampleItems.
class FluentUi extends StatefulWidget {
  const FluentUi({
    Key? key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  }) : super(key: key);

  static const routeName = '/';

  final List<SampleItem> items;

  @override
  State<FluentUi> createState() => _FluentUiState();
}

class _FluentUiState extends State<FluentUi> {
  bool value = false;

  int index = 0;

  final colorsController = ScrollController();
  final settingsController = ScrollController();
  @override
  void dispose() {
    // colorsController.dispose();
    // settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    return SafeArea(
      child: NavigationView(
        pane: NavigationPane(
          selected: index,
          onChanged: (i) => setState(() => index = i),
          header: Container(
            height: kOneLineTileHeight,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: const FlutterLogo(
              style: FlutterLogoStyle.horizontal,
              size: 100,
            ),
          ),
          displayMode: PaneDisplayMode.compact,
          indicatorBuilder: ({
            required BuildContext context,
            int? index,
            required List<Offset> Function() offsets,
            required List<Size> Function() sizes,
            required Axis axis,
            required Widget child,
          }) {
            if (index == null) return child;
            assert(debugCheckHasFluentTheme(context));
            final theme = NavigationPaneTheme.of(context);
            switch (appTheme.indicator) {
              case NavigationIndicators.end:
                return EndNavigationIndicator(
                  index: index,
                  offsets: offsets,
                  sizes: sizes,
                  child: child,
                  color: theme.highlightColor,
                  curve: theme.animationCurve ?? Curves.linear,
                  axis: axis,
                );
              case NavigationIndicators.sticky:
                return NavigationPane.defaultNavigationIndicator(
                  index: index,
                  context: context,
                  offsets: offsets,
                  sizes: sizes,
                  axis: axis,
                  child: child,
                );
              default:
                return NavigationIndicator(
                  index: index,
                  offsets: offsets,
                  sizes: sizes,
                  child: child,
                  color: theme.highlightColor,
                  curve: theme.animationCurve ?? Curves.linear,
                  axis: axis,
                );
            }
          },
          items: [
            PaneItem(
              icon: const Icon(FluentIcons.checkbox_composite),
              title: const Text('Inputs'),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.text_field),
              title: const Text('Forms'),
            ),
            PaneItemSeparator(),
            PaneItem(
              icon: const Icon(FluentIcons.color),
              title: const Text('Colors'),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.plain_text),
              title: const Text('Typography'),
            ),
            PaneItem(
                icon: const Icon(FluentIcons.cell_phone),
                title: const Text('Mobile')),
            PaneItem(
              icon: Icon(
                appTheme.displayMode == PaneDisplayMode.top
                    ? FluentIcons.more
                    : FluentIcons.more_vertical,
              ),
              title: const Text('Others'),
            ),
          ],
          autoSuggestBox: AutoSuggestBox<String>(
            controller: TextEditingController(),
            items: const ['Item 1', 'Item 2', 'Item 3', 'Item 4'],
          ),
          autoSuggestBoxReplacement: const Icon(FluentIcons.search),
          footerItems: [
            PaneItemSeparator(),
            PaneItem(
                icon: const Icon(FluentIcons.settings),
                title: const Text('Settings')),
          ],
        ),
        content: NavigationBody(index: index, children: [
          const InputsPage(),
          const Forms(),
          ColorsPage(controller: colorsController),
          const TypographyPage(),
          const Mobile(),
          const Others(),
          Settings(controller: settingsController),
        ]),
      ),
    );
  }
}
