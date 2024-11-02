import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop/core/domain/abstractions/user.abstraction.dart';
import 'package:eshop/core/domain/entities/user.entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService implements IUserService {
  final CollectionReference<Map<String, dynamic>> _userDataCollectionReference =
      FirebaseFirestore.instance.collection("users");
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> createUser(UserModel payload) async {
    try {
      await _userDataCollectionReference
          .doc(_firebaseAuth.currentUser?.uid ?? '')
          .set(payload.toJson());
    } on FirebaseException catch (e) {
      final message = e.message ?? '';

      throw HttpException(message);
    } catch (e) {
      final message = e.toString();

      throw HttpException(message);
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _userDataCollectionReference
          .doc(userId)
          .update({'status': 'Deleted'});
    } on FirebaseException catch (e) {
      final message = e.message ?? '';

      throw HttpException(message);
    } catch (e) {
      final message = e.toString();

      throw HttpException(message);
    }
  }

  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final snapshot = await _userDataCollectionReference.doc(userId).get();
      return snapshot.exists
          ? UserModel.fromJson(snapshot.data()!, snapshot.id)
          : throw const HttpException('User does not exist');
    } on FirebaseException catch (e) {
      final message = e.message ?? '';

      throw HttpException(message);
    } catch (e) {
      final message = e.toString();

      throw HttpException(message);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final snapshots = await _userDataCollectionReference.get();
      return snapshots.docs
          .map((e) => UserModel.fromJson(e.data(), e.id))
          .toList();
    } on FirebaseException catch (e) {
      final message = e.message ?? '';

      throw HttpException(message);
    } catch (e) {
      final message = e.toString();

      throw HttpException(message);
    }
  }

  @override
  Future<void> updateUser(UserModel payload) async {
    try {
      await _userDataCollectionReference
          .doc(payload.id)
          .update(payload.toJson());
    } on FirebaseException catch (e) {
      final message = e.message ?? '';

      throw HttpException(message);
    } catch (e) {
      final message = e.toString();

      throw HttpException(message);
    }
  }
}
