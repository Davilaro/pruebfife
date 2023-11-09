import 'dart:convert';

Encuesta encuestaFromJson(String str) => Encuesta.fromJson(json.decode(str));

String encuestaToJson(Encuesta data) => json.encode(data.toJson());

class Encuesta {
  Encuesta({
    this.encuestaId,
    this.encuestaTitulo,
    this.preguntaId,
    this.tipoPreguntaId,
    this.obligatoria,
    this.pregunta,
    this.paramPreguntaId,
    this.valor,
    this.parametro,
  });

  int? encuestaId;
  String? encuestaTitulo;
  int? preguntaId;
  int? tipoPreguntaId;
  int? obligatoria;
  String? pregunta;
  int? paramPreguntaId;
  int? valor;
  List<dynamic>? parametro;

  factory Encuesta.fromJson(Map<String, dynamic> json) => Encuesta(
      encuestaId: json["encuestaid"],
      encuestaTitulo: json["encuestaTitulo"],
      preguntaId: json["preguntaid"],
      tipoPreguntaId: json["tipopreguntaid"],
      obligatoria: json["obligatoria"],
      pregunta: json["pregunta"],
      paramPreguntaId: json["paramPreguntaId"],
      valor: json["valor"],
      parametro: []);

  factory Encuesta.fromJson2(Map<String, dynamic> json) => Encuesta(
        encuestaId: json["encuestaid"],
        encuestaTitulo: json["encuestaTitulo"],
        preguntaId: json["preguntaid"],
        tipoPreguntaId: json["tipopreguntaid"],
        obligatoria: json["obligatoria"],
        pregunta: json["pregunta"],
        paramPreguntaId: json["paramPreguntaId"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        "encuestaid": encuestaId,
        "encuestaTitulo": encuestaTitulo,
        "preguntaid": preguntaId,
        "tipopreguntaid": tipoPreguntaId,
        "obligatoria": obligatoria,
        "pregunta": pregunta,
        "paramPreguntaId": paramPreguntaId,
        "valor": valor,
        "parametro": parametro,
      };
}
