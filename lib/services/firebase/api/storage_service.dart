// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class StorageService with ChangeNotifier {
  final firebaseStorage = FirebaseStorage.instance;
  List<String> _imageUrls = [];
  bool _isLoading = false;
  bool _isUploading = false;

  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;

  Future<void> fetchImages({required String ref}) async {
    _isLoading = true;

    final ListResult result = await firebaseStorage.ref(ref).listAll();

    final urls =
        await Future.wait(result.items.map((ref) => ref.getDownloadURL()));
    _imageUrls = urls;
    _isLoading = false;
    notifyListeners();
  }

  String extractPathFromUrl(String url) {
    Uri uri = Uri.parse(url);
    String encodedPath = uri.pathSegments.last;
    return Uri.decodeComponent(encodedPath);
  }

  Future<void> uploadImage({
    required String ref,
  }) async {
    _isUploading = true;
    notifyListeners();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    try {
      String fileExtension = image.path.split('.').last;
      String filePath = '$ref$fileExtension';
      File file = File(image.path);
      await firebaseStorage.ref(filePath).putFile(file);
      String downloadUrl = await firebaseStorage.ref(filePath).getDownloadURL();
      _imageUrls.add(downloadUrl);
      notifyListeners();
    } catch (e) {
      print('Error uploading: $e');
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  Future<void> deleteImage({
    required Map<String, dynamic> destinationData,
    required bool isHotspot,
    int? hotspotIndex,
  }) async {
    try {
      String basePath =
          'verified_user_uploads/${destinationData['type']}/${destinationData['category']}/${destinationData['subcategory']}/${destinationData['docId']}';

      if (isHotspot && hotspotIndex != null) {
        basePath = '${basePath}_$hotspotIndex';
      }

      String imagePath = basePath;
      String thumbnailPath = '${basePath}_thumbnail';

      print("🗑 Deleting image: $imagePath");
      print("🗑 Deleting thumbnail: $thumbnailPath");

      await FirebaseStorage.instance.ref(imagePath).delete();
      await FirebaseStorage.instance.ref(thumbnailPath).delete();

      print("✅ Images deleted successfully!");
    } catch (e) {
      print("❌ Error deleting image: $e");
      if (e.toString().contains("channel-error")) {
        print("⚠️ Possible Firebase App Check issue. Try disabling App Check.");
      }
    }
  }

  Future<String?> uploadProfilePicture({
    required String userUid,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      _isLoading = true;

      if (image != null) {
        String fileExtension = image.path.split('.').last;
        String filePath = 'users/profile/$userUid.$fileExtension';
        File file = File(image.path);

        Uint8List imageBytes = await file.readAsBytes();

        img.Image? originalImage = img.decodeImage(imageBytes);

        int quality = 69;
        int maxSizeInBytes = 1024 * 1024;

        while (imageBytes.length > maxSizeInBytes && quality > 0) {
          imageBytes = img.encodeJpg(originalImage!, quality: quality);
          quality -= 10;
        }

        await file.writeAsBytes(imageBytes);

        await firebaseStorage.ref(filePath).putFile(file);

        String photoURL = await firebaseStorage.ref(filePath).getDownloadURL();

        _isLoading = false;
        notifyListeners();
        return photoURL;
      } else {
        return null;
      }
    } catch (e) {
      print('Error updating profile picture: $e');
    } finally {
      _isLoading = false;
    }
    return null;
  }

  Future<List<String>> fetchDestination({
    final String? category,
    final String? subcategory,
    required final String parentPath,
  }) async {
    _isLoading = true;
    String path;

    if (category == null ||
        subcategory == null ||
        category == '' ||
        subcategory == '') {
      path = parentPath;
    } else {
      path = '$parentPath/$category/$subcategory';
    }

    final ListResult result = await firebaseStorage.ref(path).listAll();
    final urls =
        await Future.wait(result.items.map((ref) => ref.getDownloadURL()));

    _imageUrls = urls;
    _isLoading = false;
    notifyListeners();
    print(urls);
    return urls;
  }

  Future<Map<String, String>?> addImage({
    required final String collections,
    required final String category,
    required final String subcategory,
    required final String docId,
    required final String typeShit,
  }) async {
    _isUploading = true;
    notifyListeners();

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;
    try {
      String originalFilePath =
          '$collections/$typeShit/$category/$subcategory/$docId';
      String thumbnailFilePath =
          '$collections/$typeShit/$category/$subcategory/${docId}_thumbnail';
      File file = File(image.path);
      int fileSizeInBytes = await file.length();

      await firebaseStorage.ref(originalFilePath).putFile(file);
      String originalDownloadUrl =
          await firebaseStorage.ref(originalFilePath).getDownloadURL();

      Uint8List imageBytes = await file.readAsBytes();
      img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        throw Exception("Failed to decode image.");
      }
      img.Image thumbnailImage = img.copyResize(originalImage, width: 300);

      int quality = 80;
      int maxSizeInBytes = 500 * 1024;
      Uint8List thumbnailBytes =
          img.encodeJpg(thumbnailImage, quality: quality);

      while (thumbnailBytes.length > maxSizeInBytes && quality > 0) {
        quality -= 10;
        thumbnailBytes = img.encodeJpg(thumbnailImage, quality: quality);
      }

      final tempDir = await getTemporaryDirectory();
      final thumbnailFile = File(
          '${tempDir.path}/${file.path.split('/').last.split('.').first}_thumbnail.jpg');
      await thumbnailFile.writeAsBytes(thumbnailBytes);
      await firebaseStorage.ref(thumbnailFilePath).putFile(thumbnailFile);
      String thumbnailDownloadUrl =
          await firebaseStorage.ref(thumbnailFilePath).getDownloadURL();

      _imageUrls.add(originalDownloadUrl);
      _imageUrls.add(thumbnailDownloadUrl);
      notifyListeners();

      return {
        'imagePath': originalDownloadUrl,
        'thumbnailPath': thumbnailDownloadUrl,
        'imageSize': '${(fileSizeInBytes / 1000000).toStringAsFixed(2)} MB',
      };
    } catch (e) {
      print('Error uploading: $e');
      return null;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  Future<Map<String, String>?> uploadHotspotImage({
    required String collectionId,
    required String typeShit,
    required String category,
    required String subcategory,
    required String imageId,
    required int hotspotIndex,
  }) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print('🔥 Error uploading image: null');
      return null;
    }

    File imageFile = File(pickedFile.path);

    try {
      String imagePath =
          '$collectionId/$typeShit/$category/$subcategory/${imageId}_$hotspotIndex';
      String thumbnailPath =
          '$collectionId/$typeShit/$category/$subcategory/${imageId}_${hotspotIndex}_thumbnail';

      TaskSnapshot snapshot =
          await firebaseStorage.ref(imagePath).putFile(imageFile);
      String originalDownloadUrl = await snapshot.ref.getDownloadURL();

      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        throw Exception("Failed to decode image.");
      }

      img.Image thumbnailImage = img.copyResize(originalImage, width: 300);

      int quality = 80;
      int maxSizeInBytes = 500 * 1024;
      Uint8List thumbnailBytes =
          img.encodeJpg(thumbnailImage, quality: quality);

      while (thumbnailBytes.length > maxSizeInBytes && quality > 0) {
        quality -= 10;
        thumbnailBytes = img.encodeJpg(thumbnailImage, quality: quality);
      }

      final tempDir = await getTemporaryDirectory();
      final thumbnailFile = File(
          '${tempDir.path}/${imageFile.path.split('/').last.split('.').first}_thumbnail');
      await thumbnailFile.writeAsBytes(thumbnailBytes);
      await firebaseStorage.ref(thumbnailPath).putFile(thumbnailFile);
      String thumbnailDownloadUrl =
          await firebaseStorage.ref(thumbnailPath).getDownloadURL();

      return {
        'imagePath': originalDownloadUrl,
        'thumbnailPath': thumbnailDownloadUrl,
      };
    } catch (e) {
      print('🔥 Error uploading image: $e');
      return null;
    }
  }

  Future<String?> uploadInfoImage({
    required String collections,
    required String category,
    required String subcategory,
    required String docId,
    required String typeShit,
    required List<String> infosPath,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;

      File file = File(image.path);
      String filePath = '$collections/$typeShit/$category/$subcategory/$docId';

      await firebaseStorage.ref(filePath).putFile(file);
      return await firebaseStorage.ref(filePath).getDownloadURL();
    } catch (e) {
      print('🔥 Error uploading infosPath: $e');
      return null;
    }
  }

  Future<List<String>> uploadMultipleInfoImages({
    required String collections,
    required String category,
    required String subcategory,
    required String typeShit,
    required String docId,
    required List<String> infosPath,
  }) async {
    List<String> uploadedUrls = List.generate(infosPath.length, (_) => "");

    for (int i = 0; i < infosPath.length; i++) {
      if (infosPath[i].isNotEmpty) {
        String imageId = '${docId}_info_$i';

        String? imageUrl = await uploadInfoImage(
          collections: collections,
          category: category,
          subcategory: subcategory,
          docId: imageId,
          typeShit: typeShit,
          infosPath: infosPath,
        );

        if (imageUrl != null) {
          uploadedUrls[i] = imageUrl;
        }
      }
    }
    print("this is the uploadedUrls: $uploadedUrls");
    return uploadedUrls;
  }

  Future<List<String>?> addInfosPath({
    required String collectionId,
    required String typeShit,
    required String category,
    required String subcategory,
    required String imageId,
    required List<String> infosPath,
  }) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print('🔥 No image selected.');
      return null;
    }

    File imageFile = File(pickedFile.path);
    List<String> uploadedUrls = List.generate(infosPath.length, (_) => "");

    try {
      for (int i = 0; i < infosPath.length; i++) {
        if (infosPath[i].isNotEmpty) {
          String imagePath =
              '$collectionId/$typeShit/$category/$subcategory/${imageId}__info_$i';

          TaskSnapshot snapshot =
              await firebaseStorage.ref(imagePath).putFile(imageFile);

          String downloadUrl = await snapshot.ref.getDownloadURL();
          uploadedUrls[i] = downloadUrl;
        }
      }

      return uploadedUrls;
    } catch (e) {
      print('🔥 Error uploading images: $e');
      return null;
    }
  }
}
