import 'dart:convert';

BorrarTablas borrarTablasFromJson(String str) => BorrarTablas.fromJson(json.decode(str));

String borrarTablasToJson(BorrarTablas data) => json.encode(data.toJson());

class BorrarTablas {
    BorrarTablas({
        required this.tblName,
    });

    String tblName;

    factory BorrarTablas.fromJson(Map<String, dynamic> json) => BorrarTablas(
        tblName: json["tbl_name"],
    );

    Map<String, dynamic> toJson() => {
        "tbl_name": tblName,
    };
}