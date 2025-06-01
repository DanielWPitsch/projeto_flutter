import '../model/filme.dart';
import '../service/filme_service.dart';

class FilmeController{

  final _service = FilmeService();
  //instancia de filme_service onde tem a lista de todos os filmes

  List<Filme> getFilmes(){
    return _service.filmes; //manda a lista pelo controller
  }

  void adicionar(int id, String titulo, String urlImagem, String genero, String faixaEtaria,
      Duration duracao, double nota, String descricao, int ano){
    _service.adicionar(Filme(id: id, titulo: titulo, url_imagem: urlImagem, genero: genero,
      faixa_etaria: faixaEtaria, duracao: duracao, nota: nota, descricao: descricao, ano: ano));
  }

  void atualizar(Filme filmeAtualizado) {
    _service.atualizar(filmeAtualizado);
  }

  void deletarFilme(Filme filme) => _service.deletarFilme(filme);
}