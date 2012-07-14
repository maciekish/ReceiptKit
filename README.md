ReceiptKit
==========

ReceiptKit provides an easy way to verify iOS receipts without having to involve your own server.

Synchronous Usage
-----------------

1. Get the project using git as JSONKit is configured as a submodule, or download JSONKit manually.

2. Copy the subfolder libReceiptKit into your Xcode project.

3. Browse to your TARGET -> Build Phases -> Compile Sources. Add the Compiler Flag -fno-objc-arc to JSONKit.m as JSONKit does not support ARC.

4. Import "ReceiptKit.h" in your SKPaymentTransactionObserver class.

5. When you get the paymentQueue:updatedTransactions: callback from StoreKit, send the SKPaymentTransaction to ReceiptKit like this for synchronous operation (easiest but will slow down you app):

[ReceiptKit verifyPaymentTransactionSynchronously:paymentTransaction]

6. The above method will return TRUE if the receipt is valid, or FALSE if the receipt is invalid. 

Asynchronous Usage (Recommended)
--------------------------------

Follow the above instructions to step 4.

1. Add the <ReceiptKitDelegate> protocol to your SKPaymentTransactionObserver class.

2. Implement the receiptKitResponseForReceipt:status method in the same class.

3. When you get the paymentQueue:updatedTransactions: callback from StoreKit, send the SKPaymentTransaction to ReceiptKit like this for asynchronous operation:

[ReceiptKit verifyPaymentTransaction:paymentTransaction withDelegate:self];

4. When ReceiptKit is done processing the receipt, it will call your delegates receiptKitResponseForReceipt:status with the status being either ReceiptKitReceiptStatusVerified or ReceiptKitReceiptStatusInvalid.


Details
-------

* ReceiptKit has been tested on iOS 5 and iOS 6 but should work on iOS 4 as well.

License
-------

ReceiptKit is licensed under the MIT license.

Copyright (c) 2012 Appulize

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.