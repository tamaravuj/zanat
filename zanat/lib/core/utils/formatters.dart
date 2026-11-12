String formatPrice(int value) {
  final s = value.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return '$b RSD';
}

String formatRating(double v) => v.toStringAsFixed(1).replaceAll('.', ',');

String formatDistance(double km) =>
    '${km.toStringAsFixed(1).replaceAll('.', ',')} km';

String initials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  return parts.take(2).map((p) => p[0].toUpperCase()).join();
}

String timeAgo(DateTime d) {
  final days = DateTime.now().difference(d).inDays;
  if (days < 1) return 'danas';
  if (days == 1) return 'juče';
  if (days < 7) return 'pre $days dana';
  final w = days ~/ 7;
  return w == 1 ? 'pre 1 nedelju' : 'pre $w nedelje';
}
