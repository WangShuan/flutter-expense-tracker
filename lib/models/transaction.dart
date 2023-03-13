import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final String title;
  final int amount;
  final DateTime date;

  const Transaction({
    @required this.amount,
    @required this.id,
    @required this.date,
    @required this.title,
  });
}
