/// Fiyatı Türk lirası biçiminde yazar. Örnek: 1299.9 -> 1.299,90 TL
String formatPrice(double price) {
  final String fixed = price.toStringAsFixed(2);
  final List<String> parts = fixed.split('.');
  final String whole = parts[0];
  final StringBuffer buffer = StringBuffer();

  for (int i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(whole[i]);
  }

  return '${buffer.toString()},${parts[1]} TL';
}
