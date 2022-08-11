# MVolaAPI dart package
This is a package that can be used to interact with the [MVola API](https://www.mvola.mg/devportal/home).

## Features

It allow you to make payments, see the status of a transaction and get the details of a previously made transaction.

## Getting started

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

## Usage
Start by importing the library.

```dart
import 'package:mvola/mvola.dart';
```
Then create an instance of the `MVolaClient` class.
```dart
var mvola = MVolaClient();
```
You then have to generate an access token in order to make transactions.
You can store it in a variable for later use or just call the method to set it.
```dart
await mvola.generateAccessToken();
```
Now, you can make transactions, get the status of that transaction or get the details of a transaction. 
```dart
// make a transaction
var transactionResponse = await mvola.initTransaction(
    'gvola',
    '0343500004',
    5000,
    '0343500003',
);
print(transactionResponse);

// get the status of a transaction
var transactionStatus = await mvola.getTransactionStatus(transactionResponse.serverCorrelationId, '0343500004', 'gvola');
print(transactionStatus);

// get the detail of a transaction
var transaction = await mvola.getTransactionDetail("636838929", "gvola", "0343500004");
print(transaction); 
```
The complete example code can be found [here](https://github.com/tbgracy/mvola-dart/blob/main/example/mvola_example.dart).

## Additional information

This package is still in early stage of developpment. So please, if don't hesitate to point out any issue or suggest an improvment.

## Author
**Tsierenana Botramanagna Gracy**
