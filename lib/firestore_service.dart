import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  // Code to create subcollection within projects collection called users
  Future<void> createUsers(String projectId, Map<String, dynamic> userData) async {
      try {
        await _firestore.collection('projects').doc(projectId).collection('users').add(userData);
      } catch (e) {
        print('Error creating user: $e');
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

  Future<void> createProjects(String projectsId, Map<String, dynamic> projectsData) async {
    try {
      await _firestore.collection('users').doc(projectsId).collection('Projects').add(projectsData);
    } catch (e) {
      print('Error creating Projects: $e');
      rethrow;
    }
  }

  Future<void> createUserTasks(String usertasksId, Map<String, dynamic> projectData) async {
    try {
      await _firestore.collection('users').doc(usertasksId).collection('Tasks').add(projectData);
    } catch (e) {
      print('Error creating Tasks');
      rethrow;
    }
  }

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

  Future<void> createUserWithProjectReference(
  String userId, 
  String projectId, 
  Map<String, dynamic> userData, {
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController emailController,
  }
  ) async {
    try {
      DocumentReference projectRef = _firestore.collection('projects').doc(projectId);
      await _firestore.collection('users').doc(userId).set({
        // Use the passed controllers to get values
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        // ... other user data
        'projectId': projectRef,
      });
    } catch (e) {
      print('Error creating user with project reference: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> queryDocumentsWithReferences(
      String collectionName, String referenceField, String referenceId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .where(referenceField, isEqualTo: referenceId) // Query using the string ID
          .get();

      List<Map<String, dynamic>> results = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        results.add(doc.data() as Map<String, dynamic>);
      }
      return results;
    } catch (e) {
      print('Error querying documents with references: $e');
      rethrow;
    }
  }

  // Batch Write Example
  Future<void> batchWriteExample() async {
    try {
      // Create a WriteBatch
      WriteBatch batch = _firestore.batch();

      // Add operations to the batch
      // Example: Add two new projects
      batch.set(
        _firestore.collection('users').doc(), // Generate a new document ID
        {
          'email': 'Brandon@example.com',
          'firstName': 'Brandon',
          'lastName': 'Mihalko',
        },
      );

      batch.set(
        _firestore.collection('users').doc(), // Generate a new document ID
        {
          'email': 'favour@example.com',
          'firstName': 'Favour',
          'lastName': 'Agho',
        },
      );

      batch.set(
        _firestore.collection('users').doc(), // Generate a new document ID
        {
          'email': 'favour@example.com',
          'firstName': 'Favour',
          'lastName': 'Agho',
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

  getBuildingsStream(String buildingDocId) {}


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
        print('Document ID: ${doc.id}');
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
  String email = 'machagroupwebapp@gmail.com';

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


}