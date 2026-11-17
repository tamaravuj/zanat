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

const _weekdays = [
  'Ponedeljak',
  'Utorak',
  'Sreda',
  'Četvrtak',
  'Petak',
  'Subota',
  'Nedelja',
];
const _weekdaysAcc = [
  'ponedeljak',
  'utorak',
  'sredu',
  'četvrtak',
  'petak',
  'subotu',
  'nedelju',
];
const _months = [
  'januar',
  'februar',
  'mart',
  'april',
  'maj',
  'jun',
  'jul',
  'avgust',
  'septembar',
  'oktobar',
  'novembar',
  'decembar',
];
const _monthsShort = [
  'JAN',
  'FEB',
  'MAR',
  'APR',
  'MAJ',
  'JUN',
  'JUL',
  'AVG',
  'SEP',
  'OKT',
  'NOV',
  'DEC',
];

String pad2(int n) => n.toString().padLeft(2, '0');
String weekdayName(DateTime d) => _weekdays[d.weekday - 1];
String weekdayAcc(DateTime d) => _weekdaysAcc[d.weekday - 1];
String monthName(DateTime d) => _months[d.month - 1];
String monthNameCap(DateTime d) {
  final m = monthName(d);
  return m[0].toUpperCase() + m.substring(1);
}

String monthShort(DateTime d) => _monthsShort[d.month - 1];
String formatDateLong(DateTime d) =>
    '${weekdayName(d)}, ${d.day}. ${monthName(d)} ${d.year}.';
String formatDateShort(DateTime d) => '${d.day}. ${monthName(d)} ${d.year}.';
String formatTime(DateTime d) => '${pad2(d.hour)}:${pad2(d.minute)}';
String formatMinutes(int m) => '${pad2(m ~/ 60)}:${pad2(m % 60)}';
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

String pluralize(int n, String one, String few, String many) {
  final m10 = n % 10, m100 = n % 100;
  if (m10 == 1 && m100 != 11) return one;
  if (m10 >= 2 && m10 <= 4 && (m100 < 12 || m100 > 14)) return few;
  return many;
}
