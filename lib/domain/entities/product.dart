import 'package:isar/isar.dart';

part 'product.g.dart';

@Collection()
class Product {
  Id id = Isar.autoIncrement;

  late String name;
  late double quantity;
  late double price;
  late String? barcode;
}
