import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:getx/log_in_screen.dart';
import 'package:getx/match_model.dart';
import 'package:getx/match_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
    FirebaseCrashlytics.instance.log('enter in homepage');
  }

  List<MatchModel> list = [];

  BannerAd? _bannerAd;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_bannerAd == null) {
      _loadAd();
    }
  }

  void _loadAd() async {
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );

    if (size == null) {
      return;
    }

    BannerAd(
      adUnitId: "ca-app-pub-3940256099942544/9214589741",
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Called when an ad is successfully received.
          debugPrint("Ad was loaded.");
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // Called when an ad request failed.
          debugPrint("Ad failed to load with error: $err");
          ad.dispose();
        },
      ),
    ).load();
  }

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
                // throw Exception('My Exception');
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
      body: Column(
        children: [
          if (_bannerAd != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            ),
          Expanded(
            child: StreamBuilder(
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
                  for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                      in asyncSnapshot.data!.docs) {
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
                                    builder: (context) =>
                                        AddUpdateMatchScreen(match: footballMatch),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onTapAddIcon, child: Icon(Icons.add)),
    );
  }

  void _onTapAddIcon() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddUpdateMatchScreen(match: null)),
    );
  }
}
