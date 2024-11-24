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
  final TextEditingController buildingIdController = TextEditingController(); // Controller for building ID input
  final TextEditingController _buildingIdController = TextEditingController();
  late FirestoreService _firestoreService; // Declare the variable

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService(); // Initialize the instance
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
            ElevatedButton(
              onPressed: () {
                _firestoreService.findUserByEmail(); // Call the function from FirestoreService
              },
              child: const Text('Find Users by Email'),
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
            // TextField for Building ID
            TextField(
              controller: buildingIdController,
              decoration: const InputDecoration(
                labelText: 'Enter Building ID',
              ),
            ),
            // Button to read a single building by Building ID
            ElevatedButton(
              onPressed: () {
                String buildingId = buildingIdController.text;
                _firestoreService.getBuildingByBuildingId(buildingId).then((snapshot) {
                  if (snapshot != null) {
                    Map<String, dynamic> building = snapshot.data()!;
                    print('--------------------');
                    print('Document ID: ${snapshot.id}');
                    print('Building Name: ${building['buildingName']}');
                    print('Building Address: ${building['buildingAddress']}');
                    print('Building Company: ${building['companyName']}');
                    print('--------------------');
                    // ... (Print other building details)
                  } else {
                    print('Building not found.');
                  }
                });
              },
              child: const Text('Read Building by Building ID'),
            ),
            // TextField for Contact-Us Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Enter Email',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String emailId = emailController.text;
                _firestoreService.getContactUsbyEmail(emailId).then((snapshot) {
                  if (snapshot != null) {
                    Map<String, dynamic> contactUs = snapshot.data()!;
                    print('--------------------');
                    print('Document ID: ${snapshot.id}');
                    print('Company: ${contactUs['Company']}');
                    print('Email: ${contactUs['Email']}');
                    print('First Name: ${contactUs['firstName']}');
                    print('Last Name: ${contactUs['lastName']}');
                    print('Subject: ${contactUs['Subject']}');
                    print('Message: ${contactUs['Message']}');
                    print('--------------------');
                  }
                });
              },
              child: const Text('Read Contact-Us by Email'),
            ),
            // Button to read all forms in Access Control Keypads
            ElevatedButton(
              onPressed: () {
                _firestoreService.getAllFormsInAccessControlKeypads().then((formsData) {
                  
                  print('-----------------------------');

                  for (Map<String, dynamic> form in formsData) {

                    // Print Form ID
                    print('Form ID: ${form['id']}'); 

                    // Extract and print the Building Reference first
                    if (form.containsKey('building') && form['building'] is DocumentReference) {
                      // Cleaned-up output for Building Reference, only the path
                      DocumentReference buildingRef = form['building'];
                      print('Building: ${buildingRef.path}');
                    }

                    // Print Form Data
                    print('Form Data:');
                    form.forEach((key, value) {
                      if (key == 'id' || key == 'building') return; // Skip 'id' and 'building'

                      if (value is Map) {
                        // Handle nested Maps (like formData)
                        print('  $key:');
                        value.forEach((nestedKey, nestedValue) {
                          print('    $nestedKey: $nestedValue');
                        });
                      } else {
                        // Print other top-level key-value pairs
                        print('  $key: $value');
                      }
                    });

                    print('-----------------------------'); // Seperator between forms
                  }
                }).catchError((error) {
                  print('Error getting forms: $error');
                });
              },
              child: const Text('Read All Forms in Specific Subcollection in Physical Security'),
            ),
            // Text field to input building document ID
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _buildingIdController,
                decoration: const InputDecoration(
                  labelText: 'Enter Building Document ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Button to query forms
            ElevatedButton(
              onPressed: () {
                String buildingId = _buildingIdController.text.trim();

                if (buildingId.isEmpty) {
                  print('Please enter a valid Building ID');
                  return;
                }

                _firestoreService.getFormsByBuildingId(buildingId).then((formsData) {
                  if (formsData.isEmpty) {
                    print('----------------------------------------------------------');
                    print(
                        'No forms found with the Building ID "$buildingId" in this subcollection.');
                    print('----------------------------------------------------------');
                    return;
                  }

                  print('-----------------------------');
                  for (Map<String, dynamic> form in formsData) {
                    // Print Form ID
                    print('Form ID: ${form['id']}');

                    // Extract and print the Building ID
                    if (form.containsKey('building') &&
                        form['building'] is DocumentReference) {
                      DocumentReference buildingRef = form['building'];
                      print('Building ID: ${buildingRef.id}');
                    }

                    // Print Form Data
                    print('Form Data:');
                    form.forEach((key, value) {
                      if (key == 'id' || key == 'building') return; // Skip 'id' and 'building'

                      if (value is Map) {
                        // Handle nested Maps (like formData)
                        print('  $key:');
                        value.forEach((nestedKey, nestedValue) {
                          print('    $nestedKey: $nestedValue');
                        });
                      } else {
                        // Print other top-level key-value pairs
                        print('  $key: $value');
                      }
                    });

                    print('-----------------------------'); // Separator between forms
                  }
                }).catchError((error) {
                  print('Error getting forms: $error');
                });
              },
              child: const Text('Query Forms by Building Document ID'),
            ),
          ],
        ),
      ),
    );
  }


// CRUD Operations using FirestoreService

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
}