class Marca {
  int id = 0;
  String? nome;
  bool registroAtivo = true;

  @override
  String toString() {
    return 'ID: $id NOME: $nome REGISTRO: $registroAtivo';
  }

  @override
  bool operator ==(other) {
    return other is Marca && other.id == id;
  }
}
