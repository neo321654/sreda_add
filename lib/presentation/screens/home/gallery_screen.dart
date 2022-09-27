import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoScreen extends StatefulWidget {
  GalleryPhotoScreen({
    Key? key,
    this.loadingBuilder,
    this.minScale,
    this.maxScale,
    required this.initialIndex,
    required this.images,
    this.onDelete,
  })  : pageController = PageController(initialPage: initialIndex),
        super(key: key);

  final LoadingBuilder? loadingBuilder;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<String> images;
  final Function(int index)? onDelete;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoScreenState();
  }
}

class _GalleryPhotoScreenState extends State<GalleryPhotoScreen> {
  int? currentIndex;

  @override
  void initState() {
    _hideStatusBar();
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    if (mounted) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  dispose() {
    _showStatusBar();
    super.dispose();
  }

  _showStatusBar() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  _hideStatusBar() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.black),
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: Dismissible(
              key: Key('photo_gallery'),
              direction: DismissDirection.down,
              onDismissed: (direction) {
                if (direction == DismissDirection.down) {
                  Navigator.of(context).pop();
                }
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  PhotoViewGallery.builder(
                    scrollPhysics: BouncingScrollPhysics(),
                    builder: _buildItem,
                    itemCount: widget.images.length,
                    loadingBuilder: widget.loadingBuilder,
                    backgroundDecoration: BoxDecoration(color: Colors.black),
                    pageController: widget.pageController,
                    onPageChanged: onPageChanged,
                    enableRotation: false,
                    gaplessPlayback: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "${currentIndex! + 1} / ${widget.images.length}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        decoration: null,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Row(
              children: [
                if (widget.onDelete != null)
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          color: Colors.white,
                          onPressed: () {
                            widget.onDelete!(currentIndex!);
                            Navigator.of(context).pop(true);
                          }),
                    ),
                  ),
                ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = widget.images[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: CachedNetworkImageProvider(item),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item),
    );
  }
}
