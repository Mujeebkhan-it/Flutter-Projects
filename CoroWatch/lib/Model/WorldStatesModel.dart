class WorldStatsModel {
  final int cases;
  final int deaths;
  final int recovered;
  final int active;
  final int critical;
  final int tests;
  final int population;
  final int updated;

  WorldStatsModel({
    required this.cases,
    required this.deaths,
    required this.recovered,
    required this.active,
    required this.critical,
    required this.tests,
    required this.population,
    required this.updated,
  });

  factory WorldStatsModel.fromJson(Map<String, dynamic> json) {
    return WorldStatsModel(
      cases: json['cases'],
      deaths: json['deaths'],
      recovered: json['recovered'],
      active: json['active'],
      critical: json['critical'],
      tests: json['tests'],
      population: json['population'],
      updated: json['updated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cases': cases,
      'deaths': deaths,
      'recovered': recovered,
      'active': active,
      'critical': critical,
      'tests': tests,
      'population': population,
      'updated': updated,
    };
  }
}
