import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shukhee_ui_component/shukhee_ui_component.dart';

void main() {
  const List<TargetPlatform> bothLooks = <TargetPlatform>[
    TargetPlatform.android,
    TargetPlatform.iOS,
  ];

  /// Wraps [indicator] in a minimal app running on [platform].
  Widget wrap(CustomRefreshIndicator indicator, {TargetPlatform? platform}) {
    return MaterialApp(
      theme: platform == null ? null : ThemeData(platform: platform),
      home: Scaffold(body: indicator),
    );
  }

  /// An idle Cupertino control has no extent, and the default finder skips
  /// slivers the viewport reports as invisible.
  Finder findCupertinoControl() =>
      find.byType(CupertinoSliverRefreshControl, skipOffstage: false);

  /// Drags the list down far enough to pass either trigger distance.
  Future<void> pullDown(WidgetTester tester) async {
    await tester.fling(find.byType(Scrollable), const Offset(0, 300), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  group('platform', () {
    testWidgets('uses the Material indicator on Android', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomRefreshIndicator(
            onRefresh: () async {},
            child: const SizedBox(height: 1000),
          ),
          platform: TargetPlatform.android,
        ),
      );

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(findCupertinoControl(), findsNothing);
    });

    for (final TargetPlatform platform in <TargetPlatform>[
      TargetPlatform.iOS,
      TargetPlatform.macOS,
    ]) {
      testWidgets('uses the Cupertino control on $platform', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          wrap(
            CustomRefreshIndicator(
              onRefresh: () async {},
              child: const SizedBox(height: 1000),
            ),
            platform: platform,
          ),
        );

        expect(findCupertinoControl(), findsOneWidget);
        expect(find.byType(RefreshIndicator), findsNothing);
      });
    }

    testWidgets('falls back to Material off the Apple platforms', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomRefreshIndicator(
            onRefresh: () async {},
            child: const SizedBox(height: 1000),
          ),
          platform: TargetPlatform.windows,
        ),
      );

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('style forces Material on iOS', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          CustomRefreshIndicator(
            onRefresh: () async {},
            style: RefreshIndicatorStyle.material,
            child: const SizedBox(height: 1000),
          ),
          platform: TargetPlatform.iOS,
        ),
      );

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(findCupertinoControl(), findsNothing);
    });

    testWidgets('style forces Cupertino on Android', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomRefreshIndicator(
            onRefresh: () async {},
            style: RefreshIndicatorStyle.cupertino,
            child: const SizedBox(height: 1000),
          ),
          platform: TargetPlatform.android,
        ),
      );

      expect(findCupertinoControl(), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsNothing);
    });
  });

  group('refresh', () {
    for (final TargetPlatform platform in bothLooks) {
      testWidgets('a pull calls onRefresh on $platform', (
        WidgetTester tester,
      ) async {
        int calls = 0;
        final Completer<void> refresh = Completer<void>();
        await tester.pumpWidget(
          wrap(
            CustomRefreshIndicator(
              onRefresh: () {
                calls++;
                return refresh.future;
              },
              child: const SizedBox(height: 1000),
            ),
            platform: platform,
          ),
        );

        await pullDown(tester);
        expect(calls, 1);

        refresh.complete();
        await tester.pumpAndSettle();
      });

      testWidgets('a resting list does not refresh on $platform', (
        WidgetTester tester,
      ) async {
        int calls = 0;
        await tester.pumpWidget(
          wrap(
            CustomRefreshIndicator(
              onRefresh: () async => calls++,
              child: const SizedBox(height: 1000),
            ),
            platform: platform,
          ),
        );

        // Scrolling up, away from the edge, is not a pull.
        await tester.fling(find.byType(Scrollable), const Offset(0, -200), 800);
        await tester.pumpAndSettle();
        expect(calls, 0);
      });

      testWidgets(
        'a child shorter than the viewport can still be pulled on $platform',
        (WidgetTester tester) async {
          int calls = 0;
          await tester.pumpWidget(
            wrap(
              CustomRefreshIndicator(
                onRefresh: () async => calls++,
                // Only AlwaysScrollableScrollPhysics makes this draggable.
                child: const SizedBox(height: 20),
              ),
              platform: platform,
            ),
          );

          await pullDown(tester);
          await tester.pumpAndSettle();
          expect(calls, 1);
        },
      );
    }

    testWidgets('the Material indicator stays up until the future completes', (
      WidgetTester tester,
    ) async {
      final Completer<void> refresh = Completer<void>();
      await tester.pumpWidget(
        wrap(
          CustomRefreshIndicator(
            onRefresh: () => refresh.future,
            child: const SizedBox(height: 1000),
          ),
          platform: TargetPlatform.android,
        ),
      );

      await pullDown(tester);
      expect(find.byType(RefreshProgressIndicator), findsOneWidget);

      refresh.complete();
      await tester.pumpAndSettle();
      expect(find.byType(RefreshProgressIndicator), findsNothing);
    });

    testWidgets('the Cupertino control stays up until the future completes', (
      WidgetTester tester,
    ) async {
      final Completer<void> refresh = Completer<void>();
      await tester.pumpWidget(
        wrap(
          CustomRefreshIndicator(
            onRefresh: () => refresh.future,
            child: const SizedBox(height: 1000),
          ),
          platform: TargetPlatform.iOS,
        ),
      );

      await pullDown(tester);
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);

      refresh.complete();
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoActivityIndicator), findsNothing);
    });
  });

  group('content', () {
    for (final TargetPlatform platform in bothLooks) {
      testWidgets('renders the child on $platform', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          wrap(
            CustomRefreshIndicator(
              onRefresh: () async {},
              child: const Text('body'),
            ),
            platform: platform,
          ),
        );

        expect(find.text('body'), findsOneWidget);
      });

      testWidgets('the child fills the width on $platform', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          wrap(
            CustomRefreshIndicator(
              onRefresh: () async {},
              child: const Text('body'),
            ),
            platform: platform,
          ),
        );

        expect(
          tester.getSize(find.byType(Text)).width,
          tester.getSize(find.byType(CustomRefreshIndicator)).width,
        );
      });

      testWidgets('slivers build lazily on $platform', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          wrap(
            CustomRefreshIndicator.slivers(
              onRefresh: () async {},
              slivers: <Widget>[
                SliverList.builder(
                  itemCount: 500,
                  itemBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 100, child: Text('item $index')),
                ),
              ],
            ),
            platform: platform,
          ),
        );

        expect(find.text('item 0'), findsOneWidget);
        expect(find.text('item 499'), findsNothing);
      });

      testWidgets('a sliver pull calls onRefresh on $platform', (
        WidgetTester tester,
      ) async {
        int calls = 0;
        await tester.pumpWidget(
          wrap(
            CustomRefreshIndicator.slivers(
              onRefresh: () async => calls++,
              slivers: <Widget>[
                const SliverToBoxAdapter(child: SizedBox(height: 1000)),
              ],
            ),
            platform: platform,
          ),
        );

        await pullDown(tester);
        await tester.pumpAndSettle();
        expect(calls, 1);
      });
    }

    testWidgets('the Cupertino control sits above the content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomRefreshIndicator.slivers(
            onRefresh: () async {},
            slivers: <Widget>[
              const SliverToBoxAdapter(child: Text('first row')),
            ],
          ),
          platform: TargetPlatform.iOS,
        ),
      );

      final CustomScrollView view = tester.widget<CustomScrollView>(
        find.byType(CustomScrollView),
      );
      expect(view.slivers.first, isA<CupertinoSliverRefreshControl>());
      expect(view.slivers, hasLength(2));
    });
  });

  group('customisation', () {
    testWidgets('forwards the Material styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          CustomRefreshIndicator(
            onRefresh: () async {},
            color: const Color(0xFF00AAD0),
            backgroundColor: const Color(0xFFEEEEEE),
            displacement: 80,
            child: const SizedBox(height: 1000),
          ),
          platform: TargetPlatform.android,
        ),
      );

      final RefreshIndicator indicator = tester.widget<RefreshIndicator>(
        find.byType(RefreshIndicator),
      );
      expect(indicator.color, const Color(0xFF00AAD0));
      expect(indicator.backgroundColor, const Color(0xFFEEEEEE));
      expect(indicator.displacement, 80);
    });

    testWidgets('forwards the Cupertino distances', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomRefreshIndicator(
            onRefresh: () async {},
            triggerPullDistance: 200,
            indicatorExtent: 80,
            child: const SizedBox(height: 1000),
          ),
          platform: TargetPlatform.iOS,
        ),
      );

      final CupertinoSliverRefreshControl control = tester
          .widget<CupertinoSliverRefreshControl>(findCupertinoControl());
      expect(control.refreshTriggerPullDistance, 200);
      expect(control.refreshIndicatorExtent, 80);
    });

    testWidgets('draws the Cupertino loader from the given builder', (
      WidgetTester tester,
    ) async {
      final Completer<void> refresh = Completer<void>();
      await tester.pumpWidget(
        wrap(
          CustomRefreshIndicator(
            onRefresh: () => refresh.future,
            cupertinoIndicatorBuilder:
                (
                  BuildContext context,
                  RefreshIndicatorMode mode,
                  double pulledExtent,
                  double triggerExtent,
                  double indicatorExtent,
                ) => const Center(child: Text('pulling')),
            child: const SizedBox(height: 1000),
          ),
          platform: TargetPlatform.iOS,
        ),
      );

      await pullDown(tester);
      expect(find.text('pulling'), findsOneWidget);
      expect(find.byType(CupertinoActivityIndicator), findsNothing);

      refresh.complete();
      await tester.pumpAndSettle();
    });

    for (final TargetPlatform platform in bothLooks) {
      testWidgets(
        'defaults to always-scrollable bouncing physics on $platform',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            wrap(
              CustomRefreshIndicator(
                onRefresh: () async {},
                child: const SizedBox(height: 1000),
              ),
              platform: platform,
            ),
          );

          final CustomScrollView view = tester.widget<CustomScrollView>(
            find.byType(CustomScrollView),
          );
          expect(view.physics, CustomRefreshIndicator.defaultPhysics);
        },
      );

      testWidgets('honours custom physics on $platform', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          wrap(
            CustomRefreshIndicator(
              onRefresh: () async {},
              physics: const ClampingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: const SizedBox(height: 1000),
            ),
            platform: platform,
          ),
        );

        final CustomScrollView view = tester.widget<CustomScrollView>(
          find.byType(CustomScrollView),
        );
        expect(view.physics, isA<ClampingScrollPhysics>());
      });

      testWidgets('drives the given controller on $platform', (
        WidgetTester tester,
      ) async {
        final ScrollController controller = ScrollController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          wrap(
            CustomRefreshIndicator(
              onRefresh: () async {},
              scrollController: controller,
              child: const SizedBox(height: 2000),
            ),
            platform: platform,
          ),
        );

        controller.jumpTo(300);
        await tester.pump();
        expect(controller.offset, 300);
      });
    }
  });
}
