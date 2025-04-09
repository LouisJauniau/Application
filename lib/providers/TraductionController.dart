// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:aura2/providers/persistence/traduction_persistence.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// An class that holds settings like [playerName] or [musicOn],
/// and saves them to an injected persistence store.
class TraductionController {
  final TraductionPersistence _persistence;

  ValueNotifier<bool> trade = ValueNotifier(false);

  /// Creates a new instance of [SettingsController] backed by [persistence].
  TraductionController({
    @required TraductionPersistence persistence,
  }) : _persistence = persistence;

  /// Asynchronously loads values from the injected persistence store.
  Future<void> loadStateFromPersistence() async {
    await Future.wait([
      if (FirebaseAuth.instance.currentUser != null)
        _persistence.getTrade().then((value) => trade.value = value),
    ]);
  }

  void toggleTraduction() {
    trade.value = !trade.value;

    if (FirebaseAuth.instance.currentUser != null)
      _persistence.saveTrade(trade.value);
  }
}
