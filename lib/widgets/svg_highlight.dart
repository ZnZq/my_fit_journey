import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_fit_journey/models/body_part.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class SvgHighlight extends StatelessWidget {
  final String svgCode;
  final List<BodyPart> highlightParts;
  final Color highlightColor;

  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final bool matchTextDirection;
  final bool allowDrawingOutsideViewBox;
  final WidgetBuilder? placeholderBuilder;
  final String? semanticsLabel;
  final bool excludeFromSemantics;
  final Clip clipBehavior;

  const SvgHighlight({
    super.key,
    required this.svgCode,
    this.highlightParts = const [],
    this.highlightColor = Colors.red,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.matchTextDirection = false,
    this.allowDrawingOutsideViewBox = false,
    this.placeholderBuilder,
    this.semanticsLabel,
    this.excludeFromSemantics = false,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  Widget build(BuildContext context) {
    if (svgCode.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final svg = prepareSvg(svgCode);

    return SvgPicture.string(
      svg.toString(),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      matchTextDirection: matchTextDirection,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
    );
  }

  String prepareSvg(String svgCode) {
    final document = XmlDocument.parse(svgCode);

    for (var part in highlightParts) {
      final nodes = document.xpath(part.path);
      for (var node in nodes) {
        var hexString = highlightColor.value.toRadixString(16);
        node.setAttribute(
            'fill', '#${hexString.substring(2, hexString.length)}');
      }
    }

    return document.toString();
  }
}
