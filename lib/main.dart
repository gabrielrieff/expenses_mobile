// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors_in_immutables, deprecated_member_use, prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/transaction_list.dart';
import 'models/transaction.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();

    return MaterialApp(
      home: MyHomePage(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        textTheme: tema.textTheme.copyWith(
          headline6: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          button: TextStyle(
            color: Colors.white,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  late bool _showChart = false;

  List<Transaction> get _recentTransaction {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(
            onSubmit: _addTransaction,
          );
        });
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: fn,
            child: Icon(icon),
          )
        : IconButton(
            onPressed: fn,
            icon: Icon(icon),
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final actions = <Widget>[
      if (isLandscape)
        _getIconButton(
          _showChart
              ? Platform.isIOS
                  ? CupertinoIcons.list_bullet
                  : Icons.list_rounded
              : Platform.isIOS
                  ? CupertinoIcons.chart_bar_alt_fill
                  : Icons.bar_chart_rounded,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModal(context),
      )
    ];

    final PreferredSizeWidget appBar = AppBar(
      title: const Text("Despesas pessoais"),
      actions: actions,
    );

    final avaibleHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final pageHome = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // ignore: sized_box_for_whitespace
          if (_showChart || !isLandscape)
            SizedBox(
              height: avaibleHeight * (isLandscape ? 0.8 : 0.3),
              child: Chart(_recentTransaction),
            ),
          if (!_showChart || !isLandscape)
            SizedBox(
              height: avaibleHeight * (isLandscape ? 1 : 0.7),
              child: TransactionList(_transactions, _removeTransaction),
            ),
        ],
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text("Despesas pessoais"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
            child: pageHome,
          )
        : Scaffold(
            appBar: appBar,
            body: pageHome,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _openTransactionFormModal(context),
                    child: const Icon(Icons.add),
                  ),
            floatingActionButtonLocation: isLandscape
                ? FloatingActionButtonLocation.endFloat
                : FloatingActionButtonLocation.centerFloat,
          );
  }
}
