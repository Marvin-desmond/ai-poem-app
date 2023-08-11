// import 'package:ai_poem_app/common.dart';
// import 'package:http/http.dart';

// class PhotosListScreen extends StatefulWidget {
//   PhotosListScreen({Key? key}) : super(key: key);
// @override
//   _PhotosListScreenState createState() => _PhotosListScreenState();
// }
// class _PhotosListScreenState extends State<PhotosListScreen> {
//   bool? _hasMore;
//   int? _pageNumber;
//   bool? _error;
//   bool? _loading;
//   int _defaultPhotosPerPageCount = 10;
//   List<Photo>? _photos;
//   final int _nextPageThreshold = 5;
// @override
//   void initState() {
//     super.initState();
//     _hasMore = true;
//     _pageNumber = 1;
//     _error = false;
//     _loading = true;
//     _photos = [];
//     fetchPhotos();
//   }
// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Photos App")),
//       body: getBody(),
//     );
//   }
// Widget getBody() {
// // ..................
// }
// Future<void> fetchPhotos() async {
// // ................
// }
// }

// Future<void> fetchPhotos() async {
//     try {
//       final response = await http.get(
//           "https://jsonplaceholder.typicode.com/photos?_page=$_pageNumber");
//       List<Photo> fetchedPhotos = Photo.parseList(json.decode(response.body));
//       setState(() {
//         _hasMore = fetchedPhotos.length == _defaultPhotosPerPageCount;
//         _loading = false;
//         _pageNumber = _pageNumber + 1;
//         _photos.addAll(fetchedPhotos);
//       });
//     } catch (e) {
//       setState(() {
//         _loading = false;
//         _error = true;
//       });
//     }
//   }
// }
// class Photo {
//   final String title;
//   final String thumbnailUrl;
// Photo(this.title, this.thumbnailUrl);
// factory Photo.fromJson(Map<String, dynamic> json) {
//     return Photo(json["title"], json["thumbnailUrl"]);
//   }
// static List<Photo> parseList(List<dynamic> list) {
//     return list.map((i) => Photo.fromJson(i)).toList();
//   }
// }
