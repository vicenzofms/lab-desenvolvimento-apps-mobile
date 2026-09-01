import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Divisão de Bar',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.lightGreen)),
      home: const Home(title: 'Calculadora de Divisão de Bar'),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class Resultado {
  double _valorTotal = 0.0;
  double _valorPorPessoa = 0.0;
  double _valorGarcom = 0.0;
  Resultado({
    required double valorConta,
    required double porcentagemGarcom,
    required int qntdPessoas,
  }) {
    _valorGarcom = valorConta * (porcentagemGarcom / 100);
    _valorTotal = valorConta + _valorGarcom;
    _valorPorPessoa = _valorTotal / qntdPessoas;
  }

  double get valorTotal => _valorTotal;
  double get valorGarcom => _valorGarcom;
  double get valorPorPessoa => _valorPorPessoa;
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  final _valorContaController = TextEditingController();
  final _porcentagemGarcomController = TextEditingController();
  final _quantidadePessoasController = TextEditingController();

  Resultado? _resultado;

  void _calcular() {
    if (!_formKey.currentState!.validate()) return;
    final pessoas = int.parse(_quantidadePessoasController.text);
    final total = double.parse(_valorContaController.text.replaceAll(',', '.'));
    final porcentagem = double.parse(
      _porcentagemGarcomController.text.replaceAll(',', '.'),
    );
    final res = Resultado(
      valorConta: total,
      porcentagemGarcom: porcentagem,
      qntdPessoas: pessoas,
    );
    setState(() {
      _resultado = res;
    });
  }

  void _resetar() {
    _formKey.currentState?.reset();
    _valorContaController.clear();
    _porcentagemGarcomController.clear();
    _quantidadePessoasController.clear();
    setState(() {
      _resultado = null;
    });
  }

  @override
  void dispose() {
    _valorContaController.dispose();
    _porcentagemGarcomController.dispose();
    _quantidadePessoasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          spacing: 16,
          children: [
            if (_resultado == null) ...[
              const Text('Para calcular, preencha o formulário abaixo:'),
              Form(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    spacing: 16,
                    children: [
                      TextFormField(
                        controller: _quantidadePessoasController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ], // sem letras e sem vírgulas
                        decoration: const InputDecoration(
                          labelText: "Quantidade de Pessoas:",
                        ),
                        validator: (valor) {
                          final numero = int.tryParse(valor ?? "");
                          if (numero == null || numero < 1) {
                            return "Mínimo de 1 pessoa";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _valorContaController,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                        ],
                        decoration: const InputDecoration(
                          labelText: "Valor da Conta:",
                          prefixText: "R\$ ",
                        ),
                        validator: (valor) {
                          final numero = double.tryParse(valor ?? "");
                          if (numero == null || numero < 1) {
                            return "O valor mínimo é R\$1,00";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _porcentagemGarcomController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Porcentagem do Garçom:",
                          suffixText: "%",
                        ),
                        validator: (valor) {
                          final numero = int.tryParse(valor ?? "");
                          if (numero == null || numero < 0) {
                            return "A taxa mínima é 0%";
                          }
                          if (numero > 100) {
                            return "A taxa máxima é 100%";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(onPressed: _calcular, child: Text("Calcular")),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Resultado",
                        style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Valor do garçom: R\$ ${_resultado!.valorGarcom.toStringAsFixed(2)}',
                      ),
                      Text(
                        'Total a pagar: R\$ ${_resultado!.valorTotal.toStringAsFixed(2)}',
                      ),
                      Text(
                        'Valor por pessoa: R\$ ${_resultado!.valorPorPessoa.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _resetar,
                child: const Text("Calcular novamente"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
