//
//  ReceiptKit.m
//  ReceiptKit
//
//  Created by Maciej Swic on 2012-07-14.
//  Copyright (c) 2012 Appulize. All rights reserved.
//

#import "ReceiptKit.h"

#import "JSONKit.h"
#import "NSData+Base64.h"

@implementation ReceiptKit

+ (id)sharedReceipts {
    static ReceiptKit *sharedReceiptKit = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedReceiptKit = [[self alloc] init];
    });
    return sharedReceiptKit;
}

+ (void)verifyPaymentTransaction:(SKPaymentTransaction *)transaction withDelegate:(id<ReceiptKitDelegate>)delegate {
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        BOOL verificationResult;
        
        verificationResult = [ReceiptKit verifyPaymentTransactionSynchronously:transaction];
        
        if (verificationResult && delegate && [delegate respondsToSelector:@selector(receiptKitResponseForReceipt:status:)]) {
            [delegate receiptKitResponseForReceipt:transaction status:ReceiptKitReceiptStatusVerified];
        } else if (delegate && [delegate respondsToSelector:@selector(receiptKitResponseForReceipt:status:)]) {
            [delegate receiptKitResponseForReceipt:transaction status:ReceiptKitReceiptStatusInvalid];
        }
    });
}

//This method will verify a SKPaymentTransaction synchronously. It will verify the SKPaymentTransaction first against the production server, and if it fails with code 21007, will verify again against the sandbox server. This way, you don't need a remote server for verification, and you don't need to change the URLs when your app is in review and when launched. See Apple Technical Note TN2259 https://developer.apple.com/library/ios/#technotes/tn2259/_index.html
+ (BOOL)verifyPaymentTransactionSynchronously:(SKPaymentTransaction *)transaction {
    NSString *translatedReceipt = [ReceiptKit translateReceipt:[transaction transactionReceipt]];
    DLog(@"translatedReceipt %@", translatedReceipt);
    
    NSString *base64EncodedReceipt = [[translatedReceipt dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    DLog(@"base64EncodedReceipt %@", base64EncodedReceipt);
    
    NSString *jsonString = [[NSDictionary dictionaryWithObject:base64EncodedReceipt forKey:@"receipt-data"] JSONString];
    DLog(@"jsonString %@", jsonString);
    
    NSURLResponse *urlResponse = nil;
    NSError *error = nil;
    BOOL success = FALSE;
    int requestNumber = 0;
    
    while (!success) {
        NSMutableURLRequest *urlRequest;
        error = nil;
        urlResponse = nil;
        
        if (requestNumber > 2)
            continue;
        
        if (requestNumber == 0)
            urlRequest = [NSMutableURLRequest requestWithURL:kProductionURL];
        else
            urlRequest = [NSMutableURLRequest requestWithURL:kSandboxURL];
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:[NSString stringWithFormat:@"%d", [[jsonString dataUsingEncoding:NSUTF8StringEncoding] length]] forHTTPHeaderField:@"Content-Length"];
        [urlRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
        
        if (error)
            DLog(@"Error: %@", error);
        
        DLog(@"responseData %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        
        if (responseData) {
            NSDictionary *responseDictionary = [[JSONDecoder decoder] objectWithData:responseData];
            if ([[responseDictionary objectForKey:@"status"] intValue] == 0) {
                DLog(@"Receipt OK");
                success = TRUE;
            } else {
                DLog(@"Receipt NOT OK");
            }
        }
        
        requestNumber++;
    }
    
    return success;
}

+ (NSString *)translateReceipt:(id)receipt {
    NSString *translatedReceipt;
    
    if ([receipt isKindOfClass:[NSString class]]) {
        translatedReceipt = receipt;
        DLog(@"Received an NSString");
    } else if ([receipt isKindOfClass:[NSData class]]) {
        translatedReceipt = [[NSString alloc] initWithData:receipt encoding:NSUTF8StringEncoding];
        DLog(@"Received NSData");
    } else {
        translatedReceipt = nil;
        DLog(@"Didn't receive an NSString nor NSData");
    }
    
    return translatedReceipt;
}

@end
