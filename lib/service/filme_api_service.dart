import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/filme_api_config.dart';
import '../model/filme.dart';

class FilmeApiService {
  final String _filmesEndpoint = "/filmes";

  Future<List<Filme>> getFilmes() async {
    final response = await http.get(
      Uri.parse(FilmeApiConfig.baseUrl + _filmesEndpoint),
      headers: FilmeApiConfig.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(
        utf8.decode(response.bodyBytes),
      );
      return jsonData.map((jsonMap) => Filme.fromJson(jsonMap)).toList();
    } else {
      throw HttpException(
        "Erro ao buscar filmes: ${response.statusCode} ${response.body}",
      );
    }
  }

  Future<Filme> adicionarFilme(Filme filme) async {
    final response = await http.post(
      Uri.parse(FilmeApiConfig.baseUrl + _filmesEndpoint),
      headers: FilmeApiConfig.headers,
      body: jsonEncode(filme.toJson()),
    );

    if (response.statusCode == 201) {
      return Filme.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw HttpException(
        "Erro ao adicionar filme: ${response.statusCode} ${response.body}",
      );
    }
  }

  Future<Filme> atualizarFilme(Filme filme) async {
    final response = await http.put(
      Uri.parse("${FilmeApiConfig.baseUrl}$_filmesEndpoint/${filme.id}"),
      headers: FilmeApiConfig.headers,
      body: jsonEncode(filme.toJson()),
    );

    if (response.statusCode == 200) {
      return Filme.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw HttpException(
        "Erro ao atualizar filme: ${response.statusCode} ${response.body}",
      );
    }
  }

  Future<void> deletarFilme(int id) async {
    final response = await http.delete(
      Uri.parse("${FilmeApiConfig.baseUrl}$_filmesEndpoint/$id"),
      headers: FilmeApiConfig.headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw HttpException(
        "Erro ao deletar filme: ${response.statusCode} ${response.body}",
      );
    }
  }
}
