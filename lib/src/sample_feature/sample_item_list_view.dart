import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';
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
class SampleItemListView extends StatefulWidget {
  const SampleItemListView({
    Key? key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  }) : super(key: key);

  static const routeName = '/';

  final List<SampleItem> items;

  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  bool value = false;

  int index = 0;

  final colorsController = ScrollController();
  final settingsController = ScrollController();
  @override
  void dispose() {
    colorsController.dispose();
    settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    return NavigationView(
      appBar: NavigationAppBar(
        // height: !kIsWeb ? appWindow.titleBarHeight : 31.0,
        title: () {
          if (kIsWeb) return const Text(appTitle);
          return MoveWindow(
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(appTitle),
            ),
          );
        }(),
        actions: kIsWeb
            ? null
            : MoveWindow(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // children: const [Spacer(), WindowButtons()],
                  children: const [Spacer()],
                ),
              ),
      ),
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
        displayMode: appTheme.displayMode,
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
          // It doesn't look good when resizing from compact to open
          // PaneItemHeader(header: Text('User Interaction')),
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
    );
  }
}


// class WindowButtons extends StatelessWidget {
//   const WindowButtons({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     assert(debugCheckHasFluentTheme(context));
//     assert(debugCheckHasFluentLocalizations(context));
//     final ThemeData theme = FluentTheme.of(context);
//     final buttonColors = WindowButtonColors(
//       iconNormal: theme.inactiveColor,
//       iconMouseDown: theme.inactiveColor,
//       iconMouseOver: theme.inactiveColor,
//       mouseOver: ButtonThemeData.buttonColor(
//           theme.brightness, {ButtonStates.hovering}),
//       mouseDown: ButtonThemeData.buttonColor(
//           theme.brightness, {ButtonStates.pressing}),
//     );
//     final closeButtonColors = WindowButtonColors(
//       mouseOver: Colors.red,
//       mouseDown: Colors.red.dark,
//       iconNormal: theme.inactiveColor,
//       iconMouseOver: Colors.red.basedOnLuminance(),
//       iconMouseDown: Colors.red.dark.basedOnLuminance(),
//     );
//     return Row(children: [
//       Tooltip(
//         message: FluentLocalizations.of(context).minimizeWindowTooltip,
//         child: MinimizeWindowButton(colors: buttonColors),
//       ),
//       Tooltip(
//         message: FluentLocalizations.of(context).restoreWindowTooltip,
//         child: WindowButton(
//           colors: buttonColors,
//           iconBuilder: (context) {
//             if (appWindow.isMaximized) {
//               return RestoreIcon(color: context.iconColor);
//             }
//             return MaximizeIcon(color: context.iconColor);
//           },
//           onPressed: appWindow.maximizeOrRestore,
//         ),
//       ),
//       Tooltip(
//         message: FluentLocalizations.of(context).closeWindowTooltip,
//         child: CloseWindowButton(colors: closeButtonColors),
//       ),
//     ]);
//   }
// }
