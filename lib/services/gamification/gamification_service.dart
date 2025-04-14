import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class GamificationService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> announce({
    required final Map<String, dynamic> destinationData,
  }) async {
    try {
      await initializeDateFormatting('id_ID', null);

      final String userId = user?.uid ?? "Anonymous";
      final String username = user?.displayName ?? "username";
      final String userInfo = user?.toString() ?? "No data";
      final String artefactName =
          destinationData['artefact']?['name'] ?? "Virgin Oil (Extra)";
      final String destinationName =
          destinationData['destinationName'] ?? "destinationName";
      final String destinationId = destinationData['docId'] ?? 'NO ID?!';

      final String formattedDate =
          DateFormat('yyyyMMdd_HHmmss', 'id_ID').format(DateTime.now());

      await _firestore.collection("gamification").doc("user_news").set({
        "${formattedDate}_$userId": {
          "userId": userId,
          "username": username,
          "artefactName": artefactName,
          "destinationName": destinationName,
          "destinationId": destinationId,
          "announcement":
              '$username has obtained "$artefactName" at "$destinationName"',
          "destinationInfo": destinationData,
          "recorded": formattedDate,
          "userInfo": userInfo,
        },
      }, SetOptions(merge: true));

      debugPrint("Announcement updated at $formattedDate");
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> updateUserArtefact({
    required final Map<String, dynamic> destinationData,
  }) async {
    try {
      await initializeDateFormatting('id_ID', null);

      final String userId = user?.uid ?? "Anonymous";
      final String artefactName =
          destinationData['artefact']?['name'] ?? "Virgin Oil (Extra)";
      final String destinationName =
          destinationData['destinationName'] ?? "No destinationName?!";
      final String destinationId = destinationData['docId'] ?? 'NO ID?!';

      final String formattedDate =
          DateFormat('yyyyMMdd_HHmmss', 'id_ID').format(DateTime.now());

      final String givenBy = destinationData['userName'] ?? "Dev";

      final info = {
        "artefactName": artefactName,
        "destinationId": destinationId,
        "destinationName": destinationName,
        "timeAcquired": formattedDate,
        "givenBy": givenBy,
      };

      await _firestore.collection("users").doc(userId).set({
        "artefactAcquired": {destinationId: info},
      }, SetOptions(merge: true));

      debugPrint("User stats updated at $formattedDate");
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> updateUserTrivia({
    required final Map<String, dynamic> destinationData,
  }) async {
    try {
      await initializeDateFormatting('id_ID', null);

      final String userId = user?.uid ?? "Anonymous";
      final String destinationName =
          destinationData['destinationName'] ?? "No destinationName?1";
      final String destinationId = destinationData['docId'] ?? 'NO ID?!';

      final String formattedDate =
          DateFormat('yyyyMMdd_HHmmss', 'id_ID').format(DateTime.now());

      final String givenBy = destinationData['userName'] ?? "Dev";

      final dynamic trivia = destinationData['trivia'] ?? "No Trivia?!";

      final info = {
        "destinationId": destinationId,
        "destinationName": destinationName,
        "timeAcquired": formattedDate,
        "givenBy": givenBy,
        "trivia": trivia,
      };

      await _firestore.collection("users").doc(userId).set({
        "triviaAnswered": {destinationId: info},
      }, SetOptions(merge: true));

      debugPrint("User stats updated at $formattedDate");
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<Map<String, bool>> fetchPassport() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('medals').doc('passport').get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        return data.map((country, value) {
          final visitedCount = value['visitedCount'] ?? 0;
          return MapEntry(country, visitedCount > 0);
        });
      } else {
        return {};
      }
    } catch (e) {
      debugPrint('Error fetching passport data: $e');
      return {};
    }
  }

  Future<List<String>> fetchUserVisitedCountries() async {
    final String userId = user?.uid ?? "Anonymous";
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("users").doc(userId).get();

    if (!snapshot.exists || snapshot.data() == null) return [];

    final data = snapshot.data()!;
    final passport = data['passport'] as Map<String, dynamic>?;

    if (passport == null) return [];
    debugPrint(passport.keys.toString());
    return passport.keys.toList();
  }

  Future<String?> updatePassport({
    required final Map<String, dynamic> destinationData,
  }) async {
    try {
      await initializeDateFormatting('id_ID', null);

      final String userId = user?.uid ?? "Anonymous";
      final String formattedDate =
          DateFormat('yyyyMMdd_HHmmss', 'id_ID').format(DateTime.now());
      final String givenBy = destinationData['userName'] ?? "Dev";
      final String countryName = destinationData['country'] ?? "No Man's Land";

      final DocumentReference userDoc =
          _firestore.collection("users").doc(userId);

      final userSnapshot = await userDoc.get();
      final userData = userSnapshot.data() as Map<String, dynamic>?;

      final currentPassport =
          userData?['passport'] as Map<String, dynamic>? ?? {};

      if (currentPassport.containsKey(countryName)) {
        debugPrint(
            "Country $countryName already in passport, skipping update.");
        return null;
      }
      final info = {
        "country": countryName,
        "timeAcquired": formattedDate,
        "givenBy": givenBy,
      };

      await userDoc.set({
        "passport": {
          countryName: info,
        },
      }, SetOptions(merge: true));

      return "Passport updated with country: $countryName";
    } catch (e) {
      return "Error updating passport: $e";
    }
  }

  Future<void> addArtefacts({
    required final String artefactName,
    required final String location,
    required final String locationId,
    required final dynamic fullInfo,
    required final dynamic typeShit,
  }) async {
    try {
      await initializeDateFormatting('id_ID', null);
      final String formattedDate =
          DateFormat('yyyyMMdd_HHmmss', 'id_ID').format(DateTime.now());

      final String creator = user?.displayName ?? "Anonymous";
      final String creatorId = user?.uid ?? "NO ID??!!";

      final String artefactId =
          '${artefactName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';

      final Map<String, dynamic> artefactData = {
        "id": artefactId,
        "artefactName": artefactName,
        "creator": creator,
        "creatorId": creatorId,
        "location": location,
        "locationId": locationId,
        "created": formattedDate,
        "fullInfo": fullInfo,
        "type": typeShit,
      };

      await _firestore.collection("medals").doc("artefact").set({
        locationId: artefactData,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error adding artefact: $e");
    }
  }

  Future<void> addTrivia({
    required final dynamic trivia,
    required final String locationId,
  }) async {
    try {
      await initializeDateFormatting('id_ID', null);
      final String formattedDate =
          DateFormat('yyyyMMdd_HHmmss', 'id_ID').format(DateTime.now());

      final String creator = user?.displayName ?? "Anonymous";
      final String creatorId = user?.uid ?? "NO ID??!!";

      final Map<String, dynamic> triviaData = {
        "trivia": trivia,
        "creator": creator,
        "creatorId": creatorId,
        "locationId": locationId,
        "created": formattedDate,
      };

      await _firestore.collection("medals").doc("trivia").set({
        locationId: triviaData,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error adding trivia: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchArtefacts() async {
    try {
      final snapshot =
          await _firestore.collection('medals').doc('artefact').get();

      final uid = user?.uid;
      if (uid == null) throw Exception('User not logged in');

      final obtainedArtefactIds = await fetchUserObtainedArtefacts(uid);

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;

        return data.entries.map((entry) {
          final id = entry.key;
          final fullInfo = entry.value;
          final obtained = obtainedArtefactIds.contains(id);
          return {
            "id": id,
            "obtained": obtained,
            "fullInfo": fullInfo,
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching artefact data: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchTrivia() async {
    try {
      final snapshot =
          await _firestore.collection('medals').doc('trivia').get();

      final uid = user?.uid;
      if (uid == null) throw Exception('User not logged in');

      final answeredTriviaId = await fetchUserAnsweredTrivia(uid);

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;

        return data.entries.map((entry) {
          final id = entry.key;
          final fullInfo = entry.value;
          final obtained = answeredTriviaId.contains(id);
          return {
            "id": id,
            "obtained": obtained,
            "fullInfo": fullInfo,
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching artefact data: $e');
      return [];
    }
  }

  Future<Set<String>> fetchUserObtainedArtefacts(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      final artefactMap =
          userDoc.data()?['artefactAcquired'] as Map<String, dynamic>?;

      if (artefactMap != null) {
        return artefactMap.keys.toSet(); // returns a set of artefact IDs
      } else {
        return {};
      }
    } catch (e) {
      debugPrint('Error fetching user artefacts: $e');
      return {};
    }
  }

  Future<Set<String>> fetchUserAnsweredTrivia(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      final triviaMap =
          userDoc.data()?['triviaAnswered'] as Map<String, dynamic>?;

      if (triviaMap != null) {
        return triviaMap.keys.toSet(); // returns a set of artefact IDs
      } else {
        return {};
      }
    } catch (e) {
      debugPrint('Error fetching user artefacts: $e');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> fetchPassportWithStatus() async {
    try {
      final allCountries = await fetchPassport();
      final visited = await fetchUserVisitedCountries();

      return allCountries.entries.map((entry) {
        final id = entry.key;
        final fullInfo = entry.value;
        final obtained = visited.contains(id);
        return {
          "id": id,
          "obtained": obtained,
          "fullInfo": fullInfo,
        };
      }).toList();
    } catch (e) {
      debugPrint('Error fetching passport with status: $e');
      return [];
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchAllMedals() async {
    final passports = await fetchPassportWithStatus();
    final artefacts = await fetchArtefacts();
    final trivias = await fetchTrivia();

    return {
      'passports': passports,
      'artefacts': artefacts,
      'trivias': trivias,
    };
  }

  // DO THIS ONLY ONE TIME!
  Future<void> initializePassportData() async {
    final List<String> countries = [
      "Afghanistan",
      "Albania",
      "Algeria",
      "Andorra",
      "Angola",
      "Antigua and Barbuda",
      "Argentina",
      "Armenia",
      "Australia",
      "Austria",
      "Azerbaijan",
      "Bahamas",
      "Bahrain",
      "Bangladesh",
      "Barbados",
      "Belarus",
      "Belgium",
      "Belize",
      "Benin",
      "Bhutan",
      "Bolivia",
      "Bosnia and Herzegovina",
      "Botswana",
      "Brazil",
      "Brunei",
      "Bulgaria",
      "Burkina Faso",
      "Burundi",
      "Cabo Verde",
      "Cambodia",
      "Cameroon",
      "Canada",
      "Central African Republic",
      "Chad",
      "Chile",
      "China",
      "Colombia",
      "Comoros",
      "Congo (Congo-Brazzaville)",
      "Costa Rica",
      "Croatia",
      "Cuba",
      "Cyprus",
      "Czechia (Czech Republic)",
      "Democratic Republic of the Congo",
      "Denmark",
      "Djibouti",
      "Dominica",
      "Dominican Republic",
      "Ecuador",
      "Egypt",
      "El Salvador",
      "Equatorial Guinea",
      "Eritrea",
      "Estonia",
      "Eswatini (fmr. Swaziland)",
      "Ethiopia",
      "Fiji",
      "Finland",
      "France",
      "Gabon",
      "Gambia",
      "Georgia",
      "Germany",
      "Ghana",
      "Greece",
      "Grenada",
      "Guatemala",
      "Guinea",
      "Guinea-Bissau",
      "Guyana",
      "Haiti",
      "Honduras",
      "Hungary",
      "Iceland",
      "India",
      "Indonesia",
      "Iran",
      "Iraq",
      "Ireland",
      "Israel",
      "Italy",
      "Ivory Coast",
      "Jamaica",
      "Japan",
      "Jordan",
      "Kazakhstan",
      "Kenya",
      "Kiribati",
      "Kuwait",
      "Kyrgyzstan",
      "Laos",
      "Latvia",
      "Lebanon",
      "Lesotho",
      "Liberia",
      "Libya",
      "Liechtenstein",
      "Lithuania",
      "Luxembourg",
      "Madagascar",
      "Malawi",
      "Malaysia",
      "Maldives",
      "Mali",
      "Malta",
      "Marshall Islands",
      "Mauritania",
      "Mauritius",
      "Mexico",
      "Micronesia",
      "Moldova",
      "Monaco",
      "Mongolia",
      "Montenegro",
      "Morocco",
      "Mozambique",
      "Myanmar (formerly Burma)",
      "Namibia",
      "Nauru",
      "Nepal",
      "Netherlands",
      "New Zealand",
      "Nicaragua",
      "Niger",
      "Nigeria",
      "North Korea",
      "North Macedonia",
      "Norway",
      "Oman",
      "Pakistan",
      "Palau",
      "Palestine State",
      "Panama",
      "Papua New Guinea",
      "Paraguay",
      "Peru",
      "Philippines",
      "Poland",
      "Portugal",
      "Qatar",
      "Romania",
      "Russia",
      "Rwanda",
      "Saint Kitts and Nevis",
      "Saint Lucia",
      "Saint Vincent and the Grenadines",
      "Samoa",
      "San Marino",
      "Sao Tome and Principe",
      "Saudi Arabia",
      "Senegal",
      "Serbia",
      "Seychelles",
      "Sierra Leone",
      "Singapore",
      "Slovakia",
      "Slovenia",
      "Solomon Islands",
      "Somalia",
      "South Africa",
      "South Korea",
      "South Sudan",
      "Spain",
      "Sri Lanka",
      "Sudan",
      "Suriname",
      "Sweden",
      "Switzerland",
      "Syria",
      "Taiwan",
      "Tajikistan",
      "Tanzania",
      "Thailand",
      "Timor-Leste",
      "Togo",
      "Tonga",
      "Trinidad and Tobago",
      "Tunisia",
      "Turkey",
      "Turkmenistan",
      "Tuvalu",
      "Uganda",
      "Ukraine",
      "United Arab Emirates",
      "United Kingdom",
      "United States of America",
      "Uruguay",
      "Uzbekistan",
      "Vanuatu",
      "Vatican City",
      "Venezuela",
      "Vietnam",
      "Yemen",
      "Zambia",
      "Zimbabwe"
    ];

    final Map<String, dynamic> passportData = {};

    for (var country in countries) {
      passportData[country] = {
        "visitedBy": {}, // future work will add: username, userId, timestamp
        "visitedCount": 0,
      };
    }

    try {
      await _firestore.collection('medals').doc('passport').set(passportData);
      debugPrint('Passport data successfully initialized.');
    } catch (e) {
      debugPrint('Error initializing passport data: $e');
    }
  }
}
