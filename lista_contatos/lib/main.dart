import 'package:flutter/material.dart';

class Contato {
  final String nome;
  final String telefone;
  final String imagem;

  const Contato({
    required this.nome,
    required this.telefone,
    required this.imagem,
  });
}

void main() {
  runApp(const MeuApp());
}

final contatos = [
  const Contato(
    nome: 'Ana Souza',
    telefone: '(31) 99999-1111',
    imagem: 'assets/images/ana.png',
  ),
  const Contato(
    nome: 'Bruno Lima',
    telefone: '(31) 99999-2222',
    imagem: 'assets/images/bruno.png',
  ),
  const Contato(
    nome: 'Carla Mendes',
    telefone: '(31) 99999-3333',
    imagem: 'assets/images/carla.png',
  ),
  const Contato(
    nome: 'Diego Alves',
    telefone: '(31) 99999-4444',
    imagem: 'assets/images/diego.png',
  ),
  const Contato(
    nome: 'Eduarda Rocha',
    telefone: '(31) 99999-5555',
    imagem: 'assets/images/eduarda.png',
  ),
];

class DetalheContato extends StatelessWidget {
  final Contato contato;
  const DetalheContato({super.key, required this.contato});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(contato.nome)),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(contato.imagem),
              radius: 150,
            ),
            Text(contato.telefone),
          ],
        ),
      ),
    );
  }
}

class ListaContatosPage extends StatelessWidget {
  const ListaContatosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Contatos")),
      body: ListView.builder(
        itemCount: contatos.length,
        itemBuilder: ((context, index) {
          final contato = contatos[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(contato.imagem),
              ),
              title: Text(contato.nome),
              subtitle: Text(contato.telefone),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return DetalheContato(contato: contato);
                    },
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab Desenvolvimento - 5o Periodo - Lista Contatos',
      home: const ListaContatosPage(),
    );
  }
}
