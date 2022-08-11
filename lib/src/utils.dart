String formatDate(DateTime rawDate) {
  var date = rawDate.toIso8601String();
  return '${date.substring(0, date.length - 3)}Z';
}
