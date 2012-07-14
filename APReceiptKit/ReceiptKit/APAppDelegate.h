//
//  APAppDelegate.h
//  ReceiptKit
//
//  Created by Maciej Swic on 2012-07-14.
//  Copyright (c) 2012 Appulize. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>

#import "libReceiptKit/ReceiptKit.h"

@class APViewController;

@interface APAppDelegate : UIResponder <UIApplicationDelegate, SKRequestDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, ReceiptKitDelegate> {
    id skProduct;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) APViewController *viewController;

- (void)purchase:(NSString *)productIdentifier;

@end
