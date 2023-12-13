import 'package:shared_preferences/shared_preferences.dart';

class Preferencias {
  static final Preferencias _instancia = Preferencias._internal();
  factory Preferencias() {
    return _instancia;
  }

  Preferencias._internal();

  late SharedPreferences _prefs;

  get usuarioRazonSocial {
    return _prefs.getString('usuarioRazonSocial') ?? "";
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
    return _prefs.getString('usuarioLogueado') ?? "";
  }

  set usuarioLogueado(dynamic value) {
    _prefs.setString('usuarioLogueado', value);
  }

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
    momentSurvey = 0;
  }

  get codClienteLogueado {
    return _prefs.getString('codClienteLogueado') ?? "";
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
    return _prefs.getString('codTienda') ?? "";
  }

  set codTienda(dynamic value) {
    _prefs.setString('codTienda', value);
  }

  get numEmpresa {
    return _prefs.getInt('numEmpresa') ?? 0;
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
    return _prefs.getInt('numCategoria') ?? 0;
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
    return _prefs.getString('usuarioLoginCedula') ?? "";
  }

  set usurioLoginCedula(dynamic value) {
    _prefs.setString('usuarioLoginCedula', value);
  }

  get codActivacionLogin {
    return _prefs.getInt('codActivacion') ?? 0;
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

  get codigoalpina {
    return _prefs.getString('codigoalpina') ?? '';
  }

  set codigoalpina(dynamic value) {
    _prefs.setString('codigoalpina', value);
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

  

  get ciudad {
    return _prefs.getString("ciudad") ?? "";
  }

  set ciudad(dynamic value) {
    _prefs.setString("ciudad", value);
  }

  get diaActual {
    return _prefs.getString("diaactual") ?? "";
  }

  set diaActual(dynamic value) {
    _prefs.setString("diaactual", value);
  }

  get nextDay {
    return _prefs.getString("nextday") ?? "";
  }

  set nextDay(dynamic value) {
    _prefs.setString("nextday", value);
  }

  get direccionSucursal {
    return _prefs.getString("direccionsucursal") ?? "";
  }

  set direccionSucursal(dynamic value) {
    _prefs.setString("direccionsucursal", value);
  }

  get isFirstTime {
    return _prefs.getBool("isfirsttime") ?? true;
  }

  set isFirstTime(dynamic value) {
    _prefs.setBool("isfirsttime", value);
  }

  get oficinaVentas {
    return _prefs.getString("oficinaventas") ?? "";
  }

  set oficinaVentas(dynamic value) {
    _prefs.setString("oficinaventas", value);
  }

  bool? get isDataBiometricActive {
    final value = _prefs.getBool("isDataBiometricActive");
    return value == null ? null : value;
  }

  set isDataBiometricActive(dynamic value) {
    if (value == null) {
      _prefs.remove(
          "isDataBiometricActive"); // Elimina la clave si el valor es nulo.
    } else {
      _prefs.setBool("isDataBiometricActive", value);
    }
  }

  get ccupBiometric {
    return _prefs.getString("ccupBiometric") ?? "";
  }

  set ccupBiometric(dynamic value) {
    _prefs.setString("ccupBiometric", value);
  }

  get typeCollaborator {
    return _prefs.getString("typCollaborator") ?? "";
  }

  set typeCollaborator(dynamic value) {
    _prefs.setString("typCollaborator", value);
  }

  get momentSurvey {
    return _prefs.getInt("momentSurvey") ?? "";
  }

  set momentSurvey(dynamic value) {
    _prefs.setInt("momentSurvey", value);
  }
}
