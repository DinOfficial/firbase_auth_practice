import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getx/sign_up_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: IconButton(
              onPressed: () async {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  (route) => false,
                );
              },
              icon: Icon(Icons.logout, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
      body: currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  if (currentUser?.photoURL != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        currentUser!.photoURL!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                  const SizedBox(height: 12),
                  Text(
                    'Name : ${FirebaseAuth.instance.currentUser?.displayName ?? 'N/A'} \n'
                    'Email: ${FirebaseAuth.instance.currentUser?.email ?? 'N/A'} \n'
                    'Last Sign In: ${FirebaseAuth.instance.currentUser?.metadata.lastSignInTime ?? 'N/A'} ',
                  ),
                ],
              ),
            ),
    );
  }
}
