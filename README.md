# MVolaAPI dart package

This is a package that can be used to interact with the [not that] brand new [MVola API](https://www.mvola.mg/devportal/home) from a [Dart](https://dart.dev) or [Flutter](https://flutter.dev) client.

## 🔫 Features

It allow you to make payments, see the status of a transaction and get the details of a previously made transaction.

## 🛠️ Getting started

This package depends on the [uuid](https://pub.dev/packages/uuid) and the [http](https://pub.dev/packages/http) packages.

### Installing from the command line

Type in the terminal :

```sh
dart pub add mvola
```

or, if your adding it to a flutter project :

```sh
flutter pub add mvola
```

### Pubspec installation

Add these lines to your pubspec.yaml :

```yaml
dependencies:
    mvola:
```

More info can be found on [pub.dev](https://pub.dev/packages/mvola), the official package repository for [Dart](https://dart.dev/) and [Flutter](https://flutter.dev/).

## Usage

Start by importing the library.

```dart
import 'package:mvola/mvola.dart';
```

Then create an instance of the `MVolaClient` class with the base url for the requests([https://devapi.mvola.mg](https://devapi.mvola.mg) in the sandbox and [https://api.mvola.mg](https://api.mvola.mg) in production, as mentionned in the documentation) and a consumer key and a consumer secret. An optional callbackUrl can be provided, it's the url where the API send a notification whether a transaction has been successful or not.

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
    partnerName: 'name',
    partnerNumber: '0343500004',
    creditNumber: '0343500004',
    amount: 5000,
    debitNumber: '0343500003',
    description: 'short description',
);

// get the status of a transaction
var transactionStatus = await mvola.getTransactionStatus(transactionResponse.serverCorrelationId, '0343500004', 'name');

// get the detail of a transaction
var transaction = await mvola.getTransactionDetail(serverCorrelationId, "name", "0343500004");
```

In the development environment, only 0343500004 and 0343500003 can be used as merchant or customer numbers.

The complete example code can be found [here](https://github.com/tbgracy/mvola-dart/blob/main/example/mvola_example.dart) or [here](https://pub.dev/packages/mvola/example).

## Todo

* [ ] Improve documentation
* [ ] Improve error/exception responses

## Support

If you encounter any issue or want more information about this package, don't hesitate to <a href='mailto:gtsierenana@gmail.com'>email me</a> or message me on <a href="https://facebook.com/gracy.botramanagna">facebook</a> or open an issue.

## Additional information

ℹ️ This package is still in early stage of developpment. So please, don't hesitate to point out any issue or suggest an improvment.

## License

[MIT](https://choosealicense.com/licenses/mit/)

## Author

👤 **Tsierenana Botramanagna Gracy**

✉️ <a href='mailto:gtsierenana@gmail.com'>gtsierenana@gmail.com</a>
