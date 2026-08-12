import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum RefreshIndicatorStyle {
  adaptive,
  material,
  cupertino,
}

class CustomRefreshIndicator extends StatelessWidget {
  const CustomRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.scrollController,
    this.style = RefreshIndicatorStyle.adaptive,
    this.physics,
    this.color,
    this.backgroundColor,
    this.triggerPullDistance = 120,
    this.indicatorExtent = 60,
    this.displacement = 40,
    this.cupertinoIndicatorBuilder, 
  }) : slivers = null; 

  const CustomRefreshIndicator.slivers({
    super.key,
    required this.onRefresh,
    required this.slivers,
    this.scrollController,
    this.style = RefreshIndicatorStyle.adaptive,
    this.physics,
    this.color,
    this.backgroundColor,
    this.triggerPullDistance = 120,
    this.indicatorExtent = 60,
    this.displacement = 40,
    this.cupertinoIndicatorBuilder,
  }) : child = null;

  final Future<void> Function() onRefresh;
  final Widget? child;
  final List<Widget>? slivers;
  final ScrollController? scrollController;
  final RefreshIndicatorStyle style;
  final ScrollPhysics? physics;
  /// Material loader color.
  final Color? color;
  /// Material loader background color.
  final Color? backgroundColor;
  /// Distance required to trigger refresh on iOS/macOS.
  final double triggerPullDistance;
  /// Space occupied by the Cupertino refresh indicator.
  final double indicatorExtent;
  /// Material indicator displacement.
  final double displacement;
  /// Custom Cupertino loader.
  final RefreshControlIndicatorBuilder? cupertinoIndicatorBuilder;

  static const ScrollPhysics defaultPhysics = BouncingScrollPhysics(
    parent: AlwaysScrollableScrollPhysics(),
  );

  @override
  Widget build(BuildContext context) {
    final useCupertino = _shouldUseCupertino(context);

    return useCupertino ? _buildCupertino() : _buildMaterial();
  }

  bool _shouldUseCupertino(BuildContext context) {
    switch (style) {
      case RefreshIndicatorStyle.material:
        return false;

      case RefreshIndicatorStyle.cupertino:
        return true;

      case RefreshIndicatorStyle.adaptive:
        final platform = Theme.of(context).platform;

        return platform == TargetPlatform.iOS ||
            platform == TargetPlatform.macOS;
    }
  }

  Widget _buildMaterial() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color,
      backgroundColor: backgroundColor,
      displacement: displacement,
      child: _buildScrollView(),
    );
  }

  Widget _buildCupertino() {
    return _buildScrollView(
      extraSlivers: [
        CupertinoSliverRefreshControl(
          onRefresh: onRefresh,
          refreshTriggerPullDistance: triggerPullDistance,
          refreshIndicatorExtent: indicatorExtent,
          builder: cupertinoIndicatorBuilder ??
              CupertinoSliverRefreshControl.buildRefreshIndicator,
        ),
      ],
    );
  }

  Widget _buildScrollView({
    List<Widget> extraSlivers = const [],
  }) {
    final contentSlivers = slivers ??
        [
          SliverToBoxAdapter(
            child: child,
          ),
        ];

    return CustomScrollView(
      controller: scrollController,
      physics: physics ?? defaultPhysics,
      slivers: [
        ...extraSlivers,
        ...contentSlivers,
      ],
    );
  }
}