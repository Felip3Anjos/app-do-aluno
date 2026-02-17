import 'dart:convert';

// Função para ajudar a converter uma string JSON numa lista de Tarefas
List<Tarefa> tarefaFromJson(String str) =>
    List<Tarefa>.from(json.decode(str).map((x) => Tarefa.fromJson(x)));

// --- FUNÇÃO ADICIONADA ---
// Função para ajudar a converter uma string JSON numa lista de Subtarefas
List<Subtarefa> subtarefaFromJson(String str) =>
    List<Subtarefa>.from(json.decode(str).map((x) => Subtarefa.fromJson(x)));
// --- FIM DA FUNÇÃO ADICIONADA ---

class Tarefa {
  final int id;
  String titulo;
  String concluida; 
  List<Subtarefa> subtarefas;

  bool get isCompleted => concluida == 'true';

  Tarefa({
    required this.id,
    required this.titulo,
    this.concluida = 'false',
    List<Subtarefa>? subtarefas,
  }) : this.subtarefas = subtarefas ?? [];

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    var subtarefasList = json['subtarefas'] as List? ?? [];
    List<Subtarefa> _subtarefas =
        subtarefasList.map((i) => Subtarefa.fromJson(i)).toList();

    return Tarefa(
      id: json["id"],
      titulo: json["titulo"],
      concluida: json["concluida"],
      subtarefas: _subtarefas,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'concluida': concluida,
      'subtarefas': subtarefas.map((sub) => sub.toJson()).toList(),
    };
  }
}

class Subtarefa {
  final int id;
  String titulo;
  String concluida;

  bool get isCompleted => concluida == 'true';

  Subtarefa({
    required this.id,
    required this.titulo,
    this.concluida = 'false',
  });

  factory Subtarefa.fromJson(Map<String, dynamic> json) => Subtarefa(
        id: json["id"],
        titulo: json["titulo"],
        concluida: json["concluida"],
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'concluida': concluida,
    };
  }
}