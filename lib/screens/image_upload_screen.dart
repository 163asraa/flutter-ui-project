


// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/const/color.dart';
// import '../providers/auth_provider.dart';
// import 'dart:io';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'dart:convert';

// class ImageUploadScreen extends StatefulWidget {
//   @override
//   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// }

// class _ImageUploadScreenState extends State<ImageUploadScreen>
//     with SingleTickerProviderStateMixin {
//   File? _image;
//   final picker = ImagePicker();
//   bool _isLoading = false;
//   List<dynamic> _products = [];
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//     _fadeAnimation =
//         CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         _products.clear();
//       }
//     });
//   }

//   Future<void> _uploadImage() async {
//     if (_image == null) return;
//     setState(() => _isLoading = true);
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('${dotenv.env['BASE_URL']}/api/upload-image/'),
//     );
//     request.headers['Authorization'] = 'Bearer ${authProvider.token}';
//     request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
//     final response = await request.send();
//     final respStr = await response.stream.bytesToString();
//     final jsonData = jsonDecode(respStr);
//     setState(() {
//       _isLoading = false;
//       if (response.statusCode == 200) {
//         _products = jsonData['products'];
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${jsonData['error']}')),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'البحث بواسطة صورة',
//           style: theme.textTheme.titleLarge?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppColors.secondary,
//         elevation: 4,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.white,
//               theme.colorScheme.surface,
//             ],
//           ),
//         ),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: Column(
//             children: [
//               Card(
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16)),
//                 margin: EdgeInsets.all(16),
//                 child: Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       _image == null
//                           ? Text(
//                               'No image selected',
//                               style: theme.textTheme.bodyLarge?.copyWith(
//                                 color: theme.colorScheme.onSurface,
//                               ),
//                               textAlign: TextAlign.center,
//                             )
//                           : ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: kIsWeb
//                                   ? Image.network(
//                                       _image!.path,
//                                       height: 200,
//                                       width: double.infinity,
//                                       fit: BoxFit.cover,
//                                     )
//                                   : Image.file(
//                                       _image!,
//                                       height: 200,
//                                       width: double.infinity,
//                                       fit: BoxFit.cover,
//                                     ),
//                             ),
//                       SizedBox(height: 16),
//                       Wrap(
//                         spacing: 16,
//                         runSpacing: 8,
//                         alignment: WrapAlignment.center,
//                         children: [
//                           ElevatedButton(
//                             onPressed: _pickImage,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.secondary,
//                               foregroundColor: theme.colorScheme.onPrimary,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 12, horizontal: 24),
//                               elevation: 4,
//                             ),
//                             child: Text(
//                               'Pick Image',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           if (_image != null)
//                             ElevatedButton(
//                               onPressed: _isLoading ? null : _uploadImage,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: theme.colorScheme.primary,
//                                 foregroundColor: theme.colorScheme.onPrimary,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 24),
//                                 elevation: 4,
//                               ),
//                               child: Text(
//                                 'Upload Image',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                       if (_isLoading)
//                         Padding(
//                           padding: EdgeInsets.only(top: 16),
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                                 theme.colorScheme.primary),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: _products.isEmpty && !_isLoading
//                     ? Center(
//                         child: Card(
//                           elevation: 8,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           margin: EdgeInsets.symmetric(horizontal: 16),
//                           child: Padding(
//                             padding: EdgeInsets.all(16),
//                             child: Text(
//                               'No products found',
//                               style: theme.textTheme.bodyLarge?.copyWith(
//                                 color: theme.colorScheme.onSurface,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: _products.length,
//                         itemBuilder: (context, index) {
//                           final product = _products[index];
//                           return Card(
//                             elevation: 8,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                             margin: EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 8),
//                             child: ListTile(
//                               leading: ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: CachedNetworkImage(
//                                   imageUrl: product['image'],
//                                   width: 50,
//                                   height: 50,
//                                   fit: BoxFit.cover,
//                                   placeholder: (context, url) => Center(
//                                     child: CircularProgressIndicator(
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                           theme.colorScheme.primary),
//                                     ),
//                                   ),
//                                   errorWidget: (context, url, error) => Icon(
//                                     Icons.error,
//                                     color: theme.colorScheme.error,
//                                     size: 30,
//                                   ),
//                                 ),
//                               ),
//                               title: Text(
//                                 product['name'],
//                                 style: theme.textTheme.titleMedium?.copyWith(
//                                   color: theme.colorScheme.onSurface,
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 '\$${product['price']} - Similarity: ${product['similarity'].toStringAsFixed(2)}',
//                                 style: theme.textTheme.bodyMedium?.copyWith(
//                                   color: theme.colorScheme.onSurface
//                                       .withOpacity(0.8),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/const/color.dart';
// import '../providers/auth_provider.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import '../models/product_detail.dart';
// import '../screens/product_detail_screen.dart';

// class ImageUploadScreen extends StatefulWidget {
//   @override
//   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// }

// class _ImageUploadScreenState extends State<ImageUploadScreen>
//     with TickerProviderStateMixin {
//   XFile? _pickedImage;
//   XFile? _image;
//   final picker = ImagePicker();
//   bool _isLoading = false;
//   List<dynamic> _products = [];

//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   late AnimationController _buttonController;
//   late Animation<Offset> _buttonOffset;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//     _fadeAnimation =
//         CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//     _controller.forward();

//     _buttonController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 600),
//     );
//     _buttonOffset =
//         Tween<Offset>(begin: Offset(0.0, 0.5), end: Offset.zero).animate(
//       CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _buttonController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.camera_alt),
//                 title: Text('الكاميرا'),
//                 onTap: () async {
//                   Navigator.of(context).pop();
//                   final pickedFile =
//                       await picker.pickImage(source: ImageSource.camera);
//                   if (pickedFile != null) {
//                     setState(() {
//                       _pickedImage = pickedFile;
//                       _image = pickedFile; // ✅ تعديل مضاف
//                       _products.clear();
//                     });
//                     _buttonController.forward();
//                   }
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('المعرض'),
//                 onTap: () async {
//                   Navigator.of(context).pop();
//                   final pickedFile =
//                       await picker.pickImage(source: ImageSource.gallery);
//                   if (pickedFile != null) {
//                     setState(() {
//                       _pickedImage = pickedFile;
//                       _image = pickedFile; // ✅ تعديل مضاف
//                       _products.clear();
//                     });
//                     _buttonController.forward();
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _confirmAndUpload() async {
//     if (_image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('يرجى اختيار صورة أولاً')),
//       );
//       return;
//     }

//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('تأكيد'),
//         content: Text('هل أنت متأكد أنك تريد رفع هذه الصورة؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text('إلغاء'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: Text('تأكيد'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       await _uploadImage();
//     }
//   }

//   Future<void> _uploadImage() async {
//     print("🚀 بدأ رفع الصورة");
//     if (_image == null) {
//       print("⚠️ لم يتم تحديد صورة");
//       return;
//     }

//     setState(() => _isLoading = true);

//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final uri = Uri.parse('${dotenv.env['BASE_URL']}/upload-image/');
//     print("Token used: ${authProvider.token}");

//     var request = http.MultipartRequest('POST', uri);

//     final token = authProvider.token;
//     if (token != null && token.isNotEmpty) {
//       request.headers['Authorization'] = 'Bearer $token';
//     }

//     if (kIsWeb) {
//       final bytes = await _image!.readAsBytes();
//       final multipartFile = http.MultipartFile.fromBytes(
//         'image',
//         bytes,
//         filename: 'upload.jpg',
//         contentType: MediaType('image', 'jpeg'),
//       );
//       request.files.add(multipartFile);
//     } else {
//       request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
//     }

//     try {
//       final response = await request.send();
//       final respStr = await response.stream.bytesToString();

//       setState(() => _isLoading = false);

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(respStr);
//         setState(() {
//           _products = jsonData['products'];
//         });
//         print("✅ تم رفع الصورة واستقبال النتائج: $_products");
//       } else {
//         try {
//           final errorJson = jsonDecode(respStr);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('خطأ: ${errorJson['error']}')),
//           );
//         } catch (_) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('حدث خطأ غير متوقع في السيرفر')),
//           );
//         }
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء الرفع: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'البحث بواسطة صورة',
//           style: theme.textTheme.titleLarge?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppColors.secondary,
//         elevation: 4,
//         actions: [
//           if (_pickedImage != null)
//             IconButton(
//               icon: Icon(Icons.delete_forever),
//               onPressed: () {
//                 setState(() {
//                   _pickedImage = null;
//                   _image = null;
//                   _products.clear();
//                 });
//               },
//             )
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.white,
//               theme.colorScheme.surface,
//             ],
//           ),
//         ),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: Column(
//             children: [
//               Card(
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16)),
//                 margin: EdgeInsets.all(16),
//                 child: Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       _pickedImage == null
//                           ? Text(
//                               'لم يتم اختيار صورة',
//                               style: theme.textTheme.bodyLarge?.copyWith(
//                                 color: theme.colorScheme.onSurface,
//                               ),
//                               textAlign: TextAlign.center,
//                             )
//                           : ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: kIsWeb
//                                   ? Image.network(
//                                       _pickedImage!.path,
//                                       height: 200,
//                                       width: double.infinity,
//                                       fit: BoxFit.cover,
//                                     )
//                                   : Image.file(
//                                       File(_pickedImage!.path),
//                                       height: 200,
//                                       width: double.infinity,
//                                       fit: BoxFit.cover,
//                                     ),
//                             ),
//                       SizedBox(height: 16),
//                       SlideTransition(
//                         position: _buttonOffset,
//                         child: Wrap(
//                           spacing: 16,
//                           runSpacing: 8,
//                           alignment: WrapAlignment.center,
//                           children: [
//                             ElevatedButton(
//                               onPressed: _pickImage,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.secondary,
//                                 foregroundColor: theme.colorScheme.onPrimary,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 24),
//                                 elevation: 4,
//                               ),
//                               child: Text('اختيار صورة'),
//                             ),
//                             if (_pickedImage != null)
//                               ElevatedButton(
//                                 onPressed: _isLoading ? null : _confirmAndUpload,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: theme.colorScheme.primary,
//                                   foregroundColor: theme.colorScheme.onPrimary,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 12, horizontal: 24),
//                                   elevation: 4,
//                                 ),
//                                 child: Text('رفع الصورة'),
//                               ),
//                           ],
//                         ),
//                       ),
//                       if (_isLoading)
//                         Padding(
//                           padding: EdgeInsets.only(top: 16),
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                                 theme.colorScheme.primary),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               if (_products.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 8.0),
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         _pickedImage = null;
//                         _image = null;
//                         _products.clear();
//                       });
//                     },
//                     icon: Icon(Icons.refresh),
//                     label: Text('جرب صورة جديدة'),
//                   ),
//                 ),
//               Expanded(
//                 child: _products.isEmpty && !_isLoading && _image != null
//                     ? Center(
//                         child: Card(
//                           elevation: 8,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           margin: EdgeInsets.symmetric(horizontal: 16),
//                           child: Padding(
//                             padding: EdgeInsets.all(16),
//                             child: Text(
//                               'لم يتم العثور على منتجات مشابهة',
//                               style: theme.textTheme.bodyLarge?.copyWith(
//                                 color: theme.colorScheme.onSurface,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: _products.length,
//                         itemBuilder: (context, index) {
//                           final product = _products[index];
//                           return FadeTransition(
//                             opacity: _fadeAnimation,
//                             child: Card(
//                               elevation: 8,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                               margin: EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 8),
//                               child: ListTile(
//                                 onTap: () => Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => ProductDetailScreen(
//                                         product: ProductDetail.fromJson(
//                                             product)),
//                                   ),
//                                 ),
//                                 leading: ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: CachedNetworkImage(
//                                     imageUrl: product['image'],
//                                     width: 50,
//                                     height: 50,
//                                     fit: BoxFit.cover,
//                                     placeholder: (context, url) => Center(
//                                       child: CircularProgressIndicator(
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                                 theme.colorScheme.primary),
//                                       ),
//                                     ),
//                                     errorWidget: (context, url, error) => Icon(
//                                       Icons.error,
//                                       color: theme.colorScheme.error,
//                                       size: 30,
//                                     ),
//                                   ),
//                                 ),
//                                 title: Text(
//                                   product['name'],
//                                   style:
//                                       theme.textTheme.titleMedium?.copyWith(
//                                     color: theme.colorScheme.onSurface,
//                                   ),
//                                 ),
//                                 subtitle: Text(
//                                   '${product['price']} ل.س - التشابه: ${product['similarity'].toStringAsFixed(2)}',
//                                   style:
//                                       theme.textTheme.bodyMedium?.copyWith(
//                                     color: theme.colorScheme.onSurface
//                                         .withOpacity(0.8),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/const/color.dart';
// import '../providers/auth_provider.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import '../models/product_detail.dart';
// import '../screens/product_detail_screen.dart';

// class ImageUploadScreen extends StatefulWidget {
//   @override
//   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// }

// class _ImageUploadScreenState extends State<ImageUploadScreen>
//     with TickerProviderStateMixin {
//   XFile? _pickedImage;
//   XFile? _image;
//   final picker = ImagePicker();
//   bool _isLoading = false;
//   List<dynamic> _products = [];
//   String? _predictedClass; // ✅ جديد

//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late AnimationController _buttonController;
//   late Animation<Offset> _buttonOffset;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//     _fadeAnimation =
//         CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//     _controller.forward();
//     _buttonController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 600),
//     );
//     _buttonOffset =
//         Tween<Offset>(begin: Offset(0.0, 0.5), end: Offset.zero).animate(
//       CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _buttonController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.camera_alt),
//                 title: Text('الكاميرا'),
//                 onTap: () async {
//                   Navigator.of(context).pop();
//                   final pickedFile =
//                       await picker.pickImage(source: ImageSource.camera);
//                   if (pickedFile != null) {
//                     setState(() {
//                       _pickedImage = pickedFile;
//                       _image = pickedFile;
//                       _products.clear();
//                       _predictedClass = null;
//                     });
//                     _buttonController.forward();
//                   }
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('المعرض'),
//                 onTap: () async {
//                   Navigator.of(context).pop();
//                   final pickedFile =
//                       await picker.pickImage(source: ImageSource.gallery);
//                   if (pickedFile != null) {
//                     setState(() {
//                       _pickedImage = pickedFile;
//                       _image = pickedFile;
//                       _products.clear();
//                       _predictedClass = null;
//                     });
//                     _buttonController.forward();
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _confirmAndUpload() async {
//     if (_image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('يرجى اختيار صورة أولاً')),
//       );
//       return;
//     }

//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('تأكيد'),
//         content: Text('هل أنت متأكد أنك تريد رفع هذه الصورة؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text('إلغاء'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: Text('تأكيد'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       await _uploadImage();
//     }
//   }

//   Future<void> _uploadImage() async {
//     print("🚀 بدأ رفع الصورة");
//     if (_image == null) {
//       print("⚠️ لم يتم تحديد صورة");
//       return;
//     }

//     setState(() => _isLoading = true);

//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final uri = Uri.parse('${dotenv.env['BASE_URL']}/upload-image/');
//     print("Token used: ${authProvider.token}");

//     var request = http.MultipartRequest('POST', uri);

//     final token = authProvider.token;
//     if (token != null && token.isNotEmpty) {
//       request.headers['Authorization'] = 'Bearer $token';
//     }

//     if (kIsWeb) {
//       final bytes = await _image!.readAsBytes();
//       final multipartFile = http.MultipartFile.fromBytes(
//         'image',
//         bytes,
//         filename: 'upload.jpg',
//         contentType: MediaType('image', 'jpeg'),
//       );
//       request.files.add(multipartFile);
//     } else {
//       request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
//     }

//     try {
//       final response = await request.send();
//       final respStr = await response.stream.bytesToString();

//       setState(() => _isLoading = false);

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(respStr);
//         setState(() {
//           _products = jsonData['products'];
//           _predictedClass = jsonData['predicted_class']; // ✅ حفظ اسم الفئة
//         });
//         print("✅ تم رفع الصورة واستقبال النتائج: $_products");
//       } else {
//         try {
//           final errorJson = jsonDecode(respStr);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('خطأ: ${errorJson['error']}')),
//           );
//         } catch (_) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('حدث خطأ غير متوقع في السيرفر')),
//           );
//         }
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء الرفع: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'البحث بواسطة صورة',
//           style: theme.textTheme.titleLarge?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppColors.secondary,
//         elevation: 4,
//         actions: [
//           if (_pickedImage != null)
//             IconButton(
//               icon: Icon(Icons.delete_forever),
//               onPressed: () {
//                 setState(() {
//                   _pickedImage = null;
//                   _image = null;
//                   _products.clear();
//                   _predictedClass = null;
//                 });
//               },
//             )
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.white,
//               theme.colorScheme.surface,
//             ],
//           ),
//         ),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: Column(
//             children: [
//               Card(
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16)),
//                 margin: EdgeInsets.all(16),
//                 child: Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       _pickedImage == null
//                           ? Text(
//                               'لم يتم اختيار صورة',
//                               style: theme.textTheme.bodyLarge?.copyWith(
//                                 color: theme.colorScheme.onSurface,
//                               ),
//                               textAlign: TextAlign.center,
//                             )
//                           : ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: kIsWeb
//                                   ? Image.network(
//                                       _pickedImage!.path,
//                                       height: 200,
//                                       width: double.infinity,
//                                       fit: BoxFit.cover,
//                                     )
//                                   : Image.file(
//                                       File(_pickedImage!.path),
//                                       height: 200,
//                                       width: double.infinity,
//                                       fit: BoxFit.cover,
//                                     ),
//                             ),
//                       SizedBox(height: 16),
//                       SlideTransition(
//                         position: _buttonOffset,
//                         child: Wrap(
//                           spacing: 16,
//                           runSpacing: 8,
//                           alignment: WrapAlignment.center,
//                           children: [
//                             ElevatedButton(
//                               onPressed: _pickImage,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.secondary,
//                                 foregroundColor: theme.colorScheme.onPrimary,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 24),
//                                 elevation: 4,
//                               ),
//                               child: Text('اختيار صورة'),
//                             ),
//                             if (_pickedImage != null)
//                               ElevatedButton(
//                                 onPressed: _isLoading ? null : _confirmAndUpload,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: theme.colorScheme.primary,
//                                   foregroundColor: theme.colorScheme.onPrimary,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 12, horizontal: 24),
//                                   elevation: 4,
//                                 ),
//                                 child: Text('رفع الصورة'),
//                               ),
//                           ],
//                         ),
//                       ),
//                       if (_isLoading)
//                         Padding(
//                           padding: EdgeInsets.only(top: 16),
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                                 theme.colorScheme.primary),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               if (_products.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 8.0),
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         _pickedImage = null;
//                         _image = null;
//                         _products.clear();
//                         _predictedClass = null;
//                       });
//                     },
//                     icon: Icon(Icons.refresh),
//                     label: Text('جرب صورة جديدة'),
//                   ),
//                 ),
//               Expanded(
//                 child: _products.isEmpty && !_isLoading && _image != null
//                     ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Card(
//                             elevation: 8,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                             margin: EdgeInsets.symmetric(horizontal: 16),
//                             child: Padding(
//                               padding: EdgeInsets.all(16),
//                               child: Text(
//                                 'لم يتم العثور على منتجات مشابهة',
//                                 style: theme.textTheme.bodyLarge?.copyWith(
//                                   color: theme.colorScheme.onSurface,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                           if (_predictedClass != null)
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 8),
//                               child: Text(
//                                 'تم التعرّف على الفئة: $_predictedClass',
//                                 style: theme.textTheme.bodyMedium?.copyWith(
//                                   color: theme.colorScheme.primary,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                         ],
//                       )
//                     : ListView.builder(
//                         itemCount: _products.length,
//                         itemBuilder: (context, index) {
//                           final product = _products[index];
//                           return FadeTransition(
//                             opacity: _fadeAnimation,
//                             child: Card(
//                               elevation: 8,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                               margin: EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 8),
//                               child: ListTile(
//                                 onTap: () => Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => ProductDetailScreen(
//                                         product: ProductDetail.fromJson(
//                                             product)),
//                                   ),
//                                 ),
//                                 leading: ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: CachedNetworkImage(
//                                     imageUrl: product['image'],
//                                     width: 50,
//                                     height: 50,
//                                     fit: BoxFit.cover,
//                                     placeholder: (context, url) => Center(
//                                       child: CircularProgressIndicator(
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                                 theme.colorScheme.primary),
//                                       ),
//                                     ),
//                                     errorWidget: (context, url, error) => Icon(
//                                       Icons.error,
//                                       color: theme.colorScheme.error,
//                                       size: 30,
//                                     ),
//                                   ),
//                                 ),
//                                 title: Text(
//                                   product['name'],
//                                   style:
//                                       theme.textTheme.titleMedium?.copyWith(
//                                     color: theme.colorScheme.onSurface,
//                                   ),
//                                 ),
//                                 subtitle: Text(
//                                   '${product['price']} ل.س - التشابه: ${product['similarity'].toStringAsFixed(2)}',
//                                   style:
//                                       theme.textTheme.bodyMedium?.copyWith(
//                                     color: theme.colorScheme.onSurface
//                                         .withOpacity(0.8),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// ✅ هذا هو الكود بعد التعديل المطلوب على ImageUploadScreen
// - تم نقل أيقونة الحذف تحت الصورة
// - جعل لونها أحمر
// - تعديل AppBar ليشمل الموجة العلوية مثل WelcomeScreen
// باقي الـ imports كما هي
// باقي الاستيرادات في الأعلى كما هي
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/const/color.dart';
// import '../providers/auth_provider.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'dart:convert';
// import '../models/product_detail.dart';
// import '../screens/product_detail_screen.dart';
// import '../const/const.dart';

// class ImageUploadScreen extends StatefulWidget {
//   @override
//   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// }

// class _ImageUploadScreenState extends State<ImageUploadScreen> with TickerProviderStateMixin {
//   XFile? _pickedImage;
//   XFile? _image;
//   final picker = ImagePicker();
//   bool _isLoading = false;
//   List<dynamic> _products = [];

//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   late AnimationController _buttonController;
//   late Animation<Offset> _buttonOffset;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
//     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//     _controller.forward();

//     _buttonController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
//     _buttonOffset = Tween<Offset>(begin: Offset(0.0, 0.5), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _buttonController, curve: Curves.easeOut));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _buttonController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.camera_alt),
//                 title: Text('الكاميرا'),
//                 onTap: () async {
//                   Navigator.of(context).pop();
//                   final pickedFile = await picker.pickImage(source: ImageSource.camera);
//                   if (pickedFile != null) {
//                     setState(() {
//                       _pickedImage = pickedFile;
//                       _image = pickedFile;
//                       _products.clear();
//                     });
//                     _buttonController.forward();
//                   }
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('المعرض'),
//                 onTap: () async {
//                   Navigator.of(context).pop();
//                   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//                   if (pickedFile != null) {
//                     setState(() {
//                       _pickedImage = pickedFile;
//                       _image = pickedFile;
//                       _products.clear();
//                     });
//                     _buttonController.forward();
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _confirmAndUpload() async {
//     if (_image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('يرجى اختيار صورة أولاً')));
//       return;
//     }

//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('تأكيد'),
//         content: Text('هل أنت متأكد أنك تريد رفع هذه الصورة؟'),
//         actions: [
//           TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('إلغاء')),
//           TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('تأكيد')),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       await _uploadImage();
//     }
//   }

//   Future<void> _uploadImage() async {
//     if (_image == null) return;
//     setState(() => _isLoading = true);

//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final uri = Uri.parse('${dotenv.env['BASE_URL']}/upload-image/');
//     var request = http.MultipartRequest('POST', uri);

//     final token = authProvider.token;
//     if (token != null && token.isNotEmpty) {
//       request.headers['Authorization'] = 'Bearer $token';
//     }

//     if (kIsWeb) {
//       final bytes = await _image!.readAsBytes();
//       final multipartFile = http.MultipartFile.fromBytes(
//         'image',
//         bytes,
//         filename: 'upload.jpg',
//         contentType: MediaType('image', 'jpeg'),
//       );
//       request.files.add(multipartFile);
//     } else {
//       request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
//     }

//     try {
//       final response = await request.send();
//       final respStr = await response.stream.bytesToString();
//       setState(() => _isLoading = false);

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(respStr);
//         setState(() {
//           _products = jsonData['products'];
//         });
//       } else {
//         final errorJson = jsonDecode(respStr);
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: ${errorJson['error']}')));
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء الرفع: $e')));
//     }
//   }

//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       height: 100,
//       decoration: BoxDecoration(
//         color: AppColors.secondary,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(32),
//           bottomRight: Radius.circular(32),
//         ),
//       ),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(34),
//               bottomRight: Radius.circular(34),
//             ),
//             child: Image.asset(
//               "assets/image2.jpg",
//               fit: BoxFit.fitWidth,
//               width: double.infinity,
//             ),
//           ),
//           Container(
//             height: 300,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(137, 18, 62, 68),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(32),
//                 bottomRight: Radius.circular(32),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 34.0, right: 30, left: 30),
//             child: Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.all(Radius.circular(32)),
//               ),
//               child: Center(
//                 child: Text(
//                   "البحث باستخدام الذكاء",
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Stack(
//       children: [
//         _buildHeader(),
//         FadeTransition(
//           opacity: _fadeAnimation,
//           child: ListView(
//             padding: EdgeInsets.only(top: 120, bottom: 30),
//             children: [
//               Center(
//                 child: Text(
//                   "ابحث بسهولة عن المنتج المطلوب",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "طريقة البحث:",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.secondary,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("1. ", style: TextStyle(fontWeight: FontWeight.bold)),
//                         Expanded(child: Text("اختر صورة من جهازك تمثل المنتج الذي تبحث عنه.")),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("2. ", style: TextStyle(fontWeight: FontWeight.bold)),
//                         Expanded(child: Text("أو التقط صورة جديدة مباشرة باستخدام الكاميرا.")),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("3. ", style: TextStyle(fontWeight: FontWeight.bold)),
//                         Expanded(child: Text("اضغط على زر 'رفع الصورة' لإرسالها.")),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("4. ", style: TextStyle(fontWeight: FontWeight.bold)),
//                         Expanded(child: Text("انتظر قليلاً ليتم جلب المنتجات المشابهة.")),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               Image.asset('assets/image3.gif', height: 300),
//               SizedBox(height: 12),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _pickImage,
//                   child: Text('اختيار صورة'),
//                 ),
//               ),
//               // يمكنك الآن إدراج Card أو أي عناصر إضافية هنا...
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/const/color.dart';
// import '../providers/auth_provider.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:convert';

// class ImageUploadScreen extends StatefulWidget {
//   @override
//   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// }

// class _ImageUploadScreenState extends State<ImageUploadScreen> with TickerProviderStateMixin {
//   XFile? _pickedImage;
//   XFile? _image;
//   final picker = ImagePicker();
//   bool _isLoading = false;
//   List<dynamic> _products = [];

//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
//     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.camera_alt),
//                 title: Text('الكاميرا'),
//                 onTap: () async {
//                   Navigator.of(context).pop();
//                   final pickedFile = await picker.pickImage(source: ImageSource.camera);
//                   if (pickedFile != null) {
//                     setState(() {
//                       _pickedImage = pickedFile;
//                       _image = pickedFile;
//                       _products.clear();
//                     });
//                   }
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('المعرض'),
//                 onTap: () async {
//                   Navigator.of(context).pop();
//                   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//                   if (pickedFile != null) {
//                     setState(() {
//                       _pickedImage = pickedFile;
//                       _image = pickedFile;
//                       _products.clear();
//                     });
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }


// Widget _buildHeader() {
//   return Container(
//     width: double.infinity,
//     height: 100,
//     decoration: BoxDecoration(
//       color: AppColors.secondary,
//       borderRadius: BorderRadius.only(
//         bottomLeft: Radius.circular(32),
//         bottomRight: Radius.circular(32),
//       ),
//     ),
//     child: Stack(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(34),
//             bottomRight: Radius.circular(34),
//           ),
//           child: Image.asset(
//             "assets/image2.jpg",
//             fit: BoxFit.fitWidth,
//             width: double.infinity,
//           ),
//         ),
//         Container(
//           height: 300,
//           decoration: BoxDecoration(
//             color: const Color.fromARGB(137, 18, 62, 68),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(32),
//               bottomRight: Radius.circular(32),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 60.0, right: 30, left: 30),
//           child: Container(
//             width: double.infinity,
//             height: 20,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(136, 255, 255, 255),
//               borderRadius: BorderRadius.all(Radius.circular(32)),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 34.0, right: 30, left: 30),
//           child: Container(
//             height: 40,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(0, 255, 255, 255),
//               borderRadius: BorderRadius.all(Radius.circular(32)),
//             ),
//             child: Center(
//               child: Text(
//                 "البحث باستخدام الذكاء",
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           _buildHeader(),
//           FadeTransition(
//             opacity: _fadeAnimation,
//             child: ListView(
//               padding: EdgeInsets.only(top: 120, bottom: 30),
//               children: [
//                 Center(
//                   child: Text(
//                     "ابحث بسهولة عن المنتج المطلوب",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "طريقة البحث:",
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.secondary,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("1. ", style: TextStyle(fontWeight: FontWeight.bold)),
//                           Expanded(child: Text("اختر صورة من جهازك تمثل المنتج الذي تبحث عنه.")),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("2. ", style: TextStyle(fontWeight: FontWeight.bold)),
//                           Expanded(child: Text("أو التقط صورة جديدة مباشرة باستخدام الكاميرا.")),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("3. ", style: TextStyle(fontWeight: FontWeight.bold)),
//                           Expanded(child: Text("اضغط على زر 'رفع الصورة' لإرسالها.")),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("4. ", style: TextStyle(fontWeight: FontWeight.bold)),
//                           Expanded(child: Text("انتظر قليلاً ليتم جلب المنتجات المشابهة.")),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Image.asset('assets/image3.gif', height: 300),
//                 SizedBox(height: 12),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: _pickImage,
//                     child: Text('اختيار صورة'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }






// الكود الاخير

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/const/color.dart';
// import 'package:supa_electronics/providers/auth_provider.dart';
// import 'package:supa_electronics/screens/product_detail_screen.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'dart:convert';

// class ImageUploadScreen extends StatefulWidget {
//   late final String token;
//   @override
//   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// }

// class _ImageUploadScreenState extends State<ImageUploadScreen>
//     with TickerProviderStateMixin {
//   File? _image;
//   bool _isLoading = false;
//   List<dynamic> _products = [];
//   String? _predictedClass;

//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
//     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         _products.clear();
//         _predictedClass = null;
//       });
//       await _uploadImage();
//     }
//   }

//   Future<void> _uploadImage() async {
//     if (_image == null) return;
//     setState(() => _isLoading = true);
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('${dotenv.env['BASE_URL']}/upload-image/'),
//     );
//     request.headers['Authorization'] = 'Bearer ${authProvider.token}';
//     request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
//     final response = await request.send();
//     final respStr = await response.stream.bytesToString();
//     final jsonData = jsonDecode(respStr);
//     setState(() {
//       _isLoading = false;
//       if (response.statusCode == 200) {
//         _products = jsonData['similar_products'];
//         _predictedClass = jsonData['predicted_class'];
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${jsonData['error']}')),
//         );
//       }
//     });
//   }

//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       height: 100,
//       decoration: BoxDecoration(
//         color: AppColors.secondary,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(32),
//           bottomRight: Radius.circular(32),
//         ),
//       ),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(34),
//               bottomRight: Radius.circular(34),
//             ),
//             child: Image.asset(
//               "assets/image2.jpg",
//               fit: BoxFit.cover,
//               width: double.infinity,
//             ),
//           ),
//           Container(
//             height: 300,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(137, 18, 62, 68),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(32),
//                 bottomRight: Radius.circular(32),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 34.0, right: 30, left: 30),
//             child: Center(
//               child: Text(
//                 "البحث باستخدام الذكاء",
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           _buildHeader(),
//           FadeTransition(
//             opacity: _fadeAnimation,
//             child: ListView(
//               padding: EdgeInsets.only(top: 120, bottom: 30),
//               children: [
//                 if (_isLoading) Center(child: CircularProgressIndicator()),
//                 if (!_isLoading && _products.isEmpty && _predictedClass == null)
//                   Column(
//                     children: [
//                       Center(
//                         child: Text(
//                           "ابحث بسهولة عن المنتج المطلوب",
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 24),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("طريقة البحث:",
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.secondary,
//                                 )),
//                             SizedBox(height: 10),
//                             Text("1. اختر صورة تمثل المنتج."),
//                             Text("2. أو التقط صورة جديدة."),
//                             Text("3. سيتم رفعها تلقائيًا وجلب النتائج."),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Image.asset('assets/image3.gif', height: 300),
//                       SizedBox(height: 12),
//                       Center(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             showModalBottomSheet(
//                               context: context,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
//                               builder: (BuildContext context) {
//                                 return SafeArea(
//                                   child: Wrap(
//                                     children: [
//                                       ListTile(
//                                         leading: Icon(Icons.camera_alt),
//                                         title: Text('الكاميرا'),
//                                         onTap: () {
//                                           Navigator.pop(context);
//                                           _pickImage(ImageSource.camera);
//                                         },
//                                       ),
//                                       ListTile(
//                                         leading: Icon(Icons.photo_library),
//                                         title: Text('المعرض'),
//                                         onTap: () {
//                                           Navigator.pop(context);
//                                           _pickImage(ImageSource.gallery);
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                           child: Text('اختيار صورة'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 if (!_isLoading && _predictedClass != null)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
//                     child: Text(
//                       "الفئة المتوقعة: $_predictedClass",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 if (!_isLoading && _products.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       children: _products.map((product) {
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                builder: (context) => ProductDetailScreen(product: product['id'], token: widget.token),
//                               ),
//                             );
//                           },
//                           child: Card(
//                             child: ListTile(
//                               leading: CachedNetworkImage(
//                                 imageUrl: product['image'] ?? '',
//                                 width: 60,
//                                 height: 60,
//                                 fit: BoxFit.cover,
//                               ),
//                               title: Text(product['name'] ?? ''),
//                               subtitle: Text("نسبة التشابه: ${(product['similarity'] * 100).toStringAsFixed(1)}%"),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import '../services/api_service.dart';
// import 'product_detail_screen.dart';

// class ImageUploadScreen extends StatefulWidget {
//   final String token;

//   const ImageUploadScreen({Key? key, required this.token}) : super(key: key);

//   @override
//   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// }

// class _ImageUploadScreenState extends State<ImageUploadScreen> {
//   File? _image;
//   bool isLoading = false;
//   String? predictedClass;
//   List<dynamic> similarProducts = [];
//   String? errorMessage;

//   Future pickImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         isLoading = true;
//         errorMessage = null;
//       });
//       await uploadImage(_image!);
//     }
//   }

// Future<void> uploadImage(File image) async {
//   final uri = Uri.parse('${dotenv.env['BASE_URL']}/upload-image/');
//   final request = http.MultipartRequest('POST', uri);
//   request.files.add(await http.MultipartFile.fromPath('image', image.path));
//   request.headers['Authorization'] = 'Bearer ${widget.token}';

//   try {
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//     print('Status Code: ${response.statusCode}');
//     print('Response Body: ${response.body}');

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = json.decode(response.body);
//       final List<dynamic> products = responseData['similar_products'] ?? [];

//       setState(() {
//         predictedClass = responseData['predicted_class'] ?? '';
//         similarProducts = products;
//         isLoading = false;
//         errorMessage = products.isEmpty ? 'لا توجد منتجات مشابهة' : null;
//       });
//     } else {
//       setState(() {
//         errorMessage = 'فشل في رفع الصورة. حاول مجددًا.';
//         isLoading = false;
//       });
//     }
//   } catch (e) {
//     setState(() {
//       errorMessage = 'حدث خطأ أثناء رفع الصورة.';
//       isLoading = false;
//     });
//   }
// }


//   Widget _buildHeader() {
//     return Stack(
//       children: [
//         Container(
//           height: 160,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/search_header.jpg'),
//               fit: BoxFit.cover,
//               colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
//             ),
//           ),
//         ),
//         Positioned.fill(
//           child: Center(
//             child: Text(
//               'البحث باستخدام الذكاء',
//               style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildImagePreview() {
//     return _image != null
//         ? Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.file(_image!),
//             ),
//           )
//         : SizedBox.shrink();
//   }

//   Widget _buildResults() {
//     if (isLoading) {
//       return Center(child: SpinKitCircle(color: Colors.blue, size: 50));
//     }

//     if (errorMessage != null) {
//       return Column(
//         children: [
//           if (predictedClass != null)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Text("الفئة المتوقعة: $predictedClass", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//             ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (predictedClass != null)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: Text("الفئة المتوقعة: $predictedClass", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//           ),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: similarProducts.length,
//           itemBuilder: (context, index) {
//             final product = similarProducts[index];
//             return ListTile(
//               leading: CircleAvatar(
//                 backgroundImage: CachedNetworkImageProvider(product['image']),
//               ),
//               title: Text(product['name']),
//               subtitle: Text("الشركة: ${product['company_name']}"),
//               trailing: Text("${product['price']} ل.س"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                    builder: (context) => ProductDetailScreen(product: product['id'], token: widget.token),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildUploadOptions() {
//     return Column(
//       children: [
//         ElevatedButton.icon(
//           icon: Icon(Icons.camera_alt),
//           label: Text('التقط صورة'),
//           onPressed: () => pickImage(ImageSource.camera),
//         ),
//         ElevatedButton.icon(
//           icon: Icon(Icons.photo_library),
//           label: Text('اختر من المعرض'),
//           onPressed: () => pickImage(ImageSource.gallery),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: [
//           _buildHeader(),
//           SizedBox(height: 16),
//           _buildUploadOptions(),
//           _buildImagePreview(),
//           _buildResults(),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supa_electronics/const/color.dart';
import 'package:supa_electronics/providers/auth_provider.dart';
import 'package:supa_electronics/screens/product_detail_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key? key}) : super(key: key);

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen>
    with TickerProviderStateMixin {
  File? _image;
  bool _isLoading = false;
  List<dynamic> _products = [];
  String? _predictedClass;

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String joinUrl(String base, String path) {
    final b = (base).replaceFirst(RegExp(r'/+$'), '');
    final p = (path).replaceFirst(RegExp(r'^/+'), '');
    return '$b/$p';
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _products = [];
          _predictedClass = null;
        });
        await _uploadImage();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل اختيار الصورة: $e')),
      );
    }
  }

  void _openPickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('الكاميرا'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('المعرض'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _reselectImage() async {
    // إعادة فتح الـ BottomSheet بسرعة
    _openPickerSheet();
  }

  Future<void> _clearSelection() async {
    setState(() {
      _image = null;
      _products = [];
      _predictedClass = null;
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token ?? '';
    if (token.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('التوكن غير موجود. يرجى تسجيل الدخول.')),
      );
      return;
    }

    final base = dotenv.env['BASE_URL'] ?? '';
    final uri = Uri.parse(joinUrl(base, '/upload-image/')); // طابق الباك

    setState(() => _isLoading = true);

    try {
      final req = http.MultipartRequest('POST', uri);
      req.headers['Authorization'] = 'Bearer $token';
      req.files.add(await http.MultipartFile.fromPath('image', _image!.path));

      final res = await req.send().timeout(const Duration(seconds: 45));
      final body = await res.stream.bytesToString();
      print("----------------------");

print(body);
      Map<String, dynamic>? jsonData;
      try {
        jsonData = jsonDecode(body) as Map<String, dynamic>?;
      } catch (_) {
        jsonData = null; // ممكن يكون HTML (صفحة 404/500)
      }

      if (!mounted) return;

      if (res.statusCode == 200 && jsonData != null) {
        final products = (jsonData['similar_products'] as List?) ??
                         (jsonData['products'] as List?) ??
                         (jsonData['results'] as List?) ??
                         const [];

        final predicted = jsonData['predicted_class'] ??
                          jsonData['predicted_label'] ??
                          jsonData['class'];

        setState(() {
          _products = products;
          _predictedClass = predicted?.toString();
        });

        if (products.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _predictedClass != null
                    ? 'تم التعرّف على الفئة: $_predictedClass، لكن لا توجد منتجات مشابهة.'
                    : 'تم الرفع بنجاح، لكن لا توجد منتجات مشابهة.',
              ),
            ),
          );
        }
      } else {
        final preview = body.length > 400 ? body.substring(0, 400) : body;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('(${res.statusCode}) فشل الطلب\n$preview')),
        );
      }
    } on SocketException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('مشكلة اتصال بالإنترنت. حاول مجددًا.')),
      );
    } on TimeoutException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('انتهت المهلة أثناء الرفع. حاول لاحقًا.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ غير متوقع: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(34),
              bottomRight: Radius.circular(34),
            ),
            child: Image.asset(
              "assets/image2.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Color.fromARGB(137, 18, 62, 68),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 34.0, right: 30, left: 30),
            child: Center(
              child: Text(
                "البحث باستخدام الذكاء",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectedImageBar() {
    if (_image == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(_image!, width: 64, height: 64, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'تم اختيار صورة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          OutlinedButton.icon(
            onPressed: _reselectImage,
            icon: const Icon(Icons.image_search),
            label: const Text('ابحث بصورة أخرى'),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'تفريغ',
            onPressed: _clearSelection,
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
    );
  }

  Widget _resultsList(String token) {
    if (_products.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: _products.map((product) {
          final imgUrl = (product['image'] ?? '').toString();
          final name = (product['name'] ?? '').toString();
          final sim = product['similarity'];
          final similarityText = (sim is num) ? (sim * 100).toStringAsFixed(1) : '—';
          final pid = product['id'];

          return Card(
            child: ListTile(
              onTap: () {
                // تحقّقات قبل التنقّل
                if (pid == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('لا يوجد معرّف منتج صالح.')),
                  );
                  return;
                }
                try {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(
                        product: pid, // تأكّد أن الـ constructor يطابق هذا الاسم/النوع
                        token: token,
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تعذّر فتح تفاصيل المنتج: $e')),
                  );
                }
              },
              leading: imgUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imgUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                    )
                  : const CircleAvatar(
                      child: Icon(Icons.image_not_supported),
                    ),
              title: Text(name.isNotEmpty ? name : '—'),
              subtitle: Text("نسبة التشابه: $similarityText%"),
              trailing: const Icon(Icons.chevron_left), // RTL
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthProvider>().token ?? '';

    return Scaffold(
      body: Stack(
        children: [
          _buildHeader(),
          FadeTransition(
            opacity: _fadeAnimation,
            child: ListView(
              padding: const EdgeInsets.only(top: 120, bottom: 30),
              children: [
                if (_isLoading) const Center(child: CircularProgressIndicator()),
                if (!_isLoading && _image != null) _selectedImageBar(),
                if (!_isLoading && _products.isEmpty && _predictedClass == null)
                  Column(
                    children: [
                      const Center(
                        child: Text(
                          "ابحث بسهولة عن المنتج المطلوب",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("طريقة البحث:",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                )),
                            SizedBox(height: 10),
                            Text("1. اختر صورة تمثل المنتج."),
                            Text("2. أو التقط صورة جديدة."),
                            Text("3. سيتم رفعها تلقائيًا وجلب النتائج."),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Image.asset('assets/image3.gif', height: 300),
                      const SizedBox(height: 12),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _openPickerSheet,
                          icon: const Icon(Icons.image_search),
                          label: const Text('اختيار صورة'),
                        ),
                      ),
                    ],
                  ),
                if (!_isLoading && _predictedClass != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                    child: Text(
                      "الفئة المتوقعة: $_predictedClass",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                if (!_isLoading && _products.isNotEmpty) _resultsList(token),
                if (!_isLoading && _products.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Align(
                      alignment: Alignment.center,
                      child: OutlinedButton.icon(
                        onPressed: _reselectImage,
                        icon: const Icon(Icons.image_search),
                        label: const Text('ابحث بصورة أخرى'),
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
}
