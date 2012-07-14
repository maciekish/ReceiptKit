//
//  ReceiptKit.h
//  ReceiptKit
//
//  Created by Maciej Swic on 2012-07-14.
//  ReceiptKit is licensed under the MIT license.
//  Copyright (c) 2012 Appulize
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h>

//To enable logging, change the next line to #ifdef DEBUG
#ifdef _DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] ReceiptKit: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

#define kProductionURL [NSURL URLWithString:@"http://buy.itunes.apple.com/verifyReceipt"]
#define kSandboxURL [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"]

typedef enum {
    ReceiptKitReceiptStatusVerified,
    ReceiptKitReceiptStatusInvalid
} ReceiptKitReceiptStatus;

@protocol ReceiptKitDelegate <NSObject>

- (void)receiptKitResponseForReceipt:(SKPaymentTransaction *)transaction status:(ReceiptKitReceiptStatus)status;

@end

@interface ReceiptKit : NSObject

+ (id)sharedReceipts;

+ (void)verifyPaymentTransaction:(SKPaymentTransaction *)transaction withDelegate:(id<ReceiptKitDelegate>)delegate;
+ (BOOL)verifyPaymentTransactionSynchronously:(SKPaymentTransaction *)transaction;

@end
