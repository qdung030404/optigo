class BookingModel {
  final int? id;
  final String tripId;
  final String passengerId;
  final String? pickupLocation;
  final String? dropOffLocation;
  final double? pickupLat;
  final double? pickupLng;
  final double? dropOffLat;
  final double? dropOffLng;
  final int numberOfPassengers;
  final int? totalFare;
  final String? paymentMethod;
  final String? note;
  final String status;
  final String? passengerName;
  final String? passengerPhone;
  final double? distance;
  final String? duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BookingModel({
    this.id,
    required this.tripId,
    required this.passengerId,
    this.pickupLocation,
    this.dropOffLocation,
    this.pickupLat,
    this.pickupLng,
    this.dropOffLat,
    this.dropOffLng,
    this.numberOfPassengers = 1,
    this.totalFare,
    this.paymentMethod = 'cash',
    this.note,
    this.status = 'pending',
    this.passengerName,
    this.passengerPhone,
    required this.distance,
    required this.duration,
    this.createdAt,
    this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] as int?,
      tripId: map['trip_id'] ?? '',
      passengerId: map['passenger_id'] ?? '',
      pickupLocation: map['pickup_location'],
      dropOffLocation: map['drop_off_location'],
      pickupLat: (map['pickup_lat'] as num?)?.toDouble(),
      pickupLng: (map['pickup_lng'] as num?)?.toDouble(),
      dropOffLat: (map['drop_off_lat'] as num?)?.toDouble(),
      dropOffLng: (map['drop_off_lng'] as num?)?.toDouble(),
      numberOfPassengers: map['number_of_passengers'] ?? 1,
      totalFare: (map['total_fare'] as num?)?.toInt() ?? 0,
      paymentMethod: map['payment_method'] ?? 'cash',
      note: map['note'],
      status: map['status'] ?? 'pending',
      passengerName: map['passenger_name'],
      passengerPhone: map['passenger_phone'],
      distance: (map['distance'] as num?)?.toDouble() ?? 0.0,
      duration: map['duration'] ?? '',
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'trip_id': tripId,
      'passenger_id': passengerId,
      if (pickupLocation != null) 'pickup_location': pickupLocation,
      if (dropOffLocation != null) 'drop_off_location': dropOffLocation,
      if (pickupLat != null) 'pickup_lat': pickupLat,
      if (pickupLng != null) 'pickup_lng': pickupLng,
      if (dropOffLat != null) 'drop_off_lat': dropOffLat,
      if (dropOffLng != null) 'drop_off_lng': dropOffLng,
      'number_of_passengers': numberOfPassengers,
      if (totalFare != null) 'total_fare': totalFare,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (note != null) 'note': note,
      'status': status,
      if (passengerName != null) 'passenger_name': passengerName,
      if (passengerPhone != null) 'passenger_phone': passengerPhone,
      if (distance != null) 'distance': distance,
      if (duration != null) 'duration': duration,
      if (createdAt != null) 'created_at': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt?.toIso8601String(),
    };
  }

  BookingModel copyWith({
    int? id,
    String? tripId,
    String? passengerId,
    String? pickupLocation,
    String? dropOffLocation,
    double? pickupLat,
    double? pickupLng,
    double? dropOffLat,
    double? dropOffLng,
    int? numberOfPassengers,
    int? totalFare,
    String? paymentMethod,
    String? note,
    String? status,
    String? passengerName,
    String? passengerPhone,
    double? distance,
    String? duration,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      passengerId: passengerId ?? this.passengerId,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropOffLocation: dropOffLocation ?? this.dropOffLocation,
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      dropOffLat: dropOffLat ?? this.dropOffLat,
      dropOffLng: dropOffLng ?? this.dropOffLng,
      numberOfPassengers: numberOfPassengers ?? this.numberOfPassengers,
      totalFare: totalFare ?? this.totalFare,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
      status: status ?? this.status,
      passengerName: passengerName ?? this.passengerName,
      passengerPhone: passengerPhone ?? this.passengerPhone,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
