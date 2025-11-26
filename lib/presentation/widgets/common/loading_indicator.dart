import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final double? size;
  final double? strokeWidth;

  const LoadingIndicator({
    Key? key,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
    this.size,
    this.strokeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size ?? 50,
              height: size ?? 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  indicatorColor ?? Theme.of(context).primaryColor,
                ),
                strokeWidth: strokeWidth ?? 4.0,
              ),
            ),
            if (message != null) ...[
              SizedBox(height: 16),
              Text(
                message!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SmallLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? size;
  final double? strokeWidth;

  const SmallLoadingIndicator({
    Key? key,
    this.color,
    this.size,
    this.strokeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 20,
      height: size ?? 20,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).primaryColor,
        ),
        strokeWidth: strokeWidth ?? 2.0,
      ),
    );
  }
}

class ButtonLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? size;

  const ButtonLoadingIndicator({
    Key? key,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 20,
      height: size ?? 20,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Colors.white,
        ),
        strokeWidth: 2.0,
      ),
    );
  }
}

class LinearLoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? valueColor;
  final double? height;

  const LinearLoadingIndicator({
    Key? key,
    this.message,
    this.backgroundColor,
    this.valueColor,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message != null) ...[
          Text(
            message!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
        ],
        LinearProgressIndicator(
          backgroundColor: backgroundColor ?? Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            valueColor ?? Theme.of(context).primaryColor,
          ),
          minHeight: height ?? 4.0,
        ),
      ],
    );
  }
}

class DotLoadingIndicator extends StatefulWidget {
  final Color? color;
  final double? dotSize;
  final Duration? duration;

  const DotLoadingIndicator({
    Key? key,
    this.color,
    this.dotSize,
    this.duration,
  }) : super(key: key);

  @override
  _DotLoadingIndicatorState createState() => _DotLoadingIndicatorState();
}

class _DotLoadingIndicatorState extends State<DotLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Opacity(
                opacity: _getOpacityForDot(index),
                child: Container(
                  width: widget.dotSize ?? 8,
                  height: widget.dotSize ?? 8,
                  decoration: BoxDecoration(
                    color: widget.color ?? Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  double _getOpacityForDot(int index) {
    final value = _animation.value;
    if (index == 0) return value;
    if (index == 1) return (value + 0.3).clamp(0.0, 1.0);
    if (index == 2) return (value + 0.6).clamp(0.0, 1.0);
    return value;
  }
}

class ShimmerLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }
}

class FullScreenLoading extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? customIndicator;

  const FullScreenLoading({
    Key? key,
    this.title,
    this.subtitle,
    this.customIndicator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customIndicator ?? 
            LoadingIndicator(
              size: 60,
              strokeWidth: 5,
            ),
            if (title != null) ...[
              SizedBox(height: 24),
              Text(
                title!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
            if (subtitle != null) ...[
              SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ListLoadingShimmer extends StatelessWidget {
  final int itemCount;
  final bool hasLeading;
  final bool hasTrailing;

  const ListLoadingShimmer({
    Key? key,
    this.itemCount = 5,
    this.hasLeading = true,
    this.hasTrailing = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (hasLeading) ...[
                ShimmerLoading(
                  width: 50,
                  height: 50,
                  borderRadius: BorderRadius.circular(25),
                ),
                SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoading(
                      width: double.infinity,
                      height: 16,
                    ),
                    SizedBox(height: 8),
                    ShimmerLoading(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 14,
                    ),
                    SizedBox(height: 4),
                    ShimmerLoading(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 12,
                    ),
                  ],
                ),
              ),
              if (hasTrailing) ...[
                SizedBox(width: 16),
                ShimmerLoading(
                  width: 24,
                  height: 24,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class GridLoadingShimmer extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;

  const GridLoadingShimmer({
    Key? key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ShimmerLoading(
                  width: double.infinity,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoading(
                      width: double.infinity,
                      height: 16,
                    ),
                    SizedBox(height: 8),
                    ShimmerLoading(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 14,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerLoading(
                          width: 60,
                          height: 20,
                        ),
                        ShimmerLoading(
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// استخدامات متقدمة
class AdaptiveLoadingIndicator extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget? loadingWidget;
  final String? loadingMessage;

  const AdaptiveLoadingIndicator({
    Key? key,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.loadingMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: LoadingIndicator(
              message: loadingMessage,
              backgroundColor: Colors.black54,
            ),
          ),
      ],
    );
  }
}

class ConditionalLoading extends StatelessWidget {
  final bool condition;
  final Widget loadingChild;
  final Widget child;

  const ConditionalLoading({
    Key? key,
    required this.condition,
    required this.loadingChild,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return condition ? loadingChild : child;
  }
}