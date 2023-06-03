abstract class Attribute {}

class DataClass {
  final List<Attribute> attributes;

  DataClass(this.attributes);
}

class RedAttribute extends Attribute {
  RedAttribute();
}

class BlueAttribute extends Attribute {
  BlueAttribute();
}

class YellowAttribute extends Attribute {
  YellowAttribute();
}

// Needs to be positional parameters
// Cannot accept a List<Attribute> as a parameter
DataClass dataBuilder([
  Attribute? p1,
  Attribute? p2,
  Attribute? p3,
  Attribute? p4,
  Attribute? p5,
  Attribute? p6,
  Attribute? p7,
  Attribute? p8,
  Attribute? p9,
  Attribute? p10,
  Attribute? p11,
  Attribute? p12,
]) {
  final params = <Attribute>[];

  if (p1 != null) params.add(p1);
  if (p2 != null) params.add(p2);
  if (p3 != null) params.add(p3);
  if (p4 != null) params.add(p4);
  if (p5 != null) params.add(p5);
  if (p6 != null) params.add(p6);
  if (p7 != null) params.add(p7);
  if (p8 != null) params.add(p8);
  if (p9 != null) params.add(p9);
  if (p10 != null) params.add(p10);
  if (p11 != null) params.add(p11);
  if (p12 != null) params.add(p12);

  return DataClass(params);
}

void main() {
  final data = dataBuilder(
    RedAttribute(),
    BlueAttribute(),
    YellowAttribute(),
  );

  print(data.attributes);
}
