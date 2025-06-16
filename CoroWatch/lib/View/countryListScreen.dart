import 'package:corona_tracker/Services/states_services.dart';
import 'package:corona_tracker/View/detailCountryScreen.dart';
import 'package:flutter/material.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    StatesServices statesServices = StatesServices();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {});
              },
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                hintText: "Search Country Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: statesServices.countryListApi(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      String name = snapshot.data![index]['country'];
                      var country = snapshot.data![index];

                      // Search bar empty then show all data
                      if (searchController.text.isEmpty) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => Detailcountryscreen(
                                          name: country['country'],
                                          image: country['countryInfo']['flag'],
                                          totalCases: country['cases'],
                                          totalDeaths: country['deaths'],
                                          totalRecovered: country['recovered'],
                                          active: country['active'],
                                          critical: country['critical'],
                                          todayRecovered:
                                              country['todayRecovered'],
                                          test: country['tests'],
                                        ),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(country['country']),
                                subtitle: Text(country['cases'].toString()),
                                leading: Image.network(
                                  country['countryInfo']['flag'],
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                            ),
                          ],
                        );

                        // Filter country
                      } else if (name.toLowerCase().contains(
                        searchController.text.toLowerCase(),
                      )) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => Detailcountryscreen(
                                          name: country['country'],
                                          image: country['countryInfo']['flag'],
                                          totalCases: country['cases'],
                                          totalDeaths: country['deaths'],
                                          totalRecovered: country['recovered'],
                                          active: country['active'],
                                          critical: country['critical'],
                                          todayRecovered:
                                              country['todayRecovered'],
                                          test: country['tests'],
                                        ),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(country['country']),
                                subtitle: Text(country['cases'].toString()),
                                leading: Image.network(
                                  country['countryInfo']['flag'],
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
