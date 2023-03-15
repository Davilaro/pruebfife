import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

class DropDownCustom extends FormField<String> {
  final dynamic value;
  final Widget? icon;
  final String? hintText;
  final TextStyle hintStyle;
  final String? labelText;
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final bool required;
  final bool enabled;
  final List<dynamic>? items;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldSetter<dynamic>? setter;
  final ValueChanged<dynamic>? onValueChanged;
  final bool strict;
  final int itemsVisibleInDropdown;
  final TextInputType? keyboard;
  final bool iconClear;
  final Function(String?)? onChanged;
  final Function(String?)? validListSeleect;
  TextEditingController? controller;

  DropDownCustom(
      {Key? key,
      this.controller,
      this.value,
      this.required: false,
      this.icon,
      this.hintText,
      this.hintStyle: const TextStyle(
          fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 18.0),
      this.labelText,
      this.labelStyle: const TextStyle(
          fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 18.0),
      this.inputFormatters,
      this.items,
      this.textStyle: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14.0),
      this.setter,
      this.onValueChanged,
      this.itemsVisibleInDropdown: 3,
      this.enabled: true,
      this.keyboard,
      this.iconClear: false,
      this.onChanged,
      this.validListSeleect,
      this.strict: true})
      : super(
          key: key,
          initialValue: controller != null ? controller.text : (value ?? ''),
          onSaved: setter,
          builder: (FormFieldState<String> field) {
            final DropDownFieldState state = field as DropDownFieldState;
            final ScrollController _scrollController = ScrollController();
            final InputDecoration effectiveDecoration = InputDecoration(
                border: InputBorder.none,
                filled: false,
                icon: icon,
                suffixIcon: IconButton(
                    icon: Icon(Icons.arrow_drop_down,
                        size: 30.0, color: HexColor("#41398D")),
                    onPressed: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      state.setState(() {
                        state._showdropdown = !state._showdropdown;
                      });
                    }),
                hintStyle: hintStyle,
                labelStyle: labelStyle,
                hintText: hintText,
                labelText: labelText);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 7),
                        decoration: BoxDecoration(
                          color: HexColor("#E4E3EC"),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TextFormField(
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          controller: state._effectiveController,
                          decoration: effectiveDecoration.copyWith(
                              errorText: field.errorText),
                          style: textStyle,
                          keyboardType: keyboard,
                          textAlign: TextAlign.left,
                          autofocus: false,
                          obscureText: false,
                          maxLines: 1,
                          onChanged: onChanged == null ? null : onChanged,
                          validator: (String? newValue) {
                            if (required) {
                              if (newValue == null || newValue.isEmpty)
                                return 'This field cannot be empty!';
                            }
                            if (items != null) {
                              if (strict &&
                                  newValue!.isNotEmpty &&
                                  !items.contains(newValue))
                                return 'dato invalido';
                            }

                            return null;
                          },
                          onSaved: setter,
                          enabled: enabled,
                          inputFormatters: inputFormatters,
                        ),
                      ),
                    ),
                  ],
                ),
                !state._showdropdown
                    ? Container()
                    : Container(
                        alignment: Alignment.centerLeft,
                        height: itemsVisibleInDropdown *
                            48.0, //limit to default 3 items in dropdownlist view and then remaining scrolls
                        width: MediaQuery.of(field.context).size.width,
                        child: ListView(
                          cacheExtent: 0.0,
                          scrollDirection: Axis.vertical,
                          controller: _scrollController,
                          padding: const EdgeInsets.only(left: 0.0),
                          children: items!.isNotEmpty
                              ? ListTile.divideTiles(
                                      context: field.context,
                                      tiles: state._getChildren(
                                          state._items!, validListSeleect))
                                  .toList()
                              : [],
                        ),
                      ),
              ],
            );
          },
        );

  @override
  DropDownFieldState createState() => DropDownFieldState();
}

class DropDownFieldState extends FormFieldState<String> {
  TextEditingController? _controller;
  bool _showdropdown = false;
  bool _isSearching = true;
  String _searchText = "";

  @override
  DropDownCustom get widget => super.widget as DropDownCustom;
  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  List<String>? get _items => widget.items as List<String>?;

  void toggleDropDownVisibility() {}

  void clearValue() {
    setState(() {
      _effectiveController!.text = '';
    });
  }

  @override
  void didUpdateWidget(DropDownCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller!.value);
      if (widget.controller != null) {
        setValue(widget.controller!.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    }

    _effectiveController!.addListener(_handleControllerChanged);

    _searchText = _effectiveController!.text;
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController!.text = widget.initialValue!;
    });
  }

  List<ListTile> _getChildren(
      List<String> items, Function(String?)? validListSeleect) {
    List<ListTile> childItems = [];
    for (var item in items) {
      if (_searchText.isNotEmpty) {
        if (item.toUpperCase().contains(_searchText.toUpperCase()))
          childItems.add(_getListTile(item, validListSeleect));
      } else {
        childItems.add(_getListTile(item, validListSeleect));
      }
    }
    _isSearching ? childItems : [];
    return childItems;
  }

  ListTile _getListTile(String text, Function(String?)? validListSeleect) {
    return ListTile(
      dense: true,
      title: Text(
        text,
      ),
      onTap: () {
        setState(() {
          validListSeleect!(text);
          _effectiveController!.text = text;
          _handleControllerChanged();
          _showdropdown = false;
          _isSearching = false;
          if (widget.onValueChanged != null) widget.onValueChanged!(text);
        });
      },
    );
  }

  void _handleControllerChanged() {
    if (_effectiveController!.text != value)
      didChange(_effectiveController!.text);

    if (_effectiveController!.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchText = "";
      });
    } else {
      setState(() {
        _isSearching = true;
        _searchText = _effectiveController!.text;
        _showdropdown = true;
      });
    }
  }
}
