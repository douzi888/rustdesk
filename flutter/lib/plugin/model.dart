import 'package:flutter/material.dart';
import './common.dart';
import './desc.dart';

final Map<String, LocationModel> _locationModels = {};
final Map<String, OptionModel> _optionModels = {};

class OptionModel with ChangeNotifier {
  String? v;

  String? get value => v;
  set value(String? v) {
    this.v = v;
    notifyListeners();
  }

  static String key(String location, PluginId id, String peer, String k) =>
      '$location|$id|$peer|$k';
}

class PluginModel with ChangeNotifier {
  final List<UiType> uiList = [];
  final Map<String, String> opts = {};

  void add(UiType ui) {
    uiList.add(ui);
    notifyListeners();
  }

  String? getOpt(String key) => opts.remove(key);

  bool get isEmpty => uiList.isEmpty;
}

class LocationModel with ChangeNotifier {
  final Map<PluginId, PluginModel> pluginModels = {};

  void add(PluginId id, UiType ui) {
    if (pluginModels[id] != null) {
      pluginModels[id]!.add(ui);
    } else {
      var model = PluginModel();
      model.add(ui);
      pluginModels[id] = model;
      notifyListeners();
    }
  }

  void clear() {
    pluginModels.clear();
    notifyListeners();
  }

  bool get isEmpty => pluginModels.isEmpty;
}

void addLocationUi(String location, PluginId id, UiType ui) {
  _locationModels[location]?.add(id, ui);
}

LocationModel addLocation(String location) {
  if (_locationModels[location] == null) {
    _locationModels[location] = LocationModel();
  }
  return _locationModels[location]!;
}

void clearPlugin(PluginId pluginId) {
  for (var element in _locationModels.values) {
    element.pluginModels.remove(pluginId);
  }
}

void clearLocations() {
  for (var element in _locationModels.values) {
    element.clear();
  }
}

OptionModel addOptionModel(
    String location, PluginId pluginId, String peer, String key) {
  final k = OptionModel.key(location, pluginId, peer, key);
  if (_optionModels[k] == null) {
    _optionModels[k] = OptionModel();
  }
  return _optionModels[k]!;
}

void updateOption(
    String location, PluginId id, String peer, String key, String value) {
  final k = OptionModel.key(location, id, peer, key);
  _optionModels[k]?.value = value;
}
