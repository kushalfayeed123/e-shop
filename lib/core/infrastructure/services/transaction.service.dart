import 'package:eshop/core/domain/abstractions/transaction.abstraction.dart';
import 'package:eshop/core/domain/entities/transaction.entity.dart';

class TransactionService implements ITransactionService {
  @override
  Future<void> createTransaction(Transaction transaction) {
    // TODO: implement createTransaction
    throw UnimplementedError();
  }

  @override
  Future<Transaction> getTransaction(String transactionId) {
    // TODO: implement getTransaction
    throw UnimplementedError();
  }

  @override
  Stream<List<Transaction>> getTransactions() {
    // TODO: implement getTransactions
    throw UnimplementedError();
  }

  @override
  Future<void> updateTransaction(Transaction transaction) {
    // TODO: implement updateTransaction
    throw UnimplementedError();
  }
}
