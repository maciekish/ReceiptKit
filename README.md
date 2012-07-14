ReceiptKit
==========

ReceiptKit provides an easy way to verify iOS receipts without having to involve your own server.

Synchronous Usage
-----------------

1. Get the project using git as JSONKit is configured as a submodule.

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

* This is just an easier way for the masses to check receipts, and a direct response to all the IAP hacks available. This is not the safest method of checking receipts, and you should use your own server if you want to be even safer.