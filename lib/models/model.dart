abstract class Model {
  final String id;

  Model(this.id);

  Map<String, dynamic> toMap();
  Map<String, dynamic> toUpdateMap();

  @override
  String toString() {
    return toMap().toString();
  }
}
