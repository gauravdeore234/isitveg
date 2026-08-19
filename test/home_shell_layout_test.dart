import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:is_it_veg/config/theme.dart';
import 'package:is_it_veg/widgets/app_bottom_nav.dart';

/// Regression cover for a layout collapse that only showed up on a real device.
///
/// Scaffold measures `bottomNavigationBar` with *loose* constraints up to the
/// full screen height, so an `Align`/`Center` without a `heightFactor` inside
/// the bar expands to fill the entire screen: the bar painted over everything
/// and the body was squeezed to zero height. Widget tests of the individual
/// screens could not catch it, because none of them exercised the Scaffold
/// slot the bar actually lives in.
void main() {
  for (final size in [
    const Size(1080, 2424), // Pixel 9
    const Size(960, 1704), // short, dense
  ]) {
    testWidgets('nav bar hugs its row, body keeps the rest @ $size',
        (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 3.0;
      tester.view.padding = const FakeViewPadding(top: 72, bottom: 48);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: const SizedBox.expand(
            key: Key('body'),
            child: ColoredBox(color: Colors.black),
          ),
          bottomNavigationBar: AppBottomNav(
            currentIndex: 0,
            onTap: (_) {},
            items: AppBottomNav.defaultItems,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final screen = tester.view.physicalSize / tester.view.devicePixelRatio;
      final nav = tester.getSize(find.byType(AppBottomNav));
      final body = tester.getSize(find.byKey(const Key('body')));
      final navTop = tester.getTopLeft(find.byType(AppBottomNav)).dy;

      // The bar is a bar, not a canvas.
      expect(nav.height, lessThan(120));
      // The body keeps everything else.
      expect(body.height, greaterThan(screen.height * 0.7));
      // And the bar sits on the bottom edge.
      expect(navTop + nav.height, moreOrLessEquals(screen.height));
    });
  }

  testWidgets('every destination stays reachable at 320dp', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    var tapped = -1;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: const SizedBox.expand(),
        bottomNavigationBar: AppBottomNav(
          currentIndex: 0,
          onTap: (i) => tapped = i,
          items: AppBottomNav.defaultItems,
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    for (var i = 0; i < AppBottomNav.defaultItems.length; i++) {
      await tester.tap(find.text(AppBottomNav.defaultItems[i].label));
      await tester.pump();
      expect(tapped, i);
    }
  });
}
