import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.delTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function delTx;
  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  var _bgColor;
  @override
  void initState() {
    const colors = [Colors.amber, Colors.pink, Colors.indigo, Colors.purple];
    _bgColor = colors[Random().nextInt(colors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
              child: Text(
                '\$${widget.transaction.amount}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey[700],
            fontFamily: 'HachiMaruPop',
          ),
        ),
        subtitle: Text(
          DateFormat('yMMMEd', 'zh_TW').format(widget.transaction.date),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () => widget.delTx(widget.transaction.id),
        ),
      ),
    );
  }
}
