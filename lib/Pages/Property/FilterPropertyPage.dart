import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/StaticMethod.dart';

class FilterPropertyPage extends StatefulWidget {
  const FilterPropertyPage({Key? key}) : super(key: key);

  @override
  State<FilterPropertyPage> createState() => _FilterPropertyPageState();
}

class _FilterPropertyPageState extends State<FilterPropertyPage> {
  double _minVal = 0;
  double _maxVal = 10000000;
  double _startValue = 2.0;
  double _endValue = 100.0;

  int minPrice = 1;
  int maxPrice = 10000000;
  String selectedCity = "";
  String selectedPropertyType = "";
  String selectedPropertyName = "";

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white54,
            title: Text('FILTERS'),
            centerTitle: true,
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RangeSlider(
                    values: RangeValues(_startValue, _endValue),
                    min: _minVal,
                    max: _maxVal,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _startValue = values.start;
                        minPrice = _startValue.toInt();
                        _endValue = values.end;
                        maxPrice = _endValue.toInt();
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('min price: ${minPrice}'),
                        Text('max price: ${maxPrice}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: TextField(
                      onChanged: (value) {
                        selectedPropertyName = value;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'filter by name',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: TextField(
                      onChanged: (value) {
                        selectedPropertyType = value;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'filter by property type',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: TextField(
                      onChanged: (value) {
                        selectedCity = value;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'filter by city',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        StaticMethod.filterProperties(appState,
                            propertyName: selectedPropertyName,
                            selectedCity: selectedCity,
                            selectedPropertyType: selectedPropertyType);
                        Navigator.pop(context);
                      },
                      child: Text('apply filter'))
                ],
              ),
            ),
          ),
        )),
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        });
  }
}
