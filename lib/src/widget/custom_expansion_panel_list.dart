// ignore_for_file: deprecated_colon_for_default_value, unnecessary_null_comparison, non_nullable_equals_parameter

import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';

const double _kPanelHeaderCollapsedHeight = 80.0;
const double _kPanelHeaderExpandedHeight = 80.0;

class CustomExpansionPanelList extends StatelessWidget {
  const CustomExpansionPanelList(
      {Key? key,
      this.children: const <ExpansionPanel>[],
      required this.expansionCallback,
      this.animationDuration: kThemeAnimationDuration})
      : assert(children != null),
        assert(animationDuration != null),
        super(key: key);

  final List<ExpansionPanel> children;

  final ExpansionPanelCallback expansionCallback;

  final Duration animationDuration;

  bool _isChildExpanded(int index) {
    return children[index].isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[];
    const EdgeInsets kExpandedEdgeInsets = const EdgeInsets.symmetric(
        vertical: _kPanelHeaderExpandedHeight - _kPanelHeaderCollapsedHeight);

    for (int index = 0; index < children.length; index += 1) {
      if (_isChildExpanded(index) && index != 0 && !_isChildExpanded(index - 1))
        items.add(new Divider(
          key: new _SaltedKey<BuildContext, int>(context, index * 2 - 1),
          height: 15.0,
          color: Colors.transparent,
        ));

      final Stack header = Stack(
        children: [
          Container(
            height: _isChildExpanded(index) ? 90 : 0.0,
            color: Colors.white,
          ),
          Container(
            height: _isChildExpanded(index) ? 90 : 0.0,
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -7), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: _isChildExpanded(index) ? Radius.circular(15.0) : Radius.circular(0),
                bottomRight: _isChildExpanded(index) ? Radius.circular(15.0) : Radius.circular(0),
              ),
            ),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new AnimatedContainer(
                    duration: animationDuration,
                    curve: Curves.fastOutSlowIn,
                    margin: _isChildExpanded(index)
                        ? kExpandedEdgeInsets
                        : EdgeInsets.zero,
                    child: new SizedBox(
                      height: _kPanelHeaderCollapsedHeight,
                      child: children[index].headerBuilder(
                        context,
                        children[index].isExpanded,
                      ),
                    ),
                  ),
                ),
                new Container(
                  margin: const EdgeInsetsDirectional.only(end: 8.0),
                  child: new ExpandIcon(
                    isExpanded: _isChildExpanded(index),
                    padding: const EdgeInsets.all(16.0),
                    color: ConstantesColores.verde,
                    onPressed: (bool isExpanded) {
                      if (expansionCallback != null)
                        expansionCallback(index, isExpanded);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      );

      double _radiusValue = _isChildExpanded(index) ? 10.0 : 12.0;
      items.add(
        new Container(
          key: new _SaltedKey<BuildContext, int>(context, index * 2),
          child: new Material(
            elevation: 2.0,
            borderRadius:
                new BorderRadius.all(new Radius.circular(_radiusValue)),
            child: new Column(
              children: <Widget>[
                header,
                new AnimatedCrossFade(
                  firstChild: new Container(height: 0.0),
                  secondChild: children[index].body,
                  firstCurve:
                      const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                  secondCurve:
                      const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                  sizeCurve: Curves.fastOutSlowIn,
                  crossFadeState: _isChildExpanded(index)
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: animationDuration,
                ),
              ],
            ),
          ),
        ),
      );

      if (_isChildExpanded(index) && index != children.length - 1)
        items.add(new Divider(
          key: new _SaltedKey<BuildContext, int>(context, index * 2 + 1),
          height: 15.0,
        ));
    }

    return new Column(
      children: items,
    );
  }
}

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final _SaltedKey<S, V> typedOther = other;
    return salt == typedOther.salt && value == typedOther.value;
  }

  @override
  int get hashCode => hashValues(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? '<\'$salt\'>' : '<$salt>';
    final String valueString = V == String ? '<\'$value\'>' : '<$value>';
    return '[$saltString $valueString]';
  }
}
