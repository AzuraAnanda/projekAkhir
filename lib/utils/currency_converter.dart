class CurrencyConverter {
  static const Map<String, double> conversionRates = {
    'USD': 1.0, // Base rate
    'EUR': 0.85,
    'IDR': 15000.0,
    'JPY': 110.0,
    'GBP': 0.75,
  };

  static double convert(String currency, double baseAmount) {
    return (conversionRates[currency] ?? 1.0) * baseAmount;
  }
}
