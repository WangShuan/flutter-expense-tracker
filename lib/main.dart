import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('zh_TW', null).then(
    (_) => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '記帳小應用程序',
      home: MyHomePage(),
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primarySwatch: Colors.indigo,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTxs {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, int amount, DateTime d) {
    final newTx = Transaction(
      amount: amount,
      id: DateTime.now().toString(),
      date: d,
      title: title,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTx(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (bctx) {
        return SingleChildScrollView(
          child: NewTransaction(_addNewTransaction),
        );
      },
    );
  }

  void _deleteTx(String id) {
    setState(() {
      _userTransactions.removeWhere((e) => e.id == id);
    });
  }

  bool _showChart = false;

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar, Widget txWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '切換顯示圖表',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).primaryColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTxs),
            )
          : txWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar, Widget txWidget) {
    return [
      Container(
        margin: const EdgeInsets.only(top: 10),
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTxs),
      ),
      txWidget
    ];
  }

  PreferredSizeWidget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(
              '記帳小應用程序',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: CupertinoColors.systemIndigo,
                // color: CupertinoTheme.of(context).primaryContrastingColor
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    _startAddNewTx(context);
                  },
                  child: const Icon(
                    CupertinoIcons.add,
                    size: 20,
                    // color:
                    //     CupertinoTheme.of(context).primaryContrastingColor
                  ),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text(
              '記帳小應用程序',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    _startAddNewTx(context);
                  },
                  icon: const Icon(Icons.add_circle))
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBar();
    final txWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTx));
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txWidget),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, appBar, txWidget)
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      _startAddNewTx(context);
                    },
                    child: const Icon(Icons.add),
                  ),
          );
  }
}
