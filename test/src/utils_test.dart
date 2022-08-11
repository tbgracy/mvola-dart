import 'package:mvola/src/utils.dart';
import 'package:test/test.dart';

void main() {
  test('Date Formater', () {
    var dateFormat = RegExp('[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}Z');
    var formatedDate = formatDate(DateTime.now());
    expect(dateFormat.hasMatch(formatedDate), true);
    expect(formatedDate.length, 24);
  });
}
