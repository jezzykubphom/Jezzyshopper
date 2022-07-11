class MyCalulate {
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
