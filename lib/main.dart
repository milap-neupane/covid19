// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'package:covid19/detailDailyStats.dart';

void main() => runApp(CovidData());

Future<CovidStatsData> fetchData() async {
  final response = await http.get('https://pomber.github.io/covid19/timeseries.json');
  if (response.statusCode == 200) {
    return CovidStatsData.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load covid stats');
  }
}

class DailyData {
  final String date;
  final int confirmed;
  final int deaths;
  final int recovered;

  DailyData({this.date, this.confirmed, this.deaths, this.recovered});
}

class CovidStatsData {
  final List<DailyData> nepal;

  CovidStatsData({this.nepal});

  factory CovidStatsData.fromJson(Map<String, dynamic> json) {
    List<DailyData> nepal = json['Nepal'].map<DailyData>( (data) {
      return DailyData(
        date: data["date"],
        confirmed: data["confirmed"],
        deaths: data["deaths"],
        recovered: data["recovered"]
      );
    }).toList();
    nepal.sort((b, a) => a.confirmed.compareTo(b.confirmed));
    return CovidStatsData(
      nepal: nepal,
    );
  }
}

class CovidDataState extends State<CovidData> {
  Future<CovidStatsData> futureData;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Widget _buildRow(BuildContext context, DailyData dailyData, int prevDailyData) {
    int diff = dailyData.confirmed - prevDailyData;
    Color color = Colors.grey;
    if(diff == 0){
      color = Colors.green;
    } else if(diff > 0){
      color = Colors.red;
    }
    return Card(
      child: ListTile(
        leading: Icon(Icons.calendar_today,
          color: color,
          size: 24.0,
        ),
        title: Text(
          dailyData.date,
          style: _biggerFont,
        ),
        trailing: Text(
          dailyData.confirmed.toString(),
          style: _biggerFont,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailDailyStats(dailyData: dailyData)),
          );
        },
      )
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid19 Stats for Nepal',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Covid19',
                style: TextStyle( 
                  color: Colors.white,
                  fontSize: 40,
                )
              ),
              decoration: BoxDecoration(
                  color: Colors.red,
                ),
              ),
              ListTile(
                title: Text('STATS'),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CovidData()),
                  );
                  Navigator.pop(context);
                },
              ),
            ]
          )
        ),
        appBar: AppBar(
          title: Text('Covid19 Stats for Nepal'),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() { futureData = fetchData(); });
              },
            ),
          ]
        ),
        body: Column(
          children: [
            Image(
              image: AssetImage('images/isolation.jpg'),
              fit: BoxFit.cover,
              height: 340,
            ),
            FutureBuilder<CovidStatsData>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 400,
                    child: (
                      ListView.builder(
                        itemCount: snapshot.data.nepal.length,
                        itemBuilder: (context, index) {
                          int prevDailyData;
                          if(index > 1){
                            prevDailyData = snapshot.data.nepal[index-1].confirmed;
                          } else {
                            prevDailyData = 0;
                          }
                          DailyData dailyData = snapshot.data.nepal[index];
                          return _buildRow(context, dailyData, prevDailyData);
                        },
                      )
                    )
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CovidData extends StatefulWidget {
  @override
  CovidDataState createState() => CovidDataState();
}
