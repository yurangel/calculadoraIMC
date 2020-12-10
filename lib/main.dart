import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class Pessoa {
  double peso;
  double altura;
  int gender;

  Pessoa(
    this.peso,
    this.altura,
    this.gender,
  );

  String calculateImc() {
    double imc = peso / (altura * altura);
    String _result = "";
    _result = "IMC = ${imc.toStringAsPrecision(4)}\n";
    if ((imc < 20.7 && gender == 0) ||
        (imc < 19.1 && gender == 1) ||
        (imc < 17 && gender == 2))
      _result += "Abaixo do peso = 0xFF00BFA5";
    else if ((imc < 26.4 && gender == 0) ||
        (imc < 25.8 && gender == 1) ||
        (imc < 25 && gender == 2))
      _result += "Peso ideal = 0XFF4CAF50";
    else if ((imc < 27.8 && gender == 0) ||
        (imc < 27.3 && gender == 1) ||
        (imc < 30 && gender == 2))
      _result += "Levemente acima do peso = 0XFFFF9800";
    else if ((imc < 31.1 && gender == 0) ||
        (imc < 32.3 && gender == 1) ||
        (imc < 35 && gender == 2))
      _result += "Obesidade Grau I = 0XFFBF360C";
    else if (imc < 40)
      _result += "Obesidade Grau II = 0XFFF44336";
    else
      _result += "Obesidade Grau III = 0XFFB71C1C";

    return _result;
  }
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  String _result;
  List<bool> _selections = List.generate(2, (_) => false);
  List<Color> globalColor = <Color>[Colors.blue, Colors.pink, Colors.grey];

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetFields() {
    _weightController.text = '';
    _heightController.text = '';
    _selections = List.generate(2, (_) => false);
    setState(() {
      _result = 'Informe seus dados';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0), child: buildForm()));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Calculadora de IMC'),
      backgroundColor: globalColor[gerdenSelection()],
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            resetFields();
          },
        )
      ],
    );
  }

  int gerdenSelection() {
    if (_selections[0])
      return 0;
    else if (_selections[1])
      return 1;
    else
      return 2;
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildGerdenToggle(),
          buildTextFromField(
              label: "Peso (kg)",
              error: "Inserir seu peso!",
              controller: _weightController),
          buildTextFromField(
              label: "Altura (m.cm)",
              error: "Inserir uma altura!",
              controller: _heightController),
          buildTextResult(),
          buildCalculateButton(),
        ],
      ),
    );
  }

  Widget buildCalculateButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: RaisedButton(
        color: globalColor[gerdenSelection()],
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Pessoa pessoa = Pessoa(double.parse(_weightController.text),
                double.parse(_heightController.text), gerdenSelection());
            setState(() {
              _result = pessoa.calculateImc();
            });
          }
        },
        child: Text('CALCULAR', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget buildGerdenToggle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: ToggleButtons(
        children: <Widget>[
          Icon(
            Icons.person,
            color: Colors.blue,
          ),
          Icon(Icons.person, color: Colors.pink),
        ],
        onPressed: (int index) {
          setState(() {
            for (int buttonIndex = 0;
                buttonIndex < _selections.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                _selections[buttonIndex] = !_selections[buttonIndex];
              } else {
                _selections[buttonIndex] = false;
              }
            }
          });
        },
        fillColor: Colors.grey,
        borderRadius: BorderRadius.circular(30),
        isSelected: _selections,
      ),
    );
  }

  Widget buildTextResult() {
    TextStyle defaultStyle = TextStyle(color: Colors.black, fontSize: 20.0);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: RichText(
          text: TextSpan(style: defaultStyle, children: comparResult

              //textAlign: TextAlign.center,

              //textScaleFactor: 1.5,
              //style: TextStyle(fontWeight: FontWeight.bold),
              )),
    );
  }

  List<TextSpan> get comparResult {
    List<String> resultCompar = _result.split("=");
    TextStyle imcStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0);
    TextStyle classificationStyle = TextStyle(
        color: Color(resultCompar[0].contains("IMC")
            ? int.parse(resultCompar[resultCompar.length - 1])
            : 0xFF00FFFF));
    return resultCompar[0].contains("IMC")
        ? [
            TextSpan(text: resultCompar[0]),
            TextSpan(text: "="),
            TextSpan(
              text: resultCompar[1].substring(0, 6),
              style: imcStyle,
            ),
            TextSpan(
              text: resultCompar[1].substring(6),
              style: classificationStyle,
            )
          ]
        : [TextSpan(text: _result)];
  }

  TextFormField buildTextFromField(
      {TextEditingController controller, String error, String label}) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (text) {
        return text.isEmpty ? error : null;
      },
    );
  }
}
