import 'package:mvola/src/utils.dart';
import 'package:test/test.dart';

void main() {
  test('Date Formater', () {
    expect(formatDate(DateTime.now()), '');
  });
}