// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'storage_service.dart';

class DestinationsService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();

  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<String?> addDestination({
    required final String collectionId,
    required final String category,
    required final String subcategory,
    required final String destinationName,
    required final String continent,
    required final String country,
    required final String description,
    required final String externalSource,
    required final String typeShit,
    required final String address,
    required Map<String, dynamic> hotspotData,
    final int? hotspotIndex,
    final bool? decideCoords,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionId)
          .where('destinationName', isEqualTo: destinationName)
          .limit(1)
          .get();

      String? docId;
      bool isUpdating = false;

      if (querySnapshot.docs.isNotEmpty) {
        docId = querySnapshot.docs.first.id;
        isUpdating = true;
      } else {
        docId = _firestore.collection(collectionId).doc().id;
      }

      await _firestore.collection(collectionId).doc(docId).set(
        {
          'docId': docId,
          'category': category,
          'subcategory': subcategory,
          'destinationName': destinationName,
          'continent': continent,
          'country': country,
          'description': description,
          'created': isUpdating
              ? FieldValue.serverTimestamp()
              : DateTime.now().toString(),
          'userName': user!.displayName,
          'userId': user!.uid,
          'userEmail': user!.email,
          'imagePath': '',
          'thumbnailPath': '',
          'imageSize': '',
          'source': externalSource,
          'type': typeShit,
          'address': address,
          'hotspotData': hotspotData,
        },
        SetOptions(merge: true),
      );

      if (typeShit == "Photographic") {
        final Map<String, String>? urls = await _storageService.addImage(
          collections: collectionId,
          category: category,
          subcategory: subcategory,
          imageId: docId,
          typeShit: typeShit,
        );
        if (urls != null) {
          await _firestore.collection(collectionId).doc(docId).set(
            {
              'imagePath': urls['imagePath'],
              'thumbnailPath': urls['thumbnailPath'],
              'imageSize': urls['imageSize'],
            },
            SetOptions(merge: true),
          );
        }
      }

      if (typeShit == "Tour") {
        if (decideCoords == false || decideCoords == null) {
          final Map<String, String>? hotspot =
              await _storageService.uploadHotspotImage(
            collectionId: collectionId,
            typeShit: typeShit,
            category: category,
            subcategory: subcategory,
            imageId: docId,
            hotspotIndex: hotspotIndex!,
          );

          if (hotspot != null) {
            hotspotData['hotspot$hotspotIndex'] = {
              'imagePath': hotspot['imagePath'],
              'thumbnailPath': hotspot['thumbnailPath'],
            };

            String? hotspot0ThumbnailPath;
            try {
              DocumentSnapshot snapshot =
                  await _firestore.collection(collectionId).doc(docId).get();

              if (snapshot.exists) {
                Map<String, dynamic>? data =
                    snapshot.data() as Map<String, dynamic>?;
                if (data != null &&
                    data.containsKey('hotspotData') &&
                    data['hotspotData'] is Map &&
                    data['hotspotData']['hotspot0'] is Map &&
                    data['hotspotData']['hotspot0']
                        .containsKey('thumbnailPath')) {
                  hotspot0ThumbnailPath =
                      data['hotspotData']['hotspot0']['thumbnailPath'];
                }
              }
            } catch (e) {
              print("Error fetching hotspot0 thumbnailPath: $e");
            }

            String? finalThumbnailPath =
                hotspot0ThumbnailPath ?? hotspot['thumbnailPath'];

            await _firestore.collection(collectionId).doc(docId).update(
              {
                'hotspotData': hotspotData,
                'thumbnailPath': finalThumbnailPath,
              },
            );
          }
        } else if (decideCoords == true) {
          await _firestore.collection(collectionId).doc(docId).update(
            {
              'hotspotData': hotspotData,
            },
          );
        }
      }
    } catch (e) {
      print('Error adding/updating destination in database: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> fetchDestinations({
    required String collection,
  }) async {
    var snapshot = await _firestore.collection(collection).get();

    return snapshot.docs.map((doc) {
      var data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<Map<String, dynamic>?> getDestinationData({
    final String? destinationId,
    required final String parentPath,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection(parentPath)
          .doc(destinationId ?? '')
          .get();
      return doc.data();
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> fetchDocuments({
    required final String collection,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await _firestore.collection(collection).get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching case studies: $e');
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
