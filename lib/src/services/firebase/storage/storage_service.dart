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

  Future<void> fetchImages() async {
    _isLoading = true;

    final ListResult result =
        await firebaseStorage.ref('uploaded_images/').listAll();

    final urls =
        await Future.wait(result.items.map((ref) => ref.getDownloadURL()));
    _imageUrls = urls;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteImages(String imageUrl) async {
    try {
      _imageUrls.remove(imageUrl);
      final String path = extractPathFromUrl(imageUrl);
      await firebaseStorage.ref(path).delete();
    } catch (e) {
      print('Error deleting image: $e');
    }
    notifyListeners();
  }

  String extractPathFromUrl(String url) {
    Uri uri = Uri.parse(url);
    String encodedPath = uri.pathSegments.last;
    return Uri.decodeComponent(encodedPath);
  }

  Future<void> uploadImage() async {
    _isUploading = true;
    notifyListeners();

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    try {
      String fileExtension = image.path.split('.').last;
      String filePath = 'uploaded_images/$fileExtension';
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

  Future<void> addDestination({
    required final String category,
    required final String subcategory,
    required final String imageId,
  }) async {
    _isUploading = true;
    notifyListeners();

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    try {
      String originalFilePath = 'destinations/$category/$subcategory/$imageId';
      String thumbnailFilePath =
          'destinations/$category/$subcategory/${imageId}_thumbnail';
      File file = File(image.path);

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
    } catch (e) {
      print('Error uploading: $e');
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
