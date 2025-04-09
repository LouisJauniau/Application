// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'traduction_persistence.dart';

/// An implementation of [SettingsPersistence] that uses
/// `package:shared_preferences`.
class LocalStorageTraductionPersistence extends TraductionPersistence {
  @override
  Future<bool> getTrade() async {
    final docRef = FirebaseFirestore.instance
        .collection('utilisateur')
        .doc(FirebaseAuth.instance.currentUser.uid);
    var doc = await docRef.get();

    if (doc.exists) {
      bool trade = doc.data()['trade'];
      return trade;
    }
    return false;
  }

  @override
  Future<void> saveTrade(bool value) async {
    final docRef = FirebaseFirestore.instance
        .collection('utilisateur')
        .doc(FirebaseAuth.instance.currentUser.uid);

    await docRef.update({'trade': value});
  }
}
