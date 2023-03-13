import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './adaptive_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _totalController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    final etTitle = _titleController.text;
    final etTotal = int.parse(_totalController.text);

    if (etTitle.isEmpty || etTotal <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(etTitle, etTotal, _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate == null ? DateTime.now() : _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: 10 + mediaQuery.viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: '項目'),
              controller: _titleController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: '金額'),
              controller: _totalController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(_selectedDate == null
                        ? '尚未選擇日期'
                        : '日期: ${DateFormat('yMMMEd', 'zh_TW').format(_selectedDate)}'),
                  ),
                  AdaptiveButton('選擇日期', _presentDatePicker)
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text('新增紀錄'),
            )
          ],
        ),
      ),
    );
  }
}
