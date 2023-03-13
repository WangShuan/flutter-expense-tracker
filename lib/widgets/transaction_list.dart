import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function delTx;
  TransactionList(this.transactions, this.delTx);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: transactions.map((tx) {
        return TransactionItem(
          transaction: tx,
          delTx: delTx,
          key: ValueKey(tx.id),
        );
      }).toList(),
    );
  }
//   @override
//   Widget build(BuildContext context) {
//     return transactions.isEmpty
//         ? LayoutBuilder(builder: (ctx, constraint) {
//             return Column(
//               children: [
//                 Container(
//                   height: constraint.maxHeight * 0.2,
//                   margin: const EdgeInsets.only(top: 20),
//                   child: Text(
//                     '沒有任何紀錄被新增！',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: constraint.maxHeight * 0.5,
//                   child: Image.asset(
//                     'assets/images/waiting.png',
//                     fit: BoxFit.cover,
//                   ),
//                 )
//               ],
//             );
//           })
//         : ListView(
//             children: transactions
//                 .map((tx) => TransactionItem(
//                       transaction: tx,
//                       delTx: delTx,
//                       key: ValueKey(tx.id),
//                     ))
//                 .toList());
//   }
}
