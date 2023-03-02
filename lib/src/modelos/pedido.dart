class Pedido {
  Pedido({
    this.cantidad,
    this.codigoProducto,
    this.precio,
    this.iva,
    this.fabricante,
    this.codigoFabricante,
    this.nitFabricante,
    this.codCliente,
    this.tipoFabricante,
    this.codProveedor,
    this.codigocliente,
    this.nombreProducto,
    this.precioInicial,
    this.descuento,
  });

  int? cantidad;
  String? codigoProducto;
  double? precio;
  int? iva;
  String? fabricante;
  String? codigoFabricante;
  String? nitFabricante;
  String? codCliente;
  String? tipoFabricante;
  int? codProveedor;
  String? codigocliente;
  String? nombreProducto;
  double? precioInicial;
  double? descuento;
}
