import 'package:corona_tracker/Model/WorldStatesModel.dart';
import 'package:corona_tracker/Services/states_services.dart';
import 'package:corona_tracker/View/countryListScreen.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({super.key});

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: 3),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final clrList = <Color>[
    const Color(0xff4285f4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .08),
              FutureBuilder(
                future: statesServices.fetchWorldStatesRecords(),
                builder: (context, AsyncSnapshot<WorldStatsModel> snapshot) {
                  if (!snapshot.hasData) {
                    return SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50,
                      controller: _controller,
                    );
                  } else {
                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            "Total": double.parse(
                              snapshot.data!.cases.toString(),
                            ),
                            "Recovered": double.parse(
                              snapshot.data!.recovered.toString(),
                            ),
                            "Deaths": double.parse(
                              snapshot.data!.deaths.toString(),
                            ),
                          },

                          chartValuesOptions: ChartValuesOptions(
                            showChartValuesInPercentage: true,
                          ),
                          
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          
                          legendOptions: LegendOptions(
                            legendPosition: LegendPosition.left,
                          ),
                          
                          chartType: ChartType.ring,
                          colorList: clrList,
                          animationDuration: Duration(milliseconds: 1200),
                        ),
                        
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * .06,
                          ),
                          child: Card(
                            child: Column(
                              children: [
                                ReusableRow(
                                  title: "Total",
                                  value: snapshot.data!.cases.toString(),
                                ),
                                ReusableRow(
                                  title: "Deaths",
                                  value: snapshot.data!.deaths.toString(),
                                ),
                                ReusableRow(
                                  title: "Recovered",
                                  value: snapshot.data!.recovered.toString(),
                                ),
                                ReusableRow(
                                  title: "Active",
                                  value: snapshot.data!.active.toString(),
                                ),
                                ReusableRow(
                                  title: "Critical",
                                  value: snapshot.data!.critical.toString(),
                                ),
                                ReusableRow(
                                  title: "Tests",
                                  value: snapshot.data!.tests.toString(),
                                ),
                                ReusableRow(
                                  title: "population",
                                  value: snapshot.data!.population.toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CountryListScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 24, 154, 28),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: Text("Track Countries")),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text(value)],
          ),
          SizedBox(height: 5),
          Divider(),
        ],
      ),
    );
  }
}
