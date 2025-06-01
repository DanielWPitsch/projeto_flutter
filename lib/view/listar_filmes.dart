import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../controller/filme_controller.dart';
import '../model/filme.dart';
import 'cadastrar_filme.dart';

class ListarFilmes extends StatefulWidget {
  const ListarFilmes({super.key});

  @override
  State<ListarFilmes> createState() => _ListarFilmesState();
}

class _ListarFilmesState extends State<ListarFilmes> {
  final _filmesController = FilmeController();
  late Future<List<Filme>> _filmesFuture;

  @override
  void initState() {
    super.initState();
    _loadFilmes();
  }

  void _loadFilmes() {
    setState(() {
      _filmesFuture = _filmesController.getFilmes();
    });
  }

  void _showTeamMembersModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Equipe Heineken",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text("Daniel Warella Pitsch"),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text("Elder de Oliveira Tavares"),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text("Wellington Gadelha de Sousa"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarOpcoes(BuildContext context, Filme filme) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("Ver Detalhes"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/detalhes', arguments: filme);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text("Editar Filme"),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastrarFilme(filme: filme),
                    ),
                  );
                  if (result == true && mounted) {
                    _loadFilmes();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    return "${hours}h ${minutes}m";
  }

  Widget buildItemList(Filme filme) {
    return Dismissible(
      key: Key(filme.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red[700],
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
      ),
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirmar Exclusão"),
              content: Text(
                "Tem certeza que deseja excluir o filme '${filme.titulo}'? Esta ação não poderá ser desfeita.",
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red[700]),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Excluir"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        try {
          await _filmesController.deletarFilme(filme);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${filme.titulo} foi removido.'),
                backgroundColor: Colors.green[600],
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Erro ao remover ${filme.titulo}: ${e.toString()}',
                ),
                backgroundColor: Colors.red[600],
              ),
            );
            _loadFilmes();
          }
        }
      },
      child: InkWell(
        onTap: () => _mostrarOpcoes(context, filme),
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110,
                height: 160,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  child: Image.network(
                    filme.url_imagem,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.movie_creation_outlined,
                            color: Colors.grey[400],
                            size: 40,
                          ),
                        ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filme.titulo,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${filme.genero} • ${filme.ano}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatDuration(filme.duracao),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      RatingBarIndicator(
                        rating: filme.nota,
                        itemBuilder:
                            (context, index) => const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                            ),
                        itemCount: 5,
                        itemSize: 20.0,
                        unratedColor: Colors.amber.withAlpha(100),
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Filmes"),
        actions: [
          IconButton(
            icon: Tooltip(
              message: "Sobre a Equipe",
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue.shade300, width: 1.5),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
            ),
            onPressed: () {
              _showTeamMembersModal(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<Filme>>(
        future: _filmesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[400], size: 50),
                    const SizedBox(height: 10),
                    Text(
                      "Erro ao carregar filmes: ${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text("Tentar Novamente"),
                      onPressed: _loadFilmes,
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final filmes = snapshot.data!;
            if (filmes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.movie_filter_outlined,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Nenhum filme cadastrado ainda.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Toque no '+' para adicionar seu primeiro filme!",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                _loadFilmes();
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: filmes.length,
                itemBuilder: (context, index) {
                  return buildItemList(filmes[index]);
                },
              ),
            );
          } else {
            return const Center(child: Text("Nenhum filme encontrado."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const CadastrarFilme();
              },
            ),
          );
          if (result == true && mounted) {
            _loadFilmes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
