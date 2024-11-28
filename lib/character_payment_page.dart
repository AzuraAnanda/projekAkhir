import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import 'character_detail_page.dart';

class CharacterPaymentPage extends StatefulWidget {
  final Map<String, dynamic> character;

  CharacterPaymentPage({required this.character});

  @override
  _CharacterPaymentPageState createState() => _CharacterPaymentPageState();
}

class _CharacterPaymentPageState extends State<CharacterPaymentPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _timeController =
      TextEditingController(); // For time input
  String _selectedCurrency = 'USD'; // Default to USD
  double _convertedAmount = 0.0;
  String _convertedTime = '';

  // Dummy conversion rates
  final Map<String, double> _currencyRates = {
    'USD': 1.0,
    'EUR': 0.9,
    'GBP': 0.75,
    'JPY': 110.0,
    'IDR': 15000.0,
  };

  // Timezone locations
  final Map<String, String> _timezoneLocations = {
    'WIB': 'Asia/Jakarta',
    'WITA': 'Asia/Makassar',
    'WIT': 'Asia/Jayapura',
    'London': 'Europe/London',
  };

  @override
  void initState() {
    super.initState();
    tzData.initializeTimeZones();
  }

  void _calculatePayment() {
    final amount = double.tryParse(_amountController.text);
    if (amount != null) {
      setState(() {
        _convertedAmount = amount * (_currencyRates[_selectedCurrency] ?? 1.0);
      });
    }
  }

  void _convertTime(String timezone) {
    final inputTime = _timeController.text;
    final timeParts = inputTime.split(':');
    if (timeParts.length == 2) {
      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);

      if (hour != null && minute != null) {
        final now = DateTime.now();
        final inputDateTime =
            DateTime(now.year, now.month, now.day, hour, minute);

        // Convert to selected timezone
        final location = tz.getLocation(_timezoneLocations[timezone]!);
        final timezoneTime = tz.TZDateTime.from(inputDateTime, location);

        setState(() {
          _convertedTime = DateFormat('HH:mm:ss').format(timezoneTime);
        });
      }
    }
  }

  void _processPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterDetailPage(character: widget.character),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment for Character', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Character Image
              if (widget.character['image'] != null)
                Center(
                  child: Image.network(
                    widget.character['image'],
                    fit: BoxFit.contain, // Display with original aspect ratio
                  ),
                ),
              SizedBox(height: 20),

              // Payment Amount Section
              Text(
                'Enter Amount:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount (in USD)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monetization_on),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),

              // Currency Selector
              Text(
                'Select Currency:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButton<String>(
                value: _selectedCurrency,
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value!;
                  });
                },
                items: _currencyRates.keys.map((String currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
                isExpanded: true,
              ),
              SizedBox(height: 20),

              // Display Converted Amount with Gradient
              if (_amountController.text.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Colors.deepPurple],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Converted Amount: $_convertedAmount $_selectedCurrency',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              SizedBox(height: 30),

              // Calculate Payment Button
              ElevatedButton(
                onPressed: _calculatePayment,
                child: const Text('Calculate Payment',  style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.redAccent,
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),

              // Proceed to Payment Button
              ElevatedButton(
                onPressed: _processPayment,
                child:  Text('Proceed to Payment',  style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.deepPurple,
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),

              // Divider to separate Payment and Time Zone Conversion
              Divider(
                height: 30,
                color: Colors.grey,
                thickness: 1,
              ),

              // Time Zone Conversion Section
              Text(
                'Time Zone Conversion:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Time Input Section
              TextField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Time (e.g., 16:40)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 20),

              // Time Zone Selector
              DropdownButton<String>(
                onChanged: (value) {
                  if (value != null) {
                    _convertTime(value);
                  }
                },
                items: _timezoneLocations.keys.map((String timezone) {
                  return DropdownMenuItem<String>(
                    value: timezone,
                    child: Text(timezone),
                  );
                }).toList(),
                hint: Text("Select a time zone"),
                isExpanded: true,
              ),
              SizedBox(height: 20),

              // Display Converted Time with Gradient
              if (_convertedTime.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Colors.deepPurple],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Converted Time: $_convertedTime',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
