import 'package:insuratech_mobile/models/transaction.dart';
import 'package:insuratech_mobile/providers/base_provider.dart';

class TransactionProvider extends BaseProvider<Transaction> {
  TransactionProvider() : super("Transaction");

  @override
  Transaction fromJson(data) {
    // TODO: implement fromJson
    return Transaction.fromJson(data);
  }
}
