import 'dart:math';

class MyLocationsFunctions {
  // Masofani hisoblash funksiyasi (Haversine formulasi)
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6378137;
    double dLat = _degreeToRadian(lat2 - lat1);
    double dLon = _degreeToRadian(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreeToRadian(lat1)) * cos(_degreeToRadian(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  static double _degreeToRadian(double degree) {
    return degree * pi / 180;
  }

  static double calculateAngle(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {
    // Vektorlarni hisoblash
    double abX = x2 - x1;
    double abY = y2 - y1;
    double bcX = x3 - x2;
    double bcY = y3 - y2;

    // Vektor uzunliklari
    double abLength = sqrt(abX * abX + abY * abY);
    double bcLength = sqrt(bcX * bcX + bcY * bcY);

    // Skalyar ko'paytma orqali cos(theta) hisoblash
    double dotProduct = abX * bcX + abY * bcY;
    double cosTheta = dotProduct / (abLength * bcLength);

    // Gradusga o‘tkazish
    double angleRadians = acos(cosTheta.clamp(-1.0, 1.0));
    double angleDegrees = angleRadians * (180 / pi);

    return angleDegrees;
  }

  /// Nuqtalarni optimallashtirish algoritmi
  static List<Map<String, dynamic>> optimizeLocations(List<Map<String, dynamic>> points) {
    if (points.length < 3) return points; // 3 tadan kam nuqta bo'lsa qaytarish

    List<Map<String, dynamic>> optimized = [points.first]; // Birinchi nuqta saqlanadi

    for (int i = 1; i < points.length - 1; i++) {
      dynamic angle = calculateAngle(
        points[i - 1]['latitude']!,
        points[i - 1]['longitude']!,
        points[i]['latitude']!,
        points[i]['longitude']!,
        points[i + 1]['latitude']!,
        points[i + 1]['longitude']!,
      );

      // Burilish burchagi 15 gradusdan katta bo'lsa, o‘rtadagi nuqta saqlanadi
      if (angle >= 15) {
        optimized.add(points[i]);
      }
    }

    optimized.add(points.last); // Oxirgi nuqta saqlanadi
    return optimized;
  }
}
