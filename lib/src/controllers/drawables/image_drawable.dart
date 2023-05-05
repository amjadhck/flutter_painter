import 'dart:ui';

import 'package:flutter/rendering.dart';

import 'object_drawable.dart';

/// A drawable of an image as an object.
class ImageDrawable extends ObjectDrawable {
  /// The image to be drawn.
  final Image image;

  /// Whether the image is flipped or not.
  final bool flipped;

  final String? imageString;

  final String id;

  /// Creates an [ImageDrawable] with the given [image].
  ImageDrawable({
    required Offset position,
    double rotationAngle = 0,
    double scale = 1,
    this.imageString = "",
    required this.id,
    Set<ObjectDrawableAssist> assists = const <ObjectDrawableAssist>{},
    Map<ObjectDrawableAssist, Paint> assistPaints =
        const <ObjectDrawableAssist, Paint>{},
    bool locked = false,
    bool hidden = false,
    required this.image,
    this.flipped = false,
  }) : super(
          position: position,
          rotationAngle: rotationAngle,
          scale: scale,
          assists: assists,
          assistPaints: assistPaints,
          hidden: hidden,
          locked: locked,
          //imageString: imageString,
        );

  /// Creates an [ImageDrawable] with the given [image], and calculates the scale based on the given [size].
  /// The scale will be calculated such that the size of the drawable fits into the provided size.
  ///
  /// For example, if the image was 512x256 and the provided size was 128x128, the scale would be 0.25,
  /// fitting the width of the image into the size (128x64).
  ImageDrawable.fittedToSize({
    required Offset position,
    required Size size,
    double rotationAngle = 0,
    Set<ObjectDrawableAssist> assists = const <ObjectDrawableAssist>{},
    Map<ObjectDrawableAssist, Paint> assistPaints =
        const <ObjectDrawableAssist, Paint>{},
    bool locked = false,
    bool hidden = false,
    required Image image,
    String? imageString,
    required String id,
    bool flipped = false,
  }) : this(
          position: position,
          rotationAngle: rotationAngle,
          scale: _calculateScaleFittedToSize(image, size),
          assists: assists,
          assistPaints: assistPaints,
          image: image,
          flipped: flipped,
          hidden: hidden,
          locked: locked,
          imageString: imageString,
          id: id,
        );

  /// Creates a copy of this but with the given fields replaced with the new values.
  @override
  ImageDrawable copyWith({
    bool? hidden,
    Set<ObjectDrawableAssist>? assists,
    Offset? position,
    double? rotation,
    double? scale,
    Image? image,
    bool? flipped,
    bool? locked,
    String? imageString,
    String? id,
  }) {
    return ImageDrawable(
      hidden: hidden ?? this.hidden,
      assists: assists ?? this.assists,
      position: position ?? this.position,
      rotationAngle: rotation ?? rotationAngle,
      scale: scale ?? this.scale,
      image: image ?? this.image,
      flipped: flipped ?? this.flipped,
      locked: locked ?? this.locked,
      imageString: imageString ?? this.imageString,
      id: id ?? this.id,
    );
  }

  /// Draws the image on the provided [canvas] of size [size].
  @override
  void drawObject(Canvas canvas, Size size) {
    final scaledSize =
        Offset(image.width.toDouble(), image.height.toDouble()) * scale;
    final position = this.position.scale(flipped ? -1 : 1, 1);

    if (flipped) canvas.scale(-1, 1);

    // Draw the image onto the canvas.
    canvas.drawImageRect(
        image,
        Rect.fromPoints(Offset.zero,
            Offset(image.width.toDouble(), image.height.toDouble())),
        Rect.fromPoints(position - scaledSize / 2, position + scaledSize / 2),
        Paint());
  }

  /// Calculates the size of the rendered object.
  @override
  Size getSize({double minWidth = 0.0, double maxWidth = double.infinity}) {
    return Size(
      image.width * scale,
      image.height * scale,
    );
  }

  @override
  String toString() {
    return 'ImageDrawable(id: $id, image: $image, imageString: $imageString, Position: $position, Scale: $scale, Rotation: $rotationAngle)';
  }

  /// Compares two [ImageDrawable]s for equality.
  // @override
  // bool operator ==(Object other) {
  //   return other is ImageDrawable &&
  //       super == other &&
  //       other.image == image;
  // }
  //
  // @override
  // int get hashCode => hashValues(
  //     hidden,
  //     hashList(assists),
  //     hashList(assistPaints.entries),
  //     position,
  //     rotationAngle,
  //     scale,
  //     image);

  static double _calculateScaleFittedToSize(Image image, Size size) {
    if (image.width >= image.height) {
      return size.width / image.width;
    } else {
      return size.height / image.height;
    }
  }
}
