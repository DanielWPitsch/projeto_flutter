import '../model/filme.dart';
import '../service/filme_api_service.dart';

class FilmeController {
  final _apiService = FilmeApiService();

  Future<List<Filme>> getFilmes() async {
    return await _apiService.getFilmes();
  }

  Future<Filme> adicionar(
    String titulo,
    String urlImagem,
    String genero,
    String faixaEtaria,
    Duration duracao,
    double nota,
    String descricao,
    int ano,
  ) async {
    Filme novoFilme = Filme(
      id: 0,
      titulo: titulo,
      url_imagem: urlImagem,
      genero: genero,
      faixa_etaria: faixaEtaria,
      duracao: duracao,
      nota: nota,
      descricao: descricao,
      ano: ano,
    );
    return await _apiService.adicionarFilme(novoFilme);
  }

  Future<Filme> atualizar(Filme filmeAtualizado) async {
    return await _apiService.atualizarFilme(filmeAtualizado);
  }

  Future<void> deletarFilme(Filme filme) async {
    await _apiService.deletarFilme(filme.id);
  }
}
