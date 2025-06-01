class Filme {
  int id;
  String titulo;
  String url_imagem;
  String genero;
  String faixa_etaria;
  Duration duracao;
  double nota;
  String descricao;
  int ano;

  Filme({
    required this.id,
    required this.titulo,
    required this.url_imagem,
    required this.genero,
    required this.faixa_etaria,
    required this.duracao,
    required this.nota,
    required this.descricao,
    required this.ano,
  });

  factory Filme.fromJson(Map<String, dynamic> json) {
    return Filme(
      id: int.parse(json['id']),
      titulo: json['titulo'],
      url_imagem: json['url_imagem'],
      genero: json['genero'],
      faixa_etaria: json['faixa_etaria'],
      duracao: Duration(minutes: json['duracao_in_minutes'] as int),
      nota: (json['nota'] as num).toDouble(),
      descricao: json['descricao'],
      ano: json['ano'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'url_imagem': url_imagem,
      'genero': genero,
      'faixa_etaria': faixa_etaria,
      'duracao_in_minutes': duracao.inMinutes,
      'nota': nota,
      'descricao': descricao,
      'ano': ano,
    };
  }

  @override
  String toString() {
    return "[ID: $id, Titulo: $titulo]";
  }
}
