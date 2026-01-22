import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getx/log_in_screen.dart';
import 'package:getx/match_model.dart';
import 'package:getx/match_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'add_update_match_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MatchProvider matchProvider = MatchProvider();

  @override
  void initState() {
    super.initState();
    // Provider.of<MatchProvider>(context, listen: false).getMatches();
    // Provider.of<MatchProvider>(context, listen: false).list;
  }

  List<MatchModel> list = [];

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Live Score App'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: IconButton(
              onPressed: () async {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                  (route) => false,
                );
              },
              icon: Icon(Icons.logout, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: firestore.collection('football').snapshots(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshot.hasError) {
            return Center(child: Text('Error: ${asyncSnapshot.error}'));
          }
          if (asyncSnapshot.hasData) {
            list.clear();
            for (QueryDocumentSnapshot<Map<String, dynamic>> doc in asyncSnapshot.data!.docs) {
              list.add(MatchModel.fromJson(doc.data(), doc.id));
            }
            return ListView.separated(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final footballMatch = list[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 8,
                    backgroundColor: footballMatch.isRunning ? Colors.green : Colors.grey,
                  ),
                  title: Text('${footballMatch.team1Name} VS ${footballMatch.team2Name}'),
                  subtitle: Text('Winner Team: ${footballMatch.winnerTeam}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${footballMatch.team1Score} : ${footballMatch.team2Score}',
                        style: TextStyle(fontSize: 24),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddUpdateMatchScreen(match: footballMatch),
                            ),
                          );
                        },
                        icon: Icon(Icons.edit_location_alt_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          firestore
                              .collection('football')
                              .doc(asyncSnapshot.data!.docs[index].id)
                              .delete();
                        },
                        icon: Icon(Icons.delete_rounded, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 12);
              },
            );
          }
          return Center(child: Text('No Data'));
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onTapAddIcon, child: Icon(Icons.add)),
    );
  }

  void _onTapAddIcon() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddUpdateMatchScreen(match: null)));
  }
}
