import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop/core/domain/abstractions/transaction.abstraction.dart';
import 'package:eshop/core/domain/entities/transaction.entity.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionService implements ITransactionService {
  final CollectionReference<Map<String, dynamic>>
      _transactionDataCollectionReference =
      FirebaseFirestore.instance.collection("transactions");

  @override
  Future<void> createTransaction(
      TransactionModel transaction, List<String> tokens) async {
    try {
      if (tokens.isNotEmpty) {
        for (var token in tokens) {
          await sendNotification(
              token,
              'You have a new order with status: ${transaction.status}. click to view new orders',
              'New Order for Vibes Wine');
        }
      }
      await _transactionDataCollectionReference.add(transaction.toJson());
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
      final res = snapshots.docs
          .map((e) => TransactionModel.fromJson(e.data(), e.id))
          .toList();
      res.sort((a, b) => DateTime.parse(b.transactionDate ?? '')
          .compareTo(DateTime.parse(a.transactionDate ?? '')));
      return res;
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

  Future<void> sendNotification(
      String token, String message, String title) async {
    const String url =
        'https://eshop-push-service.onrender.com/send-notification';
    const Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> payload = <String, dynamic>{
      "registrationToken": token,
      "message": {
        "title": title,
        "body": message,
      }
    };

    try {
      await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
