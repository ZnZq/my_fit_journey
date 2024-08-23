import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/models/body_part.dart';
import 'package:my_fit_journey/widgets/svg_highlight.dart';

import 'dart:math' as math;

class BodyStructureSelectorController extends ChangeNotifier {
  final List<BodyPart> selectedParts = [];
}

class BodyStructureSelector extends StatefulWidget {
  final BodyStructureSelectorController? controller;
  final String frontSvg;
  final String backSvg;

  const BodyStructureSelector(
      {super.key,
      required this.frontSvg,
      required this.backSvg,
      this.controller});

  @override
  State<BodyStructureSelector> createState() => _BodyStructureSelectorState();
}

class _BodyStructureSelectorState extends State<BodyStructureSelector>
    with SingleTickerProviderStateMixin {
  late final List<BodyPart> selectedParts;
  final ScrollController _scrollController = ScrollController();

  late final Map<String, BodyGroup> bodyStructure;
  late final Map<String, BodyGroup> frontBodyStructure;
  late final Map<String, BodyGroup> backBodyStructure;
  late AnimationController _animationController;
  late Animation<double> _animation;

  String currentSvg = '';

  CancelableOperation<Null>? scrollBackFeature;
  bool isFrontView = true;

  @override
  void initState() {
    _initBodyStructure();

    selectedParts = widget.controller?.selectedParts ?? [];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    _scrollController.addListener(_onScroll);

    currentSvg = widget.frontSvg;

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.only(left: kGap),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: _buildBodyStructure(frontBodyStructure, true),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.loose,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.25,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.rotationY(_animation.value * math.pi),
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  child: SvgHighlight(
                    svgCode: currentSvg,
                    highlightParts: selectedParts.toList(),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.only(right: kGap),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: _buildBodyStructure(backBodyStructure, false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    var previousIsFrontView = isFrontView;
    var percentage = _scrollController.position.pixels /
        _scrollController.position.maxScrollExtent;
    isFrontView = percentage <= 0.5;
    if (isFrontView) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    _animationController.stop();
    _animationController.value = percentage;

    if (previousIsFrontView != isFrontView) {
      setState(() {
        currentSvg = isFrontView ? widget.frontSvg : widget.backSvg;
      });
    }
  }

  void _initBodyStructure() {
    bodyStructure = getBodyStructure();
    frontBodyStructure = bodyStructure.map((key, value) {
      return MapEntry(
          key,
          BodyGroup(
            title: value.title,
            children: Map.fromEntries(
              value.children.entries
                  .where((e) => e.value.position == BodyPartPosition.front),
            ),
          ));
    });
    backBodyStructure = bodyStructure.map((key, value) {
      return MapEntry(
          key,
          BodyGroup(
            title: value.title,
            children: Map.fromEntries(value.children.entries
                .where((e) => e.value.position == BodyPartPosition.back)),
          ));
    });
  }

  Widget _buildBodyStructure(
      Map<String, BodyGroup> bodyStructure, bool isFront) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var group in bodyStructure.entries)
            Column(
              children: [
                _buildBodyGroupHeader(group, isFront),
                for (var part in group.value.children.entries)
                  _buildBodyPartSelector(part, isFront),
              ],
            ),
        ],
      ),
    );
  }

  bool _onScrollNotification(notification) {
    if (notification is ScrollStartNotification) {
      scrollBackFeature?.cancel();
    } else if (notification is ScrollEndNotification &&
        !_scrollController.position.atEdge) {
      var percentage = _scrollController.position.pixels /
          _scrollController.position.maxScrollExtent;

      scrollBackFeature = CancelableOperation.fromFuture(
          Future.delayed(const Duration(milliseconds: 0), () {}));
      scrollBackFeature!.value.then((s) {
        _scrollController.animateTo(
          percentage <= 0.5
              ? _scrollController.position.minScrollExtent
              : _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }

    return true;
  }

  Widget _buildBodyGroupHeader(
      MapEntry<String, BodyGroup> group, bool isFront) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.indigo,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: isFront ? const Radius.circular(18) : Radius.zero,
            bottomRight: isFront ? const Radius.circular(18) : Radius.zero,
            topLeft: isFront ? Radius.zero : const Radius.circular(18),
            bottomLeft: isFront ? Radius.zero : const Radius.circular(18),
          ),
          color: Colors.white,
        ),
        margin: EdgeInsets.fromLTRB(
            isFront ? kGap * 3 : 2, 2, isFront ? 2 : kGap * 3, 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          group.value.title.i18n(),
          textAlign: isFront ? TextAlign.left : TextAlign.right,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildBodyPartSelector(MapEntry<String, BodyPart> part, bool isFront) {
    return ListTile(
      contentPadding: EdgeInsets.only(
          left: isFront ? kGap * 3 : 0, right: isFront ? 0 : kGap * 3),
      leading: isFront
          ? (selectedParts.contains(part.value)
              ? const Icon(Icons.circle_rounded, color: Colors.indigo)
              : const Icon(Icons.circle_outlined, color: Colors.indigo))
          : null,
      trailing: isFront
          ? null
          : (selectedParts.contains(part.value)
              ? const Icon(Icons.circle_rounded, color: Colors.indigo)
              : const Icon(Icons.circle_outlined, color: Colors.indigo)),
      onTap: () {
        setState(() {
          if (selectedParts.contains(part.value)) {
            selectedParts.remove(part.value);
          } else {
            selectedParts.add(part.value);
          }
        });
      },
      title: Text(part.value.title.i18n(),
          textAlign: isFront ? TextAlign.left : TextAlign.right),
    );
  }
}
