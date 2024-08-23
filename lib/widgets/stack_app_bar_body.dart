import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_fit_journey/const.dart';

class StackAppBarBody extends StatefulWidget {
  final Widget body;
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final double? defaultAppBarHeight;
  final bool isLargeTitle;
  final Widget? titleWidget;

  const StackAppBarBody({
    super.key,
    required this.body,
    this.title = '',
    this.isLargeTitle = true,
    this.leading,
    this.trailing,
    this.defaultAppBarHeight,
    this.titleWidget,
  });

  @override
  State<StackAppBarBody> createState() => _StackAppBarBodyState();
}

class _StackAppBarBodyState extends State<StackAppBarBody> {
  final GlobalKey _containerKey = GlobalKey();
  double _containerHeight = 0;

  @override
  void initState() {
    super.initState();
    _containerHeight = widget.defaultAppBarHeight ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calcContainerHeight();
    });
  }

  double? _getContainerHeight() {
    final renderBox = _containerKey.currentContext?.findRenderObject();
    if (renderBox is RenderBox) {
      final height = renderBox.size.height;
      return height;
    }

    return null;
  }

  void _calcContainerHeight() {
    final height = _getContainerHeight();
    if (height != null) {
      setState(() => _containerHeight = height);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final appBarHeight =
    //     _getContainerHeight() ?? widget.defaultAppBarHeight ?? 0;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.only(top: max(_containerHeight - kGap, 0)),
                decoration: const BoxDecoration(),
                child: widget.body,
              ),
            ),
          ],
        ),
        Container(
          key: _containerKey,
          decoration: const BoxDecoration(
            color: kBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: kDarkShadowColor,
                offset: Offset(2, 2),
                spreadRadius: 1,
                blurRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(kGap * 2),
            child: Row(
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: kGap),
                ],
                if (widget.titleWidget != null) widget.titleWidget!,
                if (widget.titleWidget == null) ...[
                  Text(
                    widget.title,
                    style: widget.isLargeTitle
                        ? Theme.of(context).textTheme.headlineLarge
                        : Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                ],
                if (widget.trailing != null) ...[
                  widget.trailing!,
                  const SizedBox(width: kGap),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
