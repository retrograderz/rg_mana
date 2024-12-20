import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GDGoPage extends StatefulWidget {
  const GDGoPage({super.key});

  @override
  State<GDGoPage> createState() => _GDGoPageState();
}
//
// class _GDGoPageState extends State<GDGoPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('GDGo'),
//       ),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Photo Gallery',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: PhotoGalleryScreen(),
//     );
//   }
// }

class _GDGoPageState extends State<GDGoPage> {

  // Dummy list of image URLs
  final List<String> imageUrls = [
    'https://picsum.photos/200/300',
    'https://picsum.photos/201/300',
    'https://picsum.photos/202/300',
    'https://picsum.photos/203/300',
    'https://picsum.photos/204/300',
    'https://picsum.photos/205/300',
    'https://picsum.photos/206/300',
    'https://picsum.photos/207/300',
  ];

  Widget _title() => const Text(
    'Photo Gallery',
    style: TextStyle(
      color: Colors.white,
      fontFamily: 'Inter_24pt',
      fontWeight: FontWeight.bold,
      fontSize: 25,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: _title(),
        elevation: 0,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // số cột trong lưới
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Khi người dùng nhấn vào ảnh, chuyển đến màn hình xem ảnh toàn màn hình
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImageScreen(imageUrl: imageUrls[index]),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: imageUrls[index],
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

class FullScreenImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Full Screen Image',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Inter_24pt',
              fontWeight: FontWeight.bold,
              fontSize: 25,
            )
        ),
        actions: [
          IconButton(
            icon: const Icon(
                Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(
              Icons.error,
            color: Colors.white,
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}