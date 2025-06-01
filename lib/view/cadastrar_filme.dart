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
  final _edtFaixaEtaria = TextEditingController();
  final _edtDuracaoHoras = TextEditingController();
  final _edtDuracaoMinutos = TextEditingController();
  final _edtDescricao = TextEditingController();
  final _edtAno = TextEditingController();
  final _filmeController = FilmeController();
  final _edtUrlImagem = TextEditingController();
  final List<String> _faixasEtarias = ['Livre', '10', '12', '14', '16', '18'];
  String _faixaEtariaSelecionada = 'Livre';

  double _nota = 0;

  @override
  void initState() {
    super.initState();
    if (widget.filme != null) {
      _edtTitulo.text = widget.filme!.titulo;
      _edtUrlImagem.text = widget.filme!.url_imagem;
      _edtGenero.text = widget.filme!.genero;
      
      // Corrigindo a faixa etária para compatibilidade com o Dropdown
      String faixaEtaria = widget.filme!.faixa_etaria;
      if (faixaEtaria.contains('anos')) {
        faixaEtaria = faixaEtaria.replaceAll(' anos', '').trim();
      }
      _faixaEtariaSelecionada = _faixasEtarias.contains(faixaEtaria) 
          ? faixaEtaria 
          : 'Livre';
      
      _edtDuracaoHoras.text = widget.filme!.duracao.inHours.toString();
      _edtDuracaoMinutos.text = (widget.filme!.duracao.inMinutes.remainder(60)).toString();
      _nota = widget.filme!.nota;
      _edtDescricao.text = widget.filme!.descricao;
      _edtAno.text = widget.filme!.ano.toString();
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
                decoration: const InputDecoration(labelText: "Título"),
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _edtUrlImagem,
                decoration: const InputDecoration(labelText: "URL da Imagem"),
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
              ),
              TextFormField(
                controller: _edtGenero,
                decoration: const InputDecoration(labelText: "Gênero"),
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<String>(
                      value: _faixaEtariaSelecionada,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: _faixasEtarias.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text("Classificação: $value"),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _faixaEtariaSelecionada = newValue!;
                        });
                      },
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
                      decoration: const InputDecoration(labelText: "Horas"),
                      validator: (value) => value!.isEmpty ? "Obrigatório" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _edtDuracaoMinutos,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Minutos"),
                      validator: (value) => value!.isEmpty ? "Obrigatório" : null,
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
                    child:SmoothStarRating(
                      rating: _nota,
                      size: 24,
                      allowHalfRating: true,
                      starCount: 5,
                      color: Colors.amber,
                      borderColor: Colors.amber,
                      onRatingChanged: (rating) {
                        setState(() {
                          _nota = rating;
                        });
                      },
                    )
                  ),
                  Text(
                    _nota == 0 ? "Sem avaliação" : "Nota: $_nota",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _edtDescricao,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Descrição"),
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _edtAno,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Ano"),
                validator: (value) {
                  if (value!.isEmpty) return "Campo obrigatório";
                  if (int.tryParse(value) == null) return "Ano inválido";
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_key.currentState!.validate()) {
            try {
              // Validação da nota
              if (_nota < 0 || _nota > 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("A nota deve estar entre 0 e 5"))
                );
                return;
              }

              // Validação da duração
              final horas = int.tryParse(_edtDuracaoHoras.text) ?? 0;
              final minutos = int.tryParse(_edtDuracaoMinutos.text) ?? 0;
              if (horas < 0 || minutos < 0 || (horas == 0 && minutos == 0)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Duração inválida"))
                );
                return;
              }

              // Formatação da faixa etária
              final faixaEtariaCompleta = _faixaEtariaSelecionada == 'Livre' 
                  ? 'Livre' 
                  : '$_faixaEtariaSelecionada anos';

              // Validação do ano
              final ano = int.tryParse(_edtAno.text) ?? 0;
              if (ano < 1888 || ano > DateTime.now().year + 1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Ano inválido"))
                );
                return;
              }

              // Operação de adicionar/editar
              if (widget.filme == null) {
                _filmeController.adicionar(
                  DateTime.now().millisecondsSinceEpoch,
                  _edtTitulo.text.trim(),
                  _edtUrlImagem.text.trim(),
                  _edtGenero.text.trim(),
                  faixaEtariaCompleta,
                  Duration(hours: horas, minutes: minutos),
                  _nota,
                  _edtDescricao.text.trim(),
                  ano,
                );
              } else {
                final filmeAtualizado = Filme(
                  id: widget.filme!.id,
                  titulo: _edtTitulo.text.trim(),
                  url_imagem: _edtUrlImagem.text.trim(),
                  genero: _edtGenero.text.trim(),
                  faixa_etaria: faixaEtariaCompleta,
                  duracao: Duration(hours: horas, minutes: minutos),
                  nota: _nota,
                  descricao: _edtDescricao.text.trim(),
                  ano: ano,
                );
                _filmeController.atualizar(filmeAtualizado);
              }

              // Fecha a tela após sucesso
              if (mounted) {
                Navigator.pop(context);
              }
              
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Erro ao salvar: ${e.toString()}"))
              );
            }
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    _edtTitulo.dispose();
    _edtUrlImagem.dispose();
    _edtGenero.dispose();
    _edtFaixaEtaria.dispose();
    _edtDuracaoHoras.dispose();
    _edtDuracaoMinutos.dispose();
    _edtDescricao.dispose();
    _edtAno.dispose();
    super.dispose();
  }
}