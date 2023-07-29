import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Info App',
      home: CountryInfoScreen(),
    );
  }
}

class CountryInfoScreen extends StatefulWidget {
  @override
  _CountryInfoScreenState createState() => _CountryInfoScreenState();
}

class _CountryInfoScreenState extends State<CountryInfoScreen> {
  TextEditingController _countryNameController = TextEditingController();
  List<CountryInfo> _countriesInfo = [];

  Future<void> _fetchCountryInfo(String countryName) async {
    String apiUrl = 'https://restcountries.com/v3/name/$countryName';
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<CountryInfo> countriesInfo = [];

      for (var countryData in data) {
        String name = countryData['name']['official'];
        String capital = countryData['capital'].toString();
        double area = countryData['area'];
        List<String> languages = countryData['languages'].values.toList().cast<String>();

        CountryInfo countryInfo = CountryInfo(name, capital, area, languages);
        countriesInfo.add(countryInfo);
      }

      setState(() {
        _countriesInfo = countriesInfo;
      });
    } else {
      setState(() {
        _countriesInfo = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country Info App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _countryNameController,
              decoration: InputDecoration(
                labelText: 'Enter a country name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String countryName = _countryNameController.text.trim();
              if (countryName.isNotEmpty) {
                _fetchCountryInfo(countryName);
              }
            },
            child: Text('Get Country Info'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _countriesInfo.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Country: ${_countriesInfo[index].name}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Capital: ${_countriesInfo[index].capital}'),
                      Text('Surface Area: ${_countriesInfo[index].area} sq km'),
                      Text('Languages Spoken: ${_countriesInfo[index].languages.join(", ")}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CountryInfo {
  String name;
  String capital;
  double area;
  List<String> languages;

  CountryInfo(this.name, this.capital, this.area, this.languages);
}
