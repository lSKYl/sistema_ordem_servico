class Marca {
  int _id = 0;
  String? _nome = "";
  bool _registroAtivo = true;

  int get id => this._id;

  set id(int value) => this._id = value;

  get nome => this._nome;

  set nome(value) => this._nome = value;

  get registroAtivo => this._registroAtivo;

  set registroAtivo(value) => this._registroAtivo = value;

  get getId => this.id;

  set setId(id) => this.id = id;

  @override
  String toString() {
    return 'ID: $id NOME: $nome REGISTRO: $registroAtivo';
  }

  @override
  bool operator ==(other) {
    return other is Marca && other.id == id;
  }
}
