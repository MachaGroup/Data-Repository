import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Projects Collection
  Future<void> createProject(Map<String, dynamic> projectData) async {
    try {
      await _firestore.collection('projects').add(projectData);
    } catch (e) {
      print('Error creating project: $e');
      rethrow; // Rethrow to handle the error in the calling function
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getProject(String projectId) async {
    try {
      return await _firestore.collection('projects').doc(projectId).get();
    } catch (e) {
      print('Error getting project: $e');
      rethrow;
    }
  }

  Future<void> updateProject(String projectId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('projects').doc(projectId).update(updatedData);
    } catch (e) {
      print('Error updating project: $e');
      rethrow;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection('projects').doc(projectId).delete();
    } catch (e) {
      print('Error deleting project: $e');
      rethrow;
    }
  }

  // Tasks Collection
  Future<void> createTask(Map<String, dynamic> taskData) async {
    try {
      await _firestore.collection('tasks').add(taskData);
    } catch (e) {
      print('Error creating task: $e');
      rethrow;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getTask(String taskId) async {
    try {
      return await _firestore.collection('tasks').doc(taskId).get();
    } catch (e) {
      print('Error getting task: $e');
      rethrow;
    }
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update(updatedData);
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

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
        _firestore.collection('tasks').doc(), // Generate a new document ID
        {
          'taskName': 'Batch Write Test',
          'dueDate': '2024-10-20',
          'status': 'In Progress',
        },
      );

      batch.set(
        _firestore.collection('tasks').doc(), // Generate a new document ID
        {
          'taskName': 'Another Batch Write Test',
          'dueDate': '2024-11-3',
          'status': 'Not Started',
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

}