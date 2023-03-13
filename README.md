# flutter_expense_tracker

## 主要程式碼架構

- transaction_list.dart 顯示所有消費紀錄的列表
- transaction_list.dart 單個消費紀錄架構(金額、項目名稱、消費日期、刪除該消費紀錄的圖標按鈕)
- new_transaction.dart 新增消費紀錄的彈窗內容(項目名稱輸入框、金額輸入框、日期選擇棄、新增消費紀錄按鈕)
- chart.dart 顯示近七天的消費圖表
- chart_bar.dart 近七天中單一天的消費圖表架構(當天總金額、佔這七天內多少比例的進度條、週幾)
- adaptive_button.dart 根據系統為 IOS 或 Android 顯示不同的自適應按鈕小部件

## 程式碼重點說明

- 在 build 這種擁有 context 的地方可通過 MediaQuery.of(context).size.height、MediaQuery.of(context).size.width 取得設備的螢幕高、寬度
- 如需判斷設備為 IOS 或 Android 系統，可用 dart 內建的 io 實現，需注意 import 時必須放置在檔案最優先的順序(`import 'dart:io';`)
- 開啟從下往上的彈窗方式

```dart
void _startAddNewTx(BuildContext ctx) { // 將該函數綁定給按鈕即可使用
  showModalBottomSheet( // 顯示下往上的彈窗
    context: ctx, // 傳入 build 的 context
    isScrollControlled: true, // 彈窗是否全屏
    builder: (bctx) {
      return SingleChildScrollView( // 新增可滾動區域小部件
        child: NewTransaction(_addNewTransaction), // 新增消費紀錄的表單彈窗內容小部件
      );
    },
  );
}
```

- 日期格式化可用第三方 `intl` 實現(需先在 pubspec.yaml 檔案中的 dependencies 新增 `intl: ^0.15.8`，並執行終端機指令 `flutter packages get` 安裝依賴)
  - 日期格式化的語言可在 main.dart 中的入口函數設定：
  ```dart
  void main() {
    initializeDateFormatting('zh_TW', null).then(
      (_) => runApp(MyApp()),
    );
  }
  ```
  - 日期格式化使用方式：
  ```dart
  DateFormat('yMMMEd', 'zh_TW').format(widget.transaction.date) // 顯示結果為 『2023年3月13日 週一』
  ```
- 刪除紀錄時，可通過 key 來維持當前的其他資料(比如隨機的背景色)，否則會重新渲染與建立小部件

```dart
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
          key: ValueKey(tx.id), // 設定 key 值為 tx.id
        );
      }).toList(),
    );
  }
}
```

- 日期選擇器顯示方式

```dart
showDatePicker( // 顯示日期選擇器
  context: context, // build 中的 context
  initialDate: _selectedDate == null ? DateTime.now() : _selectedDate, // 預設選中的日期，如果當前沒選過日期則預設為今天
  firstDate: DateTime(2000), // 可選的最早日期為 2000年1月1日
  lastDate: DateTime.now(), // 可選的最後一天是今天
).then((value) {
  if (value == null) {
    return;
  }
  setState(() {
    _selectedDate = value; // 設定選中的日期是哪天
  });
});
```

- 文字輸入框建立方式

```dart
TextField(
  decoration: const InputDecoration(labelText: '項目'), // 設置 label
  controller: _titleController, // _titleController 為 TextEditingController()
  onSubmitted: (_) => _submitData(), // 表單送出時執行的函數
),
```

- 乘上，表單執行的函數以及 TextEditingController() 的用途

```dart
final _titleController = TextEditingController(); // 設置任一個參數名稱為 TextEditingController
final _totalController = TextEditingController(); // 設置任一個參數名稱為 TextEditingController
DateTime _selectedDate; // 設置一個參數存放選中的日期

void _submitData() {
  final etTitle = _titleController.text; // 獲取 _titleController 輸入框的內容
  final etTotal = int.parse(_totalController.text);  // 獲取 _totalController 輸入框的內容並用 int.parse 將問轉為數字類型

  if (etTitle.isEmpty || etTotal <= 0 || _selectedDate == null) { // 判斷項目是否有缺漏，如有則取消送出
    return;
  }

  widget.addTx(etTitle, etTotal, _selectedDate); // 新增一筆消費紀錄到資料中

  Navigator.of(context).pop(); // 關閉新增紀錄用的表單彈窗
}
```
