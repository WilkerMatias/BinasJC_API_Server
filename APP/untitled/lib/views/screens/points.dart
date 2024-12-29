import 'package:flutter/material.dart';

class PointsWidget extends StatefulWidget {
  const PointsWidget({super.key});

  @override
  _PointsWidgetState createState() => _PointsWidgetState();
}

class _PointsWidgetState extends State<PointsWidget> {
  int availablePoints = 1200; // Exemplo de pontos disponíveis

  void _redeemPoints(int points) {
    if (availablePoints >= points) {
      setState(() {
        availablePoints -= points; // Reduz os pontos disponíveis
      });
      // Exibe uma mensagem de sucesso
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Troca de Prêmio'),
          content: const Text('Prêmio trocado com sucesso!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        ),
      );
    } else {
      // Exibe uma mensagem de erro se os pontos não forem suficientes
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Você não tem pontos suficientes para trocar por este prêmio.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pontos: $availablePoints',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Histórico de Pontos'),
                        content: const Text('Histórico de envio e recebimento de pontos...'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Fechar'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Ver Histórico'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                PrizeItem(prize: 'Desconto em Loja', points: 200, onRedeem: _redeemPoints),
                PrizeItem(prize: 'Café Grátis', points: 100, onRedeem: _redeemPoints),
                PrizeItem(prize: 'Acessório para Bicicleta', points: 500, onRedeem: _redeemPoints),
                PrizeItem(prize: 'Vale-Presente', points: 300, onRedeem: _redeemPoints),
                PrizeItem(prize: 'Entrada para Evento', points: 400, onRedeem: _redeemPoints),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PrizeItem extends StatelessWidget {
  final String prize;
  final int points;
  final Function(int) onRedeem; // Função para lidar com a troca

  const PrizeItem({super.key, required this.prize, required this.points, required this.onRedeem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(prize),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$points pontos'),
            IconButton(
              icon: const Icon(Icons.redeem),
              onPressed: () => onRedeem(points), // Chama a função para trocar pontos
            ),
          ],
        ),
      ),
    );
  }
}
