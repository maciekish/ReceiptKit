//
//  ReceiptKit.h
//  ReceiptKit
//
//  Created by Maciej Swic on 2012-07-14.
//  Copyright (c) 2012 Appulize. All rights reserved.
//

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
