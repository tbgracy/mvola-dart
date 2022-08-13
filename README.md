# MVolaAPI dart package
This is a package that can be used to interact with the [not that] brand new [MVola API](https://www.mvola.mg/devportal/home).

## 🔫 Features

It allow you to make payments, see the status of a transaction and get the details of a previously made transaction.

## 🛠️ Getting started

This package depends on the [uuid](https://pub.dev/packages/uuid) and the [http](https://pub.dev/packages/http) packages.


### Terminal installation
Type in the terminal : 
```sh
dart pub add mvola
```

### Pubspec installation
Add these lines to your pubspec.yaml :
```yaml
dependencies:
    mvola:
```
More info can be found [here](https://pub.dev/packages/mvola), the official package repository for [Dart](https://dart.dev/) and [Flutter](https://flutter.dev/).

## Usage
Start by importing the library.

```dart
import 'package:mvola/mvola.dart';
```
Then create an instance of the `MVolaClient` class.
```dart
var mvola = MVolaClient(baseUrl, consumerKey, consumerSecret);
```
[consumerKey] and [consumerSecret] can be found on the [mvola devportal](https://www.mvola.mg/devportal) upon creating an application.

You then have to generate an access token in order to make transactions.
You can store it in a variable for later use or just call the method to set it.
```dart
await mvola.generateAccessToken();
```
Now, you can make transactions, get the status of that transaction or get the details of a transaction. 
```dart
// make a transaction
var transactionResponse = await mvola.initTransaction(
    'name',
    '0343500004',
    5000,
    '0343500003',
    'short description',
);
print(transactionResponse);

// get the status of a transaction
var transactionStatus = await mvola.getTransactionStatus(transactionResponse.serverCorrelationId, '0343500004', 'name');
print(transactionStatus);

// get the detail of a transaction
var transaction = await mvola.getTransactionDetail(serverCorrelationId, "name", "0343500004");
print(transaction); 
```
In the development environment, only 0343500004 and 0343500003 can be used as merchant or customer numbers.

The complete example code can be found [here](https://github.com/tbgracy/mvola-dart/blob/main/example/mvola_example.dart) or [here](https://pub.dev/packages/mvola/example).

## Additional information

ℹ️ This package is still in early stage of developpment. So please, don't hesitate to point out any issue or suggest an improvment.

## Author
👤 **Tsierenana Botramanagna Gracy**
