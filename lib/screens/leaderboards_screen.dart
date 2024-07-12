import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderBoardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String today = DateTime.now().toString().substring(0, 10);

    return Scaffold(
  appBar: AppBar(title: const Text('Daily Step Leaderboard')),
  body: StreamBuilder(
    stream: FirebaseFirestore.instance
        .collectionGroup('steps')
        .where('date', isEqualTo: today)
        .orderBy('steps', descending: true)
        .limit(10) // Top 10 users
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            var userId = doc.reference.parent.parent!.id; // Extract user ID

            // Use a FutureBuilder to fetch the user's display name
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    title: LinearProgressIndicator(),
                  );
                }
                if (userSnapshot.hasData) {
                  return ListTile(
                    title: Text('User: ${userSnapshot.data!['displayName'] ?? 'Unknown User'}'),
                    subtitle: Text('Steps: ${doc['steps']}'),
                  );
                }
                return ListTile(
                  title: const Text('Failed to load user data'),
                );
              },
            );
          },
        );
      }
      return const Center(child: Text('No data available.'));
    },
  ),
);

  }
}
