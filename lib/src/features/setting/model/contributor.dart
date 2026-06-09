class Contributor {
  final String name;
  Contributor(this.name);
}

class Contributors {
  static List<Contributor> contributors = [
    Contributor('Muhammad Arslan'),
    Contributor('Flutter Developer'),
  ];

  static int get firstColumnCount {
    final int total = contributors.length;

    if (total % 2 == 0) {
      return (total / 2).round();
    } else {
      return (total / 2).round() + 1;
    }
  }

  static int get secondColumnCount => contributors.length - firstColumnCount;
}
