import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop/core/domain/abstractions/transaction.abstraction.dart';
import 'package:eshop/core/domain/entities/transaction.entity.dart';

class TransactionService implements ITransactionService {
  final CollectionReference<Map<String, dynamic>>
      _transactionDataCollectionReference =
      FirebaseFirestore.instance.collection("transactions");

  @override
  Future<void> createTransaction(TransactionModel transaction) async {
    try {
      await _transactionDataCollectionReference
          .doc(transaction.id)
          .set(transaction.toJson());
    } on FirebaseException catch (e) {
      final message = e.message ?? '';

      throw HttpException(message);
    } catch (e) {
      final message = e.toString();

      throw HttpException(message);
    }
  }

  @override
  Future<TransactionModel> getTransaction(String transactionId) async {
    try {
      final snapshot =
          await _transactionDataCollectionReference.doc(transactionId).get();
      return snapshot.exists
          ? TransactionModel.fromJson(snapshot.data()!, snapshot.id)
          : throw const HttpException('Transaction not found');
    } on FirebaseException catch (e) {
      final message = e.message ?? '';

      throw HttpException(message);
    } catch (e) {
      final message = e.toString();

      throw HttpException(message);
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final snapshots = await _transactionDataCollectionReference.get();
      return snapshots.docs
          .map((e) => TransactionModel.fromJson(e.data(), e.id))
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
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _transactionDataCollectionReference
          .doc(transaction.id)
          .update(transaction.toJson());
    } on FirebaseException catch (e) {
      final message = e.message ?? '';

      throw HttpException(message);
    } catch (e) {
      final message = e.toString();

      throw HttpException(message);
    }
  }
}
