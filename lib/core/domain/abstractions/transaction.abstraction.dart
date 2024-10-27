import 'package:eshop/core/domain/entities/transaction.entity.dart';

abstract class ITransactionService {
  Future<void> createTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction);
  Stream<List<Transaction>> getTransactions();
  Future<Transaction> getTransaction(String transactionId);
}
