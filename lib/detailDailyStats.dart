import 'package:flutter/material.dart';
import 'package:covid19/main.dart';

class DetailDailyStats extends StatelessWidget {
  final DailyData dailyData;

  DetailDailyStats({Key key, @required this.dailyData }) : super(key: key);

  Widget _buildCard(BuildContext context, String stat, Color color) {
    return Container(
      padding: EdgeInsets.fromLTRB(10,10,10,0),
      height: 180,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(stat, 
                style: TextStyle(
                  fontSize: 72,
                  height: 0.80,
                  color: color,
                ),
              ),
            ]
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Covid19 stats for " + dailyData.date)
      ),
      body: Container(
        child: ListView(
          children:[
            _buildCard(context, dailyData.confirmed.toString(), Colors.blue),
            Center(
              child: Text("Confirmed",
                style: TextStyle(
                  fontSize: 20,
                  height: 2,
                ),
              ),
            ),
            _buildCard(context, dailyData.deaths.toString(), Colors.red),
            Center(
              child: Text("Deaths",
                style: TextStyle(
                  fontSize: 20,
                  height: 2,
                ),),
            ),
            _buildCard(context, dailyData.recovered.toString(), Colors.green),
            Center(
              child: Text("Recovered",
                style: TextStyle(
                  fontSize: 20,
                  height: 2,
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}