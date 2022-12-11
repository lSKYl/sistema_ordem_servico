class Marca {
  int _id = 0;
  String? _nome = "";
  bool _registroAtivo = true;

  int get id => _id;

  set id(int value) => _id = value;

  get nome => _nome;

  set nome(value) => _nome = value;

  get registroAtivo => _registroAtivo;

  set registroAtivo(value) => _registroAtivo = value;

  get getId => id;

  set setId(id) => id = id;

  @override
  String toString() {
    return 'ID: $id NOME: $nome REGISTRO: $registroAtivo';
  }

  @override
  bool operator ==(other) {
    return other is Marca && other.id == id;
  }
}
