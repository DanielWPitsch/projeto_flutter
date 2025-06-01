import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../controller/filme_controller.dart';
import '../model/filme.dart';

class CadastrarFilme extends StatefulWidget {
  final Filme? filme;

  const CadastrarFilme({super.key, this.filme});

  @override
  State<CadastrarFilme> createState() => _CadastrarFilmeState();
}

class _CadastrarFilmeState extends State<CadastrarFilme> {
  final _key = GlobalKey<FormState>();
  final _edtTitulo = TextEditingController();
  final _edtGenero = TextEditingController();
  final _edtDuracaoHoras = TextEditingController();
  final _edtDuracaoMinutos = TextEditingController();
  final _edtDescricao = TextEditingController();
  final _edtAno = TextEditingController();
  final _filmeController = FilmeController();
  final _edtUrlImagem = TextEditingController();
  final List<String> _faixasEtarias = ['Livre', '10', '12', '14', '16', '18'];
  String _faixaEtariaSelecionada = 'Livre';

  double _nota = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.filme != null) {
      _edtTitulo.text = widget.filme!.titulo;
      _edtUrlImagem.text = widget.filme!.url_imagem;
      _edtGenero.text = widget.filme!.genero;

      String faixaEtariaDoFilme =
          widget.filme!.faixa_etaria.replaceAll(' anos', '').trim();
      if (_faixasEtarias.contains(faixaEtariaDoFilme)) {
        _faixaEtariaSelecionada = faixaEtariaDoFilme;
      } else {
        _faixaEtariaSelecionada = 'Livre';
      }

      _edtDuracaoHoras.text = widget.filme!.duracao.inHours.toString();
      _edtDuracaoMinutos.text =
          (widget.filme!.duracao.inMinutes.remainder(60)).toString();
      _nota = widget.filme!.nota;
      _edtDescricao.text = widget.filme!.descricao;
      _edtAno.text = widget.filme!.ano.toString();
    }
  }

  @override
  void dispose() {
    _edtTitulo.dispose();
    _edtUrlImagem.dispose();
    _edtGenero.dispose();
    _edtDuracaoHoras.dispose();
    _edtDuracaoMinutos.dispose();
    _edtDescricao.dispose();
    _edtAno.dispose();
    super.dispose();
  }

  Future<void> _salvarFilme() async {
    if (_key.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final horas = int.tryParse(_edtDuracaoHoras.text) ?? 0;
      final minutos = int.tryParse(_edtDuracaoMinutos.text) ?? 0;

      if (horas == 0 && minutos == 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("A duração total não pode ser zero.")),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final duracao = Duration(hours: horas, minutes: minutos);
      final ano = int.parse(_edtAno.text);
      final faixaEtariaCompleta =
          _faixaEtariaSelecionada == 'Livre'
              ? 'Livre'
              : '$_faixaEtariaSelecionada anos';

      try {
        if (widget.filme == null) {
          await _filmeController.adicionar(
            _edtTitulo.text.trim(),
            _edtUrlImagem.text.trim(),
            _edtGenero.text.trim(),
            faixaEtariaCompleta,
            duracao,
            _nota,
            _edtDescricao.text.trim(),
            ano,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Filme cadastrado com sucesso!")),
            );
          }
        } else {
          final filmeAtualizado = Filme(
            id: widget.filme!.id,
            titulo: _edtTitulo.text.trim(),
            url_imagem: _edtUrlImagem.text.trim(),
            genero: _edtGenero.text.trim(),
            faixa_etaria: faixaEtariaCompleta,
            duracao: duracao,
            nota: _nota,
            descricao: _edtDescricao.text.trim(),
            ano: ano,
          );
          await _filmeController.atualizar(filmeAtualizado);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Filme atualizado com sucesso!")),
            );
          }
        }
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erro ao salvar filme: ${e.toString()}")),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filme == null ? "Cadastrar Filme" : "Editar Filme"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                controller: _edtTitulo,
                decoration: const InputDecoration(
                  labelText: "Título",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.trim().isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _edtUrlImagem,
                decoration: const InputDecoration(
                  labelText: "URL da Imagem",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) return "Campo obrigatório";
                  if (!Uri.tryParse(value.trim())!.isAbsolute)
                    return "URL inválida";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _edtGenero,
                decoration: const InputDecoration(
                  labelText: "Gênero",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.trim().isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Faixa Etária",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _faixaEtariaSelecionada,
                        isExpanded: true,
                        items:
                            _faixasEtarias.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value == 'Livre' ? "Livre" : "$value anos",
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _faixaEtariaSelecionada = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _edtDuracaoHoras,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Duração (Horas)",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return "Obrigatório";
                        if (int.tryParse(value) == null || int.parse(value) < 0)
                          return "Inválido";
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _edtDuracaoMinutos,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Duração (Minutos)",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return "Obrigatório";
                        final min = int.tryParse(value);
                        if (min == null || min < 0 || min > 59)
                          return "Inválido (0-59)";
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Avaliação",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SmoothStarRating(
                      rating: _nota,
                      size: 30,
                      allowHalfRating: true,
                      starCount: 5,
                      color: Colors.amber,
                      borderColor: Colors.amber,
                      spacing: 2.0,
                      onRatingChanged: (rating) {
                        setState(() {
                          _nota = rating;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      _nota == 0
                          ? "Toque nas estrelas para avaliar"
                          : "Nota: $_nota",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _edtDescricao,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.trim().isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _edtAno,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Ano de Lançamento",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) return "Campo obrigatório";
                  final year = int.tryParse(value);
                  if (year == null ||
                      year < 1888 ||
                      year > DateTime.now().year + 5)
                    return "Ano inválido";
                  return null;
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _salvarFilme,
        child:
            _isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.0,
                  ),
                )
                : const Icon(Icons.save),
      ),
    );
  }
}
