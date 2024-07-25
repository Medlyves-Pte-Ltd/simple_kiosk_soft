import 'dart:io';
import 'package:flutter/material.dart';

// 图片来源
enum ImageSource {
  Network, // 网络
  File, // 文件
  Asset // 项目
}

class ZoomImage extends StatefulWidget {
  ZoomImage(
      {super.key,
      this.url,
      this.size,
      this.imageSource = ImageSource.Asset,
      this.isEnlarge = false});
  final size;
  final url;
  bool isEnlarge = false;
  ImageSource imageSource = ImageSource.Asset;

  @override
  State<StatefulWidget> createState() => _ZoomImage();
}

class _ZoomImage extends State<ZoomImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  // 默认不缩放
  Offset _offset = Offset.zero;
  double _scale = 1.0;

  late Offset _normalizedOffset;
  late double _previousScale;
  final _kMinFlingVelocity = 600.0;

  @override
  void initState() {
    super.initState();
    _setImageSize();

    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      setState(() {
        _offset = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Offset _clampOffset(Offset offset) {
    Size? size = context.size;
    // widget的屏幕宽度
    final Offset minOffset = Offset(size!.width, size!.height) * (1.0 - _scale);
    // 限制他的最小尺寸
    return Offset(
        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }

  _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // 计算图片放大后的位置
      _controller.stop();
    });
  }

  _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 3.0);
      // 限制放大倍数 1~3倍
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
      // 更新当前位置
    });
  }

  _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distanceSquared;
    if (magnitude < _kMinFlingVelocity) return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    // 计算当前的方向
    final double distance = (Offset.zero & context.size!).shortestSide;
    // 计算放大倍速，并相应的放大宽和高，比如原来是600*480的图片，放大后倍数为1.25倍时，宽和高是同时变化的
    _animation = _controller.drive(Tween<Offset>(
        begin: _offset, end: _clampOffset(_offset + direction * distance)));
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  _onDoubleTap() {
    widget.isEnlarge = !widget.isEnlarge;
    _setImageSize();
    setState(() {});
  }

  _onTap() {
    Navigator.of(context).pop();
  }

  _setImageSize() {
    if (widget.isEnlarge) {
      _scale = 2.0;
      _offset = Offset(-(context.size!.width / 2), -(context.size!.height / 2));
    } else {
      _scale = 1.0;
      _offset = Offset.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _bodyView();
  }

  Widget _buildImage() {
    switch (widget.imageSource) {
      case ImageSource.File:
        return Image.file(File(widget.url), fit: BoxFit.contain);
      case ImageSource.Network:
        return Image.network(widget.url, fit: BoxFit.contain);
      case ImageSource.Asset:
        return Image.asset(widget.url, fit: BoxFit.contain);
    }
  }

  _bodyView() {
    return GestureDetector(
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleOnScaleUpdate,
      onScaleEnd: _handleOnScaleEnd,
      onDoubleTap: _onDoubleTap,
      onTap: _onTap,
      child: SizedBox.expand(
        child: ClipRect(
          child: Transform(
            transform: Matrix4.identity()
              ..translate(_offset.dx, _offset.dy)
              ..scale(_scale),
            child: _buildImage(),
          ),
        ),
      ),
    );
  }
}
