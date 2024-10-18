import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StorageService with ChangeNotifier {
  final firebaseStorage = FirebaseStorage.instance;
  List<String> _imageUrls = [];
  bool _isLoading = false;
  bool _isUploading = false;

  // GETTERS
  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;

  // READ
  Future<void> fetchImages() async {
    _isLoading = true;
    // get list
    final ListResult result =
        await firebaseStorage.ref('uploaded_images/').listAll();
    // get download urls
    final urls =
        await Future.wait(result.items.map((ref) => ref.getDownloadURL()));
    _imageUrls = urls; // update urls
    _isLoading = false;
    notifyListeners();
  }

  // DELETE
  Future<void> deleteImages(String imageUrl) async {
    try {
      _imageUrls.remove(imageUrl); // remove from local list
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
    return Uri.decodeComponent(encodedPath); // url decoding the path
  }

  // UPLOAD
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

      if (image != null) {
        String fileExtension = image.path.split('.').last;
        String filePath = 'users/profile/$userUid.$fileExtension';
        File file = File(image.path);

        await firebaseStorage.ref(filePath).putFile(file);

        String downloadUrl =
            await firebaseStorage.ref(filePath).getDownloadURL();

        return downloadUrl;
      } else if (image == null) {
        return null;
      }
    } catch (e) {
      print('Error updating profile picture: $e');
    }
    return null;
  }
}
