// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../storage/storage_service.dart';

class FirebaseApi with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();

  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>?> getUserData(String userUid) async {
    _isLoading = true;
    notifyListeners();

    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('users').doc(userUid).get();
      return doc.data();
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUserData({
    final String? userUid,
    final bool? isVerified,
    final String? email,
    final String? password,
    final String? phoneNumber,
    final String? username,
    final String? fullName,
    final String? gender,
    final String? birthday,
    final String? imageUrl,
    final bool? admin,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('users').doc(userUid).set({
        'userUid': userUid,
        'isVerified': isVerified,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber ?? '',
        'username': username ?? '',
        'fullName': fullName ?? '',
        'gender': gender ?? '',
        'birthday': birthday ?? '',
        'imageUrl': imageUrl ?? '',
        'created': DateTime.now(),
        'admin': false,
      });
    } catch (e) {
      print('Error creating user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editUserProfile({
    required String userUid,
    bool? isVerified,
    String? email,
    String? password,
    String? phoneNumber,
    String? username,
    String? fullName,
    String? gender,
    String? birthday,
    String? photoURL,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> dataToUpdate = {};

      if (isVerified != null) dataToUpdate['isVerified'] = isVerified;
      if (email != null) dataToUpdate['email'] = email;
      if (password != null) dataToUpdate['password'] = password;
      if (phoneNumber != null) dataToUpdate['phoneNumber'] = phoneNumber;
      if (username != null) dataToUpdate['username'] = username;
      if (fullName != null) dataToUpdate['fullName'] = fullName;
      if (gender != null) dataToUpdate['gender'] = gender;
      if (birthday != null) dataToUpdate['birthday'] = birthday;
      if (photoURL != null) dataToUpdate['photoURL'] = photoURL;

      await _firestore.collection('users').doc(userUid).update(dataToUpdate);

      if (user != null) {
        if (username != null && username != '') {
          await user?.updateDisplayName(username);
        }
        if (photoURL != null && photoURL != '') {
          await user?.updatePhotoURL(photoURL);
        }
        if (email != null && email.isNotEmpty) {
          await user?.verifyBeforeUpdateEmail(email);
        }
        if (password != null && password != '') {
          await user?.updatePassword(password);
        }
        await user?.reload();
      }
    } catch (e) {
      print('Error editing user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserVerificationStatus({
    required String userUid,
    required bool isVerified,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore
          .collection('users')
          .doc(userUid)
          .update({'isVerified': isVerified});
    } catch (e) {
      print('Error updating verification status: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> updateProfilePicture({
    required String userUid,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      String? downloadUrl =
          await _storageService.uploadProfilePicture(userUid: userUid);

      if (downloadUrl == null) {
        return null;
      }

      await _firestore
          .collection('users')
          .doc(userUid)
          .update({'imageUrl': downloadUrl});

      if (user != null) {
        await user!.updatePhotoURL(downloadUrl);
        await user!.reload();
      }
      return downloadUrl;
    } catch (e) {
      print('Error updating profile picture: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserAdminStatus(String userUid, bool adminValue) async {
    try {
      await _firestore.collection('users').doc(userUid).update({
        'admin': adminValue,
      });
      notifyListeners();
    } catch (e) {
      print('Error updating admin status: $e');
    }
  }

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

  // Future<List<Map<String, dynamic>>> fetchDestinations({
  //   final String? destinationId,
  //   required final String parentPath,
  // }) async {
  //   final List<Map<String, dynamic>> destinations = [];
  //   final List<String> destinationIds = ['destinationId1', 'destinationId2'];

  //   for (final destinationId in destinationIds) {
  //     final destinationData = await FirebaseApi().getDestinationData(
  //       parentPath: parentPath,
  //       destinationId: destinationId,
  //     );
  //     if (destinationData != null) {
  //       destinations.add(destinationData);
  //     }
  //   }

  //   return destinations;
  // }

  Future<List<Map<String, dynamic>>> fetchDestinations({
    required final String collection,
  }) async {
    try {
      final querySnapshot = await _firestore.collection(collection).get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching destinations: $e');
      return [];
    }
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

  Future<List<Map<String, dynamic>>> fetchDocuments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot =
          await _firestore.collection('case_study_destinations').get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching case studies: $e');
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, bool>> fetchPassport() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('medals').doc('passport').get();

      if (snapshot.exists && snapshot.data() != null) {
        return snapshot
            .data()!
            .map((key, value) => MapEntry(key, value as bool));
      } else {
        return {};
      }
    } catch (e) {
      print('Error fetching countries: $e');
      return {};
    }
  }

  Future<void> updatePassportStatus(String country, bool visited) async {
    try {
      await _firestore.collection('medals').doc('passport').update({
        country: visited,
      });
      notifyListeners();
    } catch (e) {
      print('Error updating country status: $e');
    }
  }

  Future<void> updateVisitedState(String countryName, bool visited) async {
    try {
      await _firestore
          .collection('medals')
          .doc('passport')
          .update({countryName: visited});
      notifyListeners();
    } catch (e) {
      print('Error updating visited state: $e');
      rethrow;
    }
  }

  Future<double> getAverageRating({
    required String collectionId,
    required String destinationId,
  }) async {
    final doc = await FirebaseFirestore.instance
        .collection(collectionId)
        .doc(destinationId)
        .get();

    final Map<String, dynamic>? ratings = doc.data()?['rating'];

    if (ratings == null || ratings.isEmpty) return 0.0;

    final totalStars = ratings.values.fold<num>(0, (stars, review) {
      return stars + (review['ratingStars'] ?? 0);
    });

    return totalStars / ratings.length;
  }

  Future<void> addReview({
    required String collectionId,
    required String destinationId,
    required String userId,
    required String userName,
    required double ratingStars,
    String? reviewComment,
  }) async {
    final reviewData = {
      'userName': userName,
      'ratingStars': ratingStars,
      'reviewComment': reviewComment ?? '',
      'timestamp': FieldValue.serverTimestamp(),
    };

    final docRef =
        FirebaseFirestore.instance.collection(collectionId).doc(destinationId);

    await docRef.set({
      'ratings': {
        userId: reviewData,
      }
    }, SetOptions(merge: true));
  }

  Future<void> deleteReview({
    required String collectionId,
    required String destinationId,
    required String userId,
  }) async {
    await FirebaseFirestore.instance
        .collection(collectionId)
        .doc(destinationId)
        .update({
      'ratings.$userId': FieldValue.delete(),
    });
  }

  Future<List<Map<String, dynamic>>> getReviews(String destinationId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('destinations')
          .doc(destinationId)
          .collection('reviews')
          .get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDestinationReviews({
    required String collectionId,
    required String destinationId,
  }) async {
    try {
      QuerySnapshot reviewsSnapshot = await _firestore
          .collection(collectionId)
          .doc(destinationId)
          .collection('ratings')
          .get();

      return reviewsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }
}
