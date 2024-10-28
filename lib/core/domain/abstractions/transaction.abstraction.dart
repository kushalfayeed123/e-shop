import 'package:eshop/core/domain/entities/transaction.entity.dart';

abstract class ITransactionService {
  Future<void> createTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getTransactions();
  Future<TransactionModel> getTransaction(String transactionId);
}
