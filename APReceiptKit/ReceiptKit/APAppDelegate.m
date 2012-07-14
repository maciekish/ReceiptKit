//
//  APAppDelegate.m
//  ReceiptKit
//
//  Created by Maciej Swic on 2012-07-14.
//  Copyright (c) 2012 Appulize. All rights reserved.
//

#import "APAppDelegate.h"

#import "APViewController.h"

@implementation APAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[APViewController alloc] initWithNibName:@"APViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[APViewController alloc] initWithNibName:@"APViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"ReceiptKitConsumable"]];
    [productRequest setDelegate:self];
    [productRequest start];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    for (SKProduct *product in [response products]) {
        skProduct = product;
        DLog(@"Product received %@", [product productIdentifier]);
    }
}

- (void)purchase:(NSString *)productIdentifier {
    DLog(@"Purchasing %@", productIdentifier);
    
    if (skProduct) {
        SKPayment *skPayment = [SKPayment paymentWithProduct:skProduct];
        [[SKPaymentQueue defaultQueue] addPayment:skPayment];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *paymentTransaction in transactions) {
        if ([paymentTransaction transactionState] == SKPaymentTransactionStatePurchased) {
            DLog(@"%@ purchased", [[paymentTransaction payment] productIdentifier]);
            [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
            
            //Asynchronous demo
            [ReceiptKit verifyPaymentTransaction:paymentTransaction withDelegate:self];
            
            /*
            //Synchronous demo
            if ([ReceiptKit verifyPaymentTransactionSynchronously:paymentTransaction]) {
                [[[UIAlertView alloc] initWithTitle:@"Verification" message:@"Receipt verified successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Verification" message:@"Receipt verification failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            */
        } else if ([paymentTransaction transactionState] == SKPaymentTransactionStateFailed){
            DLog(@"Purchased failed: %@", [paymentTransaction error]);
        }
    }
}

- (void)receiptKitResponseForReceipt:(SKPaymentTransaction *)transaction status:(ReceiptKitReceiptStatus)status {
    if (status == ReceiptKitReceiptStatusVerified) {
        [[[UIAlertView alloc] initWithTitle:@"Verification" message:@"Receipt verified successfully (async)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Verification" message:@"Receipt verification failed (async)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

@end
