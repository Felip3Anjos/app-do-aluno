import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

class Usuario {
  final int id;
  String nomeUsuario;
  String email;
  final String senha;
  // --- NOVOS CAMPOS ADICIONADOS ---
  String? nomeCompleto;
  String? telefone;

  Usuario({
    required this.id,
    required this.nomeUsuario,
    required this.email,
    required this.senha,
    this.nomeCompleto,
    this.telefone,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: json["id"],
    nomeUsuario: json["nomeUsuario"],
    email: json["email"],
    senha: json["senha"],
    nomeCompleto: json["nomeCompleto"],
    telefone: json["telefone"],
  );

  // Método para converter o objeto para JSON, que será enviado no corpo do pedido de atualização
  Map<String, dynamic> toJson() => {
    "id": id,
    "nomeUsuario": nomeUsuario,
    "email": email,
    "senha": senha,
    "nomeCompleto": nomeCompleto,
    "telefone": telefone,
  };
}
