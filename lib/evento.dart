import 'dart:convert';

// função que converte uma string json (contendo uma lista de eventos) em uma lista de objetos 'evento'
List<Evento> eventoFromJson(String str) =>
    List<Evento>.from(json.decode(str).map((x) => Evento.fromJson(x)));

// classe que representa o modelo de dados para um evento no calendário
class Evento {
  final int id;
  String titulo;
  DateTime dataEvento;

  Evento({
    required this.id,
    required this.titulo,
    required this.dataEvento,
  });

  // construtor factory para criar uma instância de 'evento' a partir de um mapa json
  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
        id: json["id"],
        titulo: json["titulo"],
        // converte a string de data vinda da api para um objeto datetime do dart
        dataEvento: DateTime.parse(json["dataEvento"]),
      );
}