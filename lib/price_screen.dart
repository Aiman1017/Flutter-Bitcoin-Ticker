import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

CoinData coinData = CoinData();

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];

      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iosPicker();
    } else if (Platform.isAndroid) {
      return androidDropDown();
    }
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItem = [];

    for (String currency in currenciesList) {
      Text(currency);
      pickerItem.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 30.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
        ;
      },
      children: pickerItem,
    );
  }

  Map<String, String> coinValues = {};
  bool isFetching = false;

  void getData() async {
    isFetching = true;
    try {
      var data = await coinData.getCoinData(selectedCurrency);
      isFetching = false;

      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoView(
            selectedCryptoCurrency: 'BTC',
            value: isFetching ? '?' : coinValues['BTC'],
            selectedCurrency: selectedCurrency,
          ),
          CryptoView(
            selectedCryptoCurrency: 'ETH',
            value: isFetching ? '?' : coinValues['ETH'],
            selectedCurrency: selectedCurrency,
          ),
          CryptoView(
            selectedCryptoCurrency: 'LTC',
            value: isFetching ? '?' : coinValues['LTC'],
            selectedCurrency: selectedCurrency,
          ),
          Container(
            height: 70.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 5.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoView extends StatelessWidget {
  CryptoView({this.value, this.selectedCurrency, this.selectedCryptoCurrency});

  final String value;
  final String selectedCurrency;
  final String selectedCryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $selectedCryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
