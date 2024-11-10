import 'package:ethiopical/ethiopical.dart';

void main() {
  final todayEthiopianDate = Ethiopical.today().format("MMM dd yyyy");
  print('Ethiopia Today: $todayEthiopianDate.');
}
