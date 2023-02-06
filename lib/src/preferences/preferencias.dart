import 'package:shared_preferences/shared_preferences.dart';

class Preferencias {
  static final Preferencias _instancia = Preferencias._internal();
  factory Preferencias() {
    return _instancia;
  }

  Preferencias._internal();

  late SharedPreferences _prefs;

  get usuarioRazonSocial {
    return _prefs.getString('usuarioRazonSocial') ?? null;
  }

  set usuarioRazonSocial(dynamic value) {
    _prefs.setString('usuarioRazonSocial', value);
  }

  get paisUsuario {
    return _prefs.getString("paisUsuario") ?? null;
  }

  set paisUsuario(dynamic value) {
    _prefs.setString("paisUsuario", value);
  }

  get usuarioLogueado {
    return _prefs.getString('usuarioLogueado') ?? null;
  }

  set usuarioLogueado(dynamic value) {
    _prefs.setString('usuarioLogueado', value);
  }

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get codClienteLogueado {
    return _prefs.getString('codClienteLogueado') ?? null;
  }

  set codClienteLogueado(dynamic value) {
    _prefs.setString('codClienteLogueado', value);
  }

  get codCliente {
    return _prefs.getString('codCliente') ?? '10776788';
  }

  set codCliente(dynamic value) {
    _prefs.setString('codCliente', value);
  }

  get codTienda {
    return _prefs.getString('codTienda') ?? null;
  }

  set codTienda(dynamic value) {
    _prefs.setString('codTienda', value);
  }

  get numEmpresa {
    return _prefs.getInt('numEmpresa') ?? null;
  }

  set numEmpresa(dynamic value) {
    _prefs.setInt('numEmpresa', value);
  }

  get colorThema {
    return _prefs.getInt('colorThema') ?? 0xFF3366FF;
  }

  set colorThema(dynamic value) {
    _prefs.setInt(
        'colorThema', int.parse(('0xFF${value.replaceAll("#", "")}')));
  }

  get numCategoria {
    return _prefs.getInt('numCategoria') ?? null;
  }

  set numCategoria(dynamic value) {
    _prefs.setInt('numCategoria', value);
  }

  get usurioLogin {
    return _prefs.getInt('usuarioLogin') ?? -1;
  }

  set usurioLogin(dynamic value) {
    _prefs.setInt('usuarioLogin', value);
  }

  get usurioLoginCedula {
    return _prefs.getString('usuarioLoginCedula') ?? null;
  }

  set usurioLoginCedula(dynamic value) {
    _prefs.setString('usuarioLoginCedula', value);
  }

  get codActivacionLogin {
    return _prefs.getInt('codActivacion') ?? null;
  }

  set codActivacionLogin(dynamic value) {
    _prefs.setInt('codActivacion', value);
  }

  get listaBanners {
    return _prefs.getString('listaBanners') ?? '';
  }

  set listaBanners(dynamic value) {
    _prefs.setString('listaBanners', value);
  }

  get codigomeals {
    return _prefs.getString('codigomeals') ?? '';
  }

  set codigomeals(dynamic value) {
    _prefs.setString('codigomeals', value);
  }

  get codigonutresa {
    return _prefs.getString('codigonutresa') ?? '';
  }

  set codigonutresa(dynamic value) {
    _prefs.setString('codigonutresa', value);
  }

  get codigozenu {
    return _prefs.getString('codigozenu') ?? '';
  }

  set codigozenu(dynamic value) {
    _prefs.setString('codigozenu', value);
  }

  get codigopozuelo {
    return _prefs.getString('codigopozuelo') ?? '';
  }

  set codigopozuelo(dynamic value) {
    _prefs.setString('codigopozuelo', value);
  }

  get codigopadrepideky {
    return _prefs.getString('codigopadrepideky') ?? '';
  }

  set codigopadrepideky(dynamic value) {
    _prefs.setString('codigopadrepideky', value);
  }

  get codigoUnicoPideky {
    return _prefs.getString("codigounicopideky") ?? "";
  }

  set codigoUnicoPideky(dynamic value) {
    _prefs.setString("codigounicopideky", value);
  }

  get sucursal {
    return _prefs.getString("sucursal") ?? "";
  }

  set sucursal(dynamic value) {
    _prefs.setString("sucursal", value);
  }

  get diaActual {
    return _prefs.getString("diaactual") ?? "";
  }

  set diaActual(dynamic value) {
    _prefs.setString("diaactual", value);
  }

  clear() async {
    await _prefs.clear();
  }
}
