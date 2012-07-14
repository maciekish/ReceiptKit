//
//  APViewController.m
//  ReceiptKit
//
//  Created by Maciej Swic on 2012-07-14.
//  Copyright (c) 2012 Appulize. All rights reserved.
//

#import "APAppDelegate.h"

#import "APViewController.h"

@interface APViewController ()

@end

@implementation APViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)purchaseReceiptKitConsumable:(id)sender {
    [(APAppDelegate *)[[UIApplication sharedApplication] delegate] purchase:@"ReceiptKitConsumable"];
}

@end
