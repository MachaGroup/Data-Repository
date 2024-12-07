import 'package:cloud_firestore/cloud_firestore.dart';

// Any and all of these should be able to be changed to different collections as you see fit. But for the most part should remain as they are.

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Users Collection
  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').add(userData);
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUsersStream(String userId) async {
    try {
      return await _firestore.collection('users').doc(userId).get();
    } catch (e) {
      print('Error getting user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('users').doc(userId).update(updatedData);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

// Subcollection: Assignments (within Users)
  Future<void> createAssignment(String userId, Map<String, dynamic> assignmentData) async {
    try {
      await _firestore.collection('users').doc(userId).collection('assignments').add(assignmentData);
    } catch (e) {
      print('Error creating assignment: $e');
      rethrow;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getAssignment(String userId, String assignmentId) async {
    try {
      return await _firestore.collection('users').doc(userId).collection('assignments').doc(assignmentId).get();
    } catch (e) {
      print('Error getting assignment: $e');
      rethrow;
    }
  }

  Future<void> updateAssignment(String userId, String assignmentId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('users').doc(userId).collection('assignments').doc(assignmentId).update(updatedData);
    } catch (e) {
      print('Error updating assignment: $e');
      rethrow;
    }
  }

  Future<void> deleteAssignment(String userId, String assignmentId) async {
    try {
      await _firestore.collection('users').doc(userId).collection('assignments').doc(assignmentId).delete();
    } catch (e) {
      print('Error deleting assignment: $e');
      rethrow;
    }
  }

  // Code to create subcollection within projects collection called tasks
  Future<void> createTasks(String projectId, Map<String, dynamic> tasksData) async {
      try {
        await _firestore.collection('projects').doc(projectId).collection('tasks').add(tasksData);
      } catch (e) {
        print('Error creating tasks: $e');
        rethrow;
      }
    }
  
  // Code to create subcolection within tasks collection called Comments
  Future<void> createComments(String taskId, Map<String, dynamic> taskData) async {
    try {
      await _firestore.collection('tasks').doc(taskId).collection('Comments').add(taskData);
    } catch (e) {
      print('Error creating comments: $e');
      rethrow;
    }
  }

  // Code to create subcollection within tasks collection called Subtasks
  Future<void> createSubtasks(String taskId, Map<String, dynamic> taskData) async {
    try {
      await _firestore.collection('tasks').doc(taskId).collection('Subtasks').add(taskData);
    } catch (e) {
      print('Error creating subtasks: $e');
      rethrow;
    }
  }

  // Example of how to create a document reference in a collection
  Future<void> createUserTasksRef(String usertasksRefId, Map<String, dynamic> projectData) async {
    try {
      //Create a document reference to the subcollection
      DocumentReference taskRef = _firestore.collection('users').doc(usertasksRefId).collection('Tasks').doc();
      await taskRef.set(projectData);
    } catch (e) {
      print('Error creating Tasks');
      rethrow;
    }
  }

  // This is an example of a batch write, using the test collection
  Future<void> batchWriteExample() async {
    try {
      // Create a WriteBatch
      WriteBatch batch = _firestore.batch();

      // Add operations to the batch
      // Example: adding test contact Info to the contact-us collection
      batch.set(
        _firestore.collection('contact-us').doc(), // Creates a document in the contact us page (you can also change which collection to write to)
        { // All information below is the fields in the documnets, you can add as many fields as you want too.
          'Email': 'Brandon@example.com',
          'FirstName': 'Brandon',
          'LastName': 'Mihalko',
          'Subject':'Testing Batch Write',
          'Message':'This is a message to try and test out batch writes to the contact-us page by Brandond Mihalko',
          'Timestamp': Timestamp.now(),
        },
      );

      batch.set(
        _firestore.collection('contact-us').doc(), // Creates a document in the contact us page (you can also change which collection to write to)
        { // All information below is the fields in the documnets, you can add as many fields as you want too.
          'Email': 'Liz@example.com',
          'FirstName': 'Liz',
          'LastName': 'Hall',
          'Subject':' Testing Batch Write',
          'Message':'I am having fun trying out new things and learning more about this app. I have had fun creating designing the backend',
          'Timestamp': Timestamp.now(),
        },
      );

      batch.set(
        _firestore.collection('contact-us').doc(), // Creates a document in the contact us page (you can also change which collection to write to)
        { // All information below is the fields in the documnets, you can add as many fields as you want too.
          'Email': 'favour@example.com',
          'FirstName': 'Favour',
          'LastName': 'Agho',
          'Subject':'Testing Batch Write',
          'Message':'This is a test to again, see if batch writing works tot he contact-us page',
          'Timestamp': Timestamp.now(),
        },
      );

      // Commit the batch
      await batch.commit();

      print('Batch write completed successfully!');
    } catch (e) {
      print('Error during batch write: $e');
      rethrow;
    }
  }

  Future<void> batchUpdateExample() async {
    try {
      // Define the collection you want to update
      final collectionRef = _firestore.collection('users');

      // Create a WriteBatch
      final batch = _firestore.batch();

      final query1 = collectionRef.where('email', isEqualTo: 'favour@example.com');
      final querySnapshot1 = await query1.get();

      if (querySnapshot1.docs.isEmpty) {
        print('No documents found with the email provided.');
        return;
      }

      for (final doc in querySnapshot1.docs) {
        batch.update(doc.reference, {
          'firstName' : 'Favour Updated',
          'lastName' : 'Agho Updated'
        });
      }


      // Define the query to select the documents you want to update
      final query2 = collectionRef.where('Email', isEqualTo: 'brandonmihalko@gmail.com');
      final querySnapshot2 = await query2.get();

      // Check if any documents were found
      if (querySnapshot2.docs.isEmpty) {
        print('No documents found with the email provided (please make sure the Email is correct).');
        return; // Exit the function if no documents are found
      }

      // Update the documents
      for (final doc in querySnapshot2.docs) {
        batch.update(doc.reference, {
          'BuildingName': 'Hampton Courts',
          'City': 'Columbia',
          'Country': 'United States',
          'State': 'South Carolina',
          'StreetAddress': '501 Pelham Dr. Apt A-106',
          'ZipCode': '29209',
          'Username': 'BMIHALKO'
        });
      }

      // Commit the batch
      await batch.commit();

      print('Batch update completed successfully!');
    } catch (e) {
      print('Error during batch update: $e');
      rethrow;
    }
  }

Future<DocumentSnapshot<Map<String, dynamic>>> getBuidingsStream(String buildingsId) async {
    try {
      return await _firestore.collection('Buildings').doc(buildingsId).get();
    } catch (e) {
      print('Error getting building: $e');
      rethrow;
    }
  }

// Read Buildings Collection
  Future<void> readBuildings() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Buildings').get();

      print('Buildings Data:'); // Print a header for clarity
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        print('--------------------'); // Seperator Between documents
        print('Document ID: ${doc.id}'); // This displays the randomly generated document ID that conatins this information
        print('Company Name: ${doc.get('companyName') ?? 'N/A'}');
        print('Building Name: ${doc.get('buildingName') ?? 'N/A'}');
        print('Building Address: ${doc.get('buildingAddress') ?? 'N/A'}');
        print('Building ID: ${doc.get('buildingId') ?? 'N/A'}');
        print('--------------------'); // Separator between documents
      }
    } catch (e) {
      print('Error reading Buildings collection: $e');
      rethrow;
    }
  }

Future<DocumentSnapshot<Map<String, dynamic>>?> getBuildingByBuildingId(String buildingId) async {
  try {
    QuerySnapshot querySnapshot = await _firestore
        .collection('Buildings')
        .where('buildingId', isEqualTo: buildingId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the reference of the first matching document
      DocumentReference<Map<String, dynamic>> docRef = querySnapshot.docs.first.reference
          as DocumentReference<Map<String, dynamic>>;

      // Get the DocumentSnapshot using the reference
      return await docRef.get();
    } else {
      return null; // Return null if no document is found
    }
  } catch (e) {
    print('Error getting building: $e');
    rethrow;
  }
}

  Future<void> findUserByEmail() async {
  // Define the email address to search for
  String email = 'brandonmihalko@gmail.com';

  // Perform a Firestore query to find the user
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users') // Access the 'users' collection
      .where('Email', isEqualTo: email) // Filter by email address
      .get(); // Execute the query and retrieve results

    // Check if any documents were found
    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the first matching document
      QueryDocumentSnapshot userDoc = querySnapshot.docs.first;
      print('--------------------------------------');
      // Print the document ID
      print('Document ID: ${userDoc.id}');
      // Print the user's username
      print('Username: ${userDoc.get('Username')}');
      // Print the user's building name
      print('Building Name: ${userDoc.get('BuildingName')}');
      // Print the user's street address
      print('Street Address: ${userDoc.get('StreetAddress')}');
      // Print the user's city
      print('City: ${userDoc.get('City')}' );
      // Print the user's state
      print('State: ${userDoc.get('State')}');
      // Print the user's zip code
      print('Zip Code: ${userDoc.get('ZipCode')}');
      print('--------------------------------------');
    } else {
      // Print a message if no user was found
      print('User not found.');
    }
  }

Future<DocumentSnapshot<Map<String, dynamic>>?> getContactUsbyEmail(String emailId) async {
  try {
    QuerySnapshot querySnapshot = await _firestore
        .collection('contact-us')
        .where('Email', isEqualTo: emailId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the reference of the first matching document
      DocumentReference<Map<String, dynamic>> docRef = querySnapshot.docs.first.reference
          as DocumentReference<Map<String, dynamic>>;

      // Get the DocumentSnapshot using the reference
      return await docRef.get();
    } else {
      return null; // Return null if no document is found
    }
  } catch (e) {
    print('Error getting building: $e');
    rethrow;
  }
}

Future<List<Map<String, dynamic>>> getAllFormsInSpecificSubcollection() async {
  try {
    // Query for all documents in the subcollection
    QuerySnapshot querySnapshot = await _firestore
        .collection('forms')
        .doc('Physical Security') // Target the Physical Security subcollection
        .collection('Security Gates') // Target the Access Control Keypads subcollection
        .get();

    // Process the query results
    List<Map<String, dynamic>> results = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Get the document ID
      String formId = doc.id; 

      // Add the document ID to the data
      results.add({
        'id': formId, // Add the document ID to the data
        ...doc.data() as Map<String, dynamic>
      });
    }
    return results;
  } catch (e) {
    print('Error getting forms: $e');
    rethrow;
  }
}

Future<List<Map<String, dynamic>>> getFormsByBuildingId(String buildingId) async {
  try {
    // Query for all documents with the given building ID
    QuerySnapshot querySnapshot = await _firestore
        .collection('forms')
        .doc('Physical Security') // Target the Physical Security subcollection (Can be switched to any subcollection directly under the forms collection)
        .collection('Security Gates') // Target the Access Control Systems subcollection (Can be any subcollection under the 7 subcollection sections)
        .where('building', isEqualTo: FirebaseFirestore.instance.doc('Buildings/$buildingId')) // Filter by building reference ID
        .get();

    // Process the query results
    List<Map<String, dynamic>> results = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Get the document ID
      String formId = doc.id;

      // Add the document ID to the data
      results.add({
        'id': formId,
        ...doc.data() as Map<String, dynamic>
      });
    }
    return results;
  } catch (e) {
    print('Error getting forms: $e');
    rethrow;
  }
}




}