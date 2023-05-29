class TContactModel {
  int? _id;
  String? _number;
  String? _name;

  TContactModel(this._number, this._name);
  TContactModel.withId(this._id, this._number, this._name);

  // getter
  int get id => _id!;
  String get number => _number!;
  String get name => _name!;

  @override
  String toString() {
    return 'Contact: {id: $_id, name: $_name, number: $_number}';
  }

  // setter
  set number(String newNumber) => this._number = newNumber;
  set name(String newName) => this._name = newName;

  // convert a Contact object to a map object
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['id'] = this._id;
    map['number'] = this._number;
    map['name'] = this._name;

    return map;
  }

  TContactModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._number = map['number'];
    this._name = map['name'];
  }

}