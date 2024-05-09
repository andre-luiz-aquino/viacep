import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class BuscarCEP extends StatefulWidget {
  BuscarCEP({super.key});

  @override
  State<BuscarCEP> createState() => _BuscarCEP();
}

class _BuscarCEP extends State<BuscarCEP> {
  TextEditingController _cepController = TextEditingController();

  String _valorRetorno = "";

  void _buscarCep() async {
    String cep = _cepController.text;

    var _urlApi = Uri.parse("https://viacep.com.br/ws/$cep/json/");
    http.Response resposta = await http.get(_urlApi);

    String endereco = "";

    if (resposta.statusCode == 200) {
      print('Código de Resposta: ${resposta.statusCode}');

      // endereco =  resposta.body;

      Map<String, dynamic> dadosCep = json.decode(resposta.body);

      endereco = "${dadosCep["logradouro"]}, ${dadosCep["bairro"]},"
          "${dadosCep["localidade"]} - ${dadosCep["uf"]} ";
    } else {
      endereco = 'Cep informado incorretamente ou não encontrado.';
    }

    setState(() {
      _valorRetorno = endereco;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consulta de CEP"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'CEP'),
              ),
            ),
            Text('$_valorRetorno')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buscarCep,
        child: Icon(Icons.search),
        backgroundColor: Colors.grey,
      ),
    );
  }
}
