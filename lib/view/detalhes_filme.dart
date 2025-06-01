import 'package:flutter/material.dart';
import '../model/filme.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class DetalhesFilme extends StatelessWidget {
  final Filme filme;

  const DetalhesFilme({super.key, required this.filme});

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    return "$hours h $minutes m";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filme.titulo),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              filme.url_imagem,
              width: double.infinity,
              height: 550,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    filme.titulo,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${filme.genero} • ${filme.ano} • ${filme.faixa_etaria}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Duração: ${formatDuration(filme.duracao)}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  IgnorePointer(
                    child: SmoothStarRating(
                      rating: filme.nota,
                      size: 24,
                      color: Colors.amber,
                      borderColor: Colors.amber,
                      starCount: 5,
                      allowHalfRating: true,
                      spacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Descrição",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    filme.descricao,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
