class MyCalulate {
  String cutWord({required String string, int? number}) {
    String word = string;
    int numWord = number ?? 9;

    if (word.length > numWord) {
      word = word.substring(0, number);
      word = '$word...';
    }
    return word;
  }

  List<String> changeStriongToArray({required String string}) {
    var results = <String>[];

    String myString = string.substring(1, string.length - 1);
    results = myString.split(',');
    for (var i = 0; i < results.length; i++) {
      results[i] = results[i].trim();
    }

    return results;
  }
}
