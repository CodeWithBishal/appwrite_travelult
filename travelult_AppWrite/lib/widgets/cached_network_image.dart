import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'img_error_widget.dart';

class CachedImageNetworkimage extends StatefulWidget {
  final String url;
  final double width;
  final bool isBorder;
  const CachedImageNetworkimage({
    Key? key,
    required this.url,
    required this.width,
    required this.isBorder,
  }) : super(key: key);

  @override
  State<CachedImageNetworkimage> createState() =>
      _CachedImageNetworkimageState();
}

class _CachedImageNetworkimageState extends State<CachedImageNetworkimage> {
  @override
  Widget build(BuildContext context) {
    return widget.url.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: widget.url,
            fit: BoxFit.cover,
            width: widget.width - widget.width / 10,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: widget.isBorder
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      )
                    : const BorderRadius.all(Radius.zero),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Shimmer.fromColors(
              baseColor: (Colors.grey[300])!,
              highlightColor: (Colors.grey[100])!,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.black12,
                  ),
                  value: downloadProgress.progress,
                ),
              ),
            ),
            errorWidget: (context, url, error) => imageErrorWidget(),
            color: Colors.transparent,
          )
        : imageErrorWidget();
  }
}
