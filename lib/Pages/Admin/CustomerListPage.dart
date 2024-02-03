import 'package:flutter/material.dart';
class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  //======================================PAGINATION VARIABLE===================
  int page = 1;
  final int limit = 6;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
