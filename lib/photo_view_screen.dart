import 'package:flutter/material.dart';
import 'package:photoapp/photo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoapp/providers.dart';

class PhotoViewScreen extends StatefulWidget {
  const PhotoViewScreen({
    Key? key,
    // required を付けると必須パラメータという意味になる
    required this.photo,
    required this.photoList,
  }) : super(key: key);

  // 最初に表示する画像のURLを受け取る
  final Photo photo;
  final List<Photo> photoList;

  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  late PageController _controller;

  @override
  void initialState() {
    super.initState();

    // 受け取った画像一覧から、ページ番号を特定
    final int initialPage = widget.photoList.indexOf(widget.photo);
    _controller = PageController(
      initialPage: context.read(photoViewInitialIndexProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarの裏までbodyの表示エリアを広げる
      extendBodyBehindAppBar: true,
      // 透明なAppBarを作る
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Consumer(builder: (context, watch, child) {
            final asyncPhotoList = watch(photoListProvider);

            return asyncPhotoList.when(
              data: (photoList) {
                return PageView(
                  controller: _controller,
                  onPageChanged: (int index) => {},
                  children: photoList.map((Photo photo) {
                    return Image.network(
                      photo.imageURL,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                );
              },
              loading: () {
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
              error: (e, stackTrace) {
                return Center(
                  child: Text(e.toString()),
                );
              },
            );
          }),
          // ...
        ],
      ),
    );
  }
}
