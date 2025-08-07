int? parsePolishNumber(String input) {
  final signs = {
    'minus': -1,
    // 'przecinek': 0.01,
  };

  final units = {
    'zero': 0,
    'jeden': 1,
    'dwa': 2,
    'trzy': 3,
    'cztery': 4,
    'pięć': 5,
    'sześć': 6,
    'siedem': 7,
    'osiem': 8,
    'dziewięć': 9
  };

  final teens = {
    'dziesięć': 10,
    'jedenaście': 11,
    'dwanaście': 12,
    'trzynaście': 13,
    'czternaście': 14,
    'piętnaście': 15,
    'szesnaście': 16,
    'siedemnaście': 17,
    'osiemnaście': 18,
    'dziewiętnaście': 19
  };

  final tens = {
    'dwadzieścia': 20,
    'trzydzieści': 30,
    'czterdzieści': 40,
    'pięćdziesiąt': 50,
    'sześćdziesiąt': 60,
    'siedemdziesiąt': 70,
    'osiemdziesiąt': 80,
    'dziewięćdziesiąt': 90
  };

  final hundreds = {
    'sto': 100,
    'dwieście': 200,
    'trzysta': 300,
    'czterysta': 400,
    'pięćset': 500,
    'sześćset': 600,
    'siedemset': 700,
    'osiemset': 800,
    'dziewięćset': 900
  };

  final words = input.toLowerCase().split(RegExp(r'\s+'));
  int total = 0;

  for (var word in words) {
    if (hundreds.containsKey(word)) {
      total += hundreds[word]!;
    } else if (tens.containsKey(word)) {
      total += tens[word]!;
    } else if (teens.containsKey(word)) {
      total += teens[word]!;
    } else if (units.containsKey(word)) {
      total += units[word]!;
    } else if (signs.containsKey(word)) {
      total *= units[word]!;
    } else {
      return null; // nierozpoznane słowo
    }
  }

  return total;
}
