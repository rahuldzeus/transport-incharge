class Login {
  String markers;
  String maptype;

  User(String markers, String maptype) {
    this.markers = markers;
    this.maptype = maptype;
  }

  Login.fromJson(Map json)
      : markers = json['markers'],
        maptype = json['maptype'];

  Map toJson() {
    return {'markers': markers, 'maptype': maptype};
  }
}
