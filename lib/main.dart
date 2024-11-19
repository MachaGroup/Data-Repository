import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studentdatabaseproject/firebase_options.dart';
import 'package:studentdatabaseproject/firestore_service.dart'; // Import your firestore_service.dart

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Database Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 77, 22, 173)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController taskIdController = TextEditingController();
  final TextEditingController userIdUpdateController = TextEditingController();
  final TextEditingController userIdReadController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController projectIdController = TextEditingController(); // Controller for project ID input
  final TextEditingController documentRefController = TextEditingController();
  late FirestoreService _firestoreService; // Declare the variable

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService(); // Initialize the instance
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
    } else {
      // Print a message if no user was found
      print('User not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore CRUD Operations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                addProject(); // Call function to create a task
              },
              child: const Text('Add Project'),
            ),
            // TextField to enter User ID for read
            TextField(
              controller: userIdReadController, // Set controller for User ID input
              decoration: const InputDecoration(
                labelText: 'Enter User ID',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String userID = userIdReadController.text;
                getUsers(userID); // Call function to read users
              },
              child: const Text('Read Users'),
            ),
            // TextField to enter User ID for update
            TextField(
              controller: userIdUpdateController, // Set controller for User ID input
              decoration: const InputDecoration(
                labelText: 'Enter User ID', // Label for User ID input
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String userId = userIdUpdateController.text; // Get the User ID from the input field
                updateUser(userId); // Call function to update the user with the specified ID
              },
              child: const Text('Update User'),
            ),
            TextField(
              controller: taskIdController, // Set controller for the input field
              decoration: const InputDecoration(
                labelText: 'Enter Task ID', // Label for the input field
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String taskId = taskIdController.text; // Get the Task ID from the input field
                deleteTask(taskId); // Call function to delete a task with the specified ID
              },
              child: const Text('Delete Task'),
            ),
            // Add a button to create a Task in the Projects Collection
            ElevatedButton(
              onPressed: () {
                // Get the project ID from a TextField or other input
                String projectsId = 'YeveWxgueVCcqDf1I4TO'; // Replace with actual project ID
                _firestoreService.createTasks(projectsId, {
                  'taskName': 'Create Wireframes',
                  'status': 'Incomplete',
                  'dueDate': DateTime(2024,09,15,),
                });
              },
              child: const Text('Create Task Within Projects Collection'),
            ),
            // Add a button to create Users in the Projects Collection
            ElevatedButton(
              onPressed: () {
                // Get the project ID from a textField or other input
                String projectsId = 'YeveWxgueVCcqDf1I4TO'; //Replace with actual project ID
                _firestoreService.createUsers (projectsId, {
                  'firstName': 'John',
                  'lastName': 'Doe',
                  'email': 'johndoe@example.com',
                });
              },
              child: const Text('Create User Within Projects Collection'),
            ),
            // Add a button to create Comments in the Tasks Collection
            ElevatedButton(
              onPressed: () {
                // Get the project ID from a textField or other input
                String taskId = 'Comments'; //Replace with actual task ID
                _firestoreService.createComments (taskId, {
                  'comment':'The project is on time and everything is working.',
                  'user': 'Brandon Mihalko',
                });
              },
              child: const Text('Create Comments Within Tasks Collection'),
            ),
            // Add a button to create Subtasks in the Tasks Collection
            ElevatedButton(
              onPressed: () {
                // Get the project ID from a textField or other input
                String taskId = 'Subtasks'; //Replace with actual task ID
                _firestoreService.createSubtasks (taskId, {
                  'subtask 1': 'Create Subcollections',
                  'subtask 2': 'Create Code for Subcollections',
                });
              },
              child: const Text('Create Subtasks Within Tasks Collection'),
            ),
            ElevatedButton(
              onPressed: () {
                String projectsId = 'Brandon Mihalko'; //replace with actual User ID
                _firestoreService.createProjects(projectsId, {
                  'Project': 'Data Repository'
                });
              },
              child: const Text('Create Projects Within Users Collection'),
            ),
            ElevatedButton(
              onPressed: () {
                String usertasksId = 'Brandon Mihalko'; // replace with actual User ID
                _firestoreService.createUserTasks(usertasksId, {
                  'Sprint 1': 'ERD'
                });
              },
              child: const Text('Create Tasks Within Users Collection'),
            ),

            // TextField for Project ID
            TextField(
              controller: projectIdController,
              decoration: const InputDecoration(
                labelText: 'Enter Project ID',
              ),
            ),

            // TextField for First Name
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'Enter First Name',
              ),
            ),

            // TextField for Last Name
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Enter Last Name',
              ),
            ),

            // TextField for Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Enter Email',
              ),
            ),

            // Button to create a user with a project reference
            ElevatedButton(
              onPressed: () {
                // Get user data from input fields
                String userId = 'user123'; // Replace with actual user ID
                String projectId = projectIdController.text; // Get project ID from input
                String firstName = firstNameController.text;
                String lastName = lastNameController.text;
                String email = emailController.text;

                // Call the createUserWithProjectReference function
                _firestoreService.createUserWithProjectReference(userId, projectId, {
                  'firstName': firstName,
                  'lastName': lastName,
                  'email': email,
                }, firstNameController: firstNameController,
                    lastNameController: lastNameController,
                    emailController: emailController,
                );
              },
              child: const Text('Create User with Project Reference'),
            ),
            ElevatedButton(onPressed: findUserByEmail, 
            child: const Text('Query Users by Email')
            ),
            ElevatedButton(
              onPressed: () {
                _firestoreService.batchWriteExample();
              },
              child: const Text('Perform the Batch Write.'),
            ),
            ElevatedButton(
              onPressed: () {
                _firestoreService.batchUpdateExample(); // Call your batch update function
              },
              child: const Text('Perform Batch Update'),
            ),
            // Add a button to read data from the Buildings collection
            ElevatedButton(
              onPressed: () async {
                await _firestoreService.readBuildings(); // Call the readBuildings function
              },
              child: const Text('Read Buildings'),
            ),
          ],
        ),
      ),
    );
  }


// CRUD Operations using FirestoreService
  Future<void> addProject() async {
  try {
    // Define the user data as a list of maps
    final projects = [
      {
        'projectName': 'Data Repository',
        'startDate': '2024-9-5',
        'endDate': '2024-11-29',
      }
    ];

    // Iterate through the user data and add each user to the 'users' collection
    for (final project in projects) {
      await _firestoreService.createProject(project);
    }

    // Display success message or update UI
    print('Projects added successfully!');
  } catch (e) {
    // Handle error
    print('Error adding users: $e');
  }
}

// 2. Read: Retrieve documents from the 'users' collection
  Future<void> getUsers(String userId) async {
    try {
      // Get a single user by ID
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _firestoreService.getUsersStream(userId);

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data()!;
         // Access the user data using the keys:
        String userEmail = userData['email'];
        String firstName = userData['firstName'];
        String lastName = userData['lastName'];

        print('User Email: $userEmail, First Name: $firstName, Last Name: $lastName'); 
      } else {
        print('User with ID $userId does not exist.');
      }
    } catch (e) {
      // Handle error
      print('Error getting user: $e');
    }
  }

// 3. Update: Update a document in the 'users' collection
  Future<void> updateUser(String userId) async {
    try {
      await _firestoreService.updateUser(userId, {
        'firstName': 'Updated First Name', // Replace with actual updated data
        'lastName': 'Updated Last Name', // Replace with actual updated data
        'email': 'updated@email.com', // Replace with actual updated data
      });
      // Display success message or update UI
    } catch (e) {
      // Handle error
      print('Error updating user: $e');
    }
  }

// 4. Delete: Delete a document from the 'tasks' collection
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestoreService.deleteTask(taskId);
      // Display success message or update UI
      print('Document successfully deleted: $taskId');
    } catch (e) {
      // Handle error
      print('Error deleting task: $e');
    }
  }
}