class TripModel {
  final String? id;
  final String driverId;
  final String? driverName;
  final String? driverPhone;
  final String? driverLicensePlate;
  final String originName;
  final String destinationName;
  final double originLat;
  final double originLng;
  final double destinationLat;
  final double destinationLng;
  final String routePolyline;
  final double? overlapPercentage;
  final int price;
  final int totalSeats;
  final int availableSeats;
  final DateTime departureTime;
  final String status;

  TripModel({
    this.id,
    required this.driverId,
    this.driverName,
    this.driverPhone,
    this.driverLicensePlate,
    required this.originName,
    required this.destinationName,
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.routePolyline,
    this.overlapPercentage,
    required this.price,
    required this.totalSeats,
    required this.availableSeats,
    required this.departureTime,
    required this.status,
  });

  factory TripModel.fromJson(Map<String, dynamic> map) {

    final profile = map['profiles'] as Map<String, dynamic>?;

    return TripModel(
      id: map['id'],
      driverId: map['driver_id'] ?? '',
      driverName: profile?['user_name'],
      driverPhone: profile?['phone'],
      driverLicensePlate: profile?['license_plate'],
      originName: map['origin_name'] ?? '',
      destinationName: map['destination_name'] ?? '',
      originLat: (map['origin_lat'] as num?)?.toDouble() ?? 0.0,
      originLng: (map['origin_lng'] as num?)?.toDouble() ?? 0.0,
      destinationLat: (map['destination_lat'] as num?)?.toDouble() ?? 0.0,
      destinationLng: (map['destination_lng'] as num?)?.toDouble() ?? 0.0,
      routePolyline: map['route_polyline'] ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      totalSeats: map['total_seats'] ?? 0,
      availableSeats: map['available_seats'] ?? 0,
      departureTime: map['departure_time'] != null
          ? DateTime.parse(map['departure_time'])
          : DateTime.now(),
      status: map['status'] ?? 'open',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driver_id': driverId,
      'origin_name': originName,
      'destination_name': destinationName,
      'origin_lat': originLat,
      'origin_lng': originLng,
      'destination_lat': destinationLat,
      'destination_lng': destinationLng,
      'route_polyline': routePolyline,
      'price': price,
      'total_seats': totalSeats,
      'available_seats': totalSeats,
      'departure_time': departureTime.toIso8601String(),
      'status': status,
    };
  }
}
