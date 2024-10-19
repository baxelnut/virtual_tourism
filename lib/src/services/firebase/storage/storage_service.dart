// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

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

        // Decode the image to a format for manipulation
        img.Image? originalImage = img.decodeImage(imageBytes);

        // Check if the image needs to be compressed
        int quality = 100; // Start with maximum quality
        int maxSizeInBytes = 1024 * 1024; // 1MB in bytes

        // Compress the image until it is <= 1MB
        while (imageBytes.length > maxSizeInBytes && quality > 0) {
          imageBytes = img.encodeJpg(originalImage!, quality: quality);
          quality -= 10; // Decrease quality by 10% on each iteration
        }

        // Write the compressed image back to the same file path
        await file.writeAsBytes(imageBytes); // Overwrite the original file

        // Upload the (possibly compressed) file
        await firebaseStorage.ref(filePath).putFile(file);

        String photoURL =
            await firebaseStorage.ref(filePath).getDownloadURL();

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
}
