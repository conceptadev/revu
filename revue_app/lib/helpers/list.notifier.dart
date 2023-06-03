import 'package:flutter/foundation.dart';

class ListNotifier<T> with ChangeNotifier {
  final List<T> _list;

  ListNotifier([List<T>? initialList]) : _list = initialList ?? [];

  int get length => _list.length;

  T operator [](int index) => _list[index];

  // Set operator []
  void operator []=(int index, T value) {
    _list[index] = value;
    notifyListeners();
  }

  T get last => _list.last;

  T get first => _list.first;

  void add(T element) {
    _list.add(element);
    notifyListeners();
  }

  List<T> get reverse => _list.reversed.toList();

  void addAll(Iterable<T> elements) {
    _list.addAll(elements);
    notifyListeners();
  }

  void insert(int index, T element) {
    _list.insert(index, element);
    notifyListeners();
  }

  T removeAt(int index) {
    final element = _list.removeAt(index);
    notifyListeners();
    return element;
  }

  T removeLast() {
    final element = _list.removeLast();
    notifyListeners();
    return element;
  }

  void removeWhere(bool Function(T element) test) {
    _list.removeWhere(test);
    notifyListeners();
  }

  void clear() {
    _list.clear();
    notifyListeners();
  }

  void sort([int Function(T a, T b)? compare]) {
    _list.sort(compare);
    notifyListeners();
  }

  Iterable<T> where(bool Function(T element) test) => _list.where(test);

  List<R> map<R>(R Function(T e) f) => _list.map(f).toList();

  List<T> sublist(int start, [int? end]) => _list.sublist(start, end);

  bool get isEmpty => _list.isEmpty;

  bool get isNotEmpty => _list.isNotEmpty;

  bool contains(Object? element) => _list.contains(element);

  @override
  String toString() => _list.toString();
}
