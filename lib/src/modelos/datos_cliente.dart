import 'dart:convert';

DatosCliente datosClienteFromJson(String str) =>
    DatosCliente.fromJson(json.decode(str));

String datosClienteToJson(DatosCliente data) => json.encode(data.toJson());

class DatosCliente {
  DatosCliente(
      {this.codigo,
      this.nombre,
      this.razonsocial,
      this.nit,
      this.direccion,
      this.ciudad,
      this.telefono,
      this.telefonoWhatsapp,
      this.condicionPago,
      this.codigoUnicoPideky,
      this.pais,
      this.codigomeals,
      this.codigonutresa,
      this.codigozenu,
      this.codigopozuelo,
      this.codigoalpina,
      this.nitNutresa,
      this.nitZenu,
      this.nitMeals,
      this.nitPozuelo,
      this.nitAlpina,
      this.codRegional,
      this.regional});

  String? codigo;
  String? nombre;
  String? razonsocial;
  String? nit;
  String? direccion;
  String? ciudad;
  String? telefono;
  String? telefonoWhatsapp;
  String? condicionPago;
  String? codigoUnicoPideky;
  String? pais;
  String? regional;
  String? codigonutresa;
  String? codigozenu;
  String? codigomeals;
  String? codigopozuelo;
  String? codigoalpina;
  String? nitNutresa;
  String? nitZenu;
  String? nitMeals;
  String? nitPozuelo;
  String? nitAlpina;
  String? codRegional;

  factory DatosCliente.fromJson(Map<String, dynamic> json) => DatosCliente(
        codigo: json["codigo"] == null ? '' : json['codigo'],
        nombre: json["nombre"] == null ? '' : json['nombre'],
        razonsocial: json["razonsocial"] == null ? '' : json['razonsocial'],
        nit: json["nit"] == null ? '' : json['nit'],
        direccion: json["direccion"] == null ? '' : json['direccion'],
        ciudad: json["ciudad"] == null ? '' : json['ciudad'],
        telefono: json["telefono"] == null ? '' : json['telefono'],
        telefonoWhatsapp:
            json["telefonowhatsapp"] == null ? '' : json['telefonowhatsapp'],
        condicionPago:
            json["condicion_pago"] == null ? '' : json['condicion_pago'],
        codigoUnicoPideky:
            json["CodigoUnicoPideky"] == null ? '' : json['CodigoUnicoPideky'],
        pais: json["Pais"] == null ? 'CO' : json['Pais'],
        codigomeals: json["codigomeals"] == null ? '' : json['codigomeals'],
        codigonutresa:
            json["codigonutresa"] == null ? '' : json['codigonutresa'],
        codigozenu: json["codigozenu"] == null ? '' : json['codigozenu'],
        codigopozuelo:
            json["codigopozuelo"] == null ? '' : json['codigopozuelo'],
        codigoalpina: json["codigoalpina"] == null ? '' : json['codigoalpina'],
        nitNutresa: json["NitNutresa"] == null ? '' : json['NitNutresa'],
        nitZenu: json["NitZenu"] == null ? '' : json['NitZenu'],
        nitMeals: json["NitMeals"] == null ? '' : json['NitMeals'],
        nitPozuelo: json["NitPozuelo"] == null ? '' : json['NitPozuelo'],
        nitAlpina: json["NitAlpina"] == null ? '' : json['NitAlpina'],
        regional: json["Regional"] == null ? "" : json['Regional'],
        codRegional: json["CodRegional"] == null ? "" : json['CodRegional'],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "nombre": nombre,
        "razonsocial": razonsocial,
        "nit": nit,
        "direccion": direccion,
        "ciudad": ciudad,
        "telefono": telefono,
        "telefonowhatsapp": telefonoWhatsapp,
        "condicion_pago": condicionPago,
        "Pais": pais,
        "codigomeals": codigomeals,
        "codigonutresa": codigonutresa,
        "codigozenu": codigozenu,
        "codigopozuelo": codigopozuelo,
        "codigoalpina": codigoalpina,
        "NitNutresa": nitNutresa,
        "NitZenu": nitZenu,
        "NitMeals": nitMeals,
        "NitPozuelo": nitPozuelo,
        "NitAlpina": nitAlpina,
        "Regional": regional,
        'CodRegional': codRegional
      };
}
