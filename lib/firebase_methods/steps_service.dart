import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StepsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveDailySteps(int steps) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String date = DateTime.now().toString().substring(0, 10); // Format: YYYY-MM-DD
      DocumentReference stepDoc = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('steps')
          .doc(date);

      await stepDoc.set({
        'date': date,
        'steps': steps
      }, SetOptions(merge: true));

      print("steps saved: ${steps}" );
    }
  }
}
