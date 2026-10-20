import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Tarefa {
  final int id;
  final String descricao;
  bool concluida;

  Tarefa({required this.id, required this.descricao, required this.concluida});
}

Future<Database> abrirBanco() async {
  final caminho = join(await getDatabasesPath(), 'tarefas.db');
  return openDatabase(
    caminho,
    version: 1,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE tarefas (id INTEGER PRIMARY KEY AUTOINCREMENT, descricao TEXT, concluida INTEGER)',
      );
    },
  );
}

void main() {
  runApp(const MeuApp());
}

class ListaTarefasPage extends StatefulWidget {
  const ListaTarefasPage({super.key});

  @override
  State<ListaTarefasPage> createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage> {
  List<Tarefa> tarefas = [];

  @override
  void initState() {
    super.initState();
    carregarTarefas();
  }

  Future<void> carregarTarefas() async {
    final db = await abrirBanco();
    final resultado = await db.query('tarefas');

    final lista = <Tarefa>[];
    for (final linha in resultado) {
      lista.add(
        Tarefa(
          id: linha['id'] as int,
          descricao: linha['descricao'] as String,
          concluida: linha['concluida'] == 1,
        ),
      );
    }

    setState(() {
      tarefas = lista;
    });
  }

  Future<void> adicionarTarefa(String descricao) async {
    final db = await abrirBanco();
    await db.insert('tarefas', {'descricao': descricao, 'concluida': 0});
    carregarTarefas();
  }

  Future<void> marcarTarefa(Tarefa tarefa, bool concluida) async {
    final db = await abrirBanco();
    await db.update(
      'tarefas',
      {'concluida': concluida ? 1 : 0},
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
    carregarTarefas();
  }

  Future<void> removerTarefa(Tarefa tarefa) async {
    final db = await abrirBanco();
    await db.delete('tarefas', where: 'id = ?', whereArgs: [tarefa.id]);
    carregarTarefas();
  }

  void abrirDialogNovaTarefa(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova tarefa'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Descrição'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  adicionarTarefa(controller.text);
                }
                Navigator.pop(context);
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefas[index];
          return ListTile(
            leading: Checkbox(
              value: tarefa.concluida,
              onChanged: (valor) => marcarTarefa(tarefa, valor!),
            ),
            title: Text(
              tarefa.descricao,
              style: TextStyle(
                decoration: tarefa.concluida
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => removerTarefa(tarefa),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => abrirDialogNovaTarefa(context),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
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
      title: 'Lab Desenvolvimento - 5o Periodo - Lista Tarefas',
      home: const ListaTarefasPage(),
    );
  }
}
