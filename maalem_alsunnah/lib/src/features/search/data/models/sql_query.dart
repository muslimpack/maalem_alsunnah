class SqlQuery {
  String query;
  List<Object?> args;

  SqlQuery({this.query = "", List<Object?>? args})
      : args = args ?? List.empty(growable: true);
}
