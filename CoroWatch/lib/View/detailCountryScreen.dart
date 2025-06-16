import 'package:corona_tracker/View/world_states.dart';
import 'package:flutter/material.dart';

class Detailcountryscreen extends StatefulWidget {
  String image;
  String name;
  int totalCases,
      totalDeaths,
      totalRecovered,
      active,
      critical,
      todayRecovered,
      test;

  Detailcountryscreen({
    super.key,
    required this.image,
    required this.name,
    required this.active,
    required this.critical,
    required this.test,
    required this.todayRecovered,
    required this.totalCases,
    required this.totalDeaths,
    required this.totalRecovered,
  });

  @override
  State<Detailcountryscreen> createState() => _DetailcountryscreenState();
}

class _DetailcountryscreenState extends State<Detailcountryscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(widget.name), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: MediaQuery.of(context).size.height * .067,
                ),
                child: Card(
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                      ReusableRow(title: 'Country', value: widget.name),
                      ReusableRow(
                        title: 'Total Cases',
                        value: widget.totalCases.toString(),
                      ),
                      ReusableRow(
                        title: 'Total Deaths',
                        value: widget.totalDeaths.toString(),
                      ),
                      ReusableRow(
                        title: 'Total Recovered',
                        value: widget.totalRecovered.toString(),
                      ),
                      ReusableRow(
                        title: 'Active Cases',
                        value: widget.active.toString(),
                      ),
                      ReusableRow(
                        title: 'Critical Cases',
                        value: widget.critical.toString(),
                      ),
                      ReusableRow(
                        title: 'Today Recovered',
                        value: widget.todayRecovered.toString(),
                      ),
                      ReusableRow(
                        title: 'Total Tests',
                        value: widget.test.toString(),
                      ),
                    ],
                  ),
                ),
              ),
              CircleAvatar(radius: 50, backgroundImage: NetworkImage(widget.image)),
            ],
          ),
        ],
      ),
    );
  }
}
