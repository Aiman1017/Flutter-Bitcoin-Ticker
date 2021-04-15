import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'AMD',
  'AOA',
  'ARS',
  'AWG',
  'BRL',
  'BHD',
  'BDT',
  'BYN',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RUB',
  'SGD',
  'USD',
  'XOF',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '8FFDB6DF-4C19-476E-9889-D36D25A3E755';

class CoinData {
  Future getCoinData(String selectedCountry) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      String requestURL = '$apiURL/$crypto/$selectedCountry?apikey=$apiKey';
      http.Response response = await http.get(requestURL);

      if (response.statusCode == 200) {
        var decodeData = jsonDecode(response.body);
        var btcRate = decodeData['rate'];
        cryptoPrices[crypto] = btcRate.toStringAsFixed(0);
        var baseCurrency = decodeData['asset_id_base'];
        var quoteCurrency = decodeData['asset_id_quote'];
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
