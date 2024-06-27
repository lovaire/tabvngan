import 'package:flutter/material.dart';
import '../services/savings_service.dart';
import '../models/savings.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SavingsService _savingsService = SavingsService();
  List<Savings> _savingsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavings();
  }

  void _loadSavings() async {
    try {
      final savingsList = await _savingsService.getSavings();
      setState(() {
        _savingsList = savingsList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load savings')),
      );
    }
  }

  void _refreshSavings() {
    setState(() {
      _isLoading = true;
    });
    _loadSavings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Savings'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshSavings,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add_savings').then((_) {
                _refreshSavings();
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _savingsList.isEmpty
              ? Center(child: Text('No savings yet'))
              : ListView.builder(
                  itemCount: _savingsList.length,
                  itemBuilder: (context, index) {
                    final savings = _savingsList[index];
                    return ListTile(
                      leading: savings.imageUrl != null
                          ? Image.network(savings.imageUrl!)
                          : Icon(Icons.image),
                      title: Text(savings.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Target: ${savings.targetAmount}'),
                          Text('Current: ${savings.currentAmount}'),
                        ],
                      ),
                      trailing: CircularProgressIndicator(
                        value: savings.currentAmount / savings.targetAmount,
                      ),
                    );
                  },
                ),
    );
  }
}
