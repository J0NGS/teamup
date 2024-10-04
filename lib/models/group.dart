class Group {
  String id;
  String name;

  Group({
    required this.id,
    required this.name,
  });

  // Método para converter um mapa em um objeto Group
  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  // Método para converter um objeto Group em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
