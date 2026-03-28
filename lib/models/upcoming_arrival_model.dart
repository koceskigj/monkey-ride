class UpcomingArrivalModel {
  final String routeId;
  final String stopId;
  final String lineId;
  final int minutesUntilArrival;

  const UpcomingArrivalModel({
    required this.routeId,
    required this.stopId,
    required this.lineId,
    required this.minutesUntilArrival,
  });
}