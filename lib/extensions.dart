extension order on String {
  int numPart() {
    List<String> digits = [];
    for (var i in this.runes) {
      if (['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
          .contains(String.fromCharCode(i))) {
        digits.add(String.fromCharCode(i));
      }
    }
    return int.tryParse(digits.join());
  }
}
