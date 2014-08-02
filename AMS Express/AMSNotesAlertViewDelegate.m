//
//  AMSNotesAlertViewDelegate.m
//  AMS Express
//
//  Created by Colin on 8/2/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSNotesAlertViewDelegate.h"

#import "AMSNotesMasterViewController.h"
#import "SavedPDF.h"

@implementation AMSNotesAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    } else {
        NSArray *selectedLinks = self.masterVC.selectedLinks;
        self.masterVC.selectedLinks = [[NSMutableArray alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = [paths objectAtIndex:0];
        NSString *pdfFolder = [basePath stringByAppendingString:@"/PDFs/"];
        [self instantiateDirectoryAtPath:pdfFolder];
        
        NSManagedObjectContext *context = self.managedObjectContext;
        
        NSMutableArray *savedPDFs = [[NSMutableArray alloc] init];
        
        for (NSArray *anchorParts in selectedLinks) {
            SavedPDF *savedPDF = [NSEntityDescription insertNewObjectForEntityForName:@"SavedPDF" inManagedObjectContext:context];
            
            savedPDF.name = anchorParts[0];
            NSString *localPath = [pdfFolder stringByAppendingString:anchorParts[0]];
            savedPDF.localURL = localPath;
            savedPDF.webURL = anchorParts[1];
            savedPDF.dateSaved = [NSDate date];
            
            [savedPDFs addObject:savedPDF];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            for (SavedPDF *savedPDF in savedPDFs) {
                NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:savedPDF.webURL]];
                [pdfData writeToFile:savedPDF.localURL atomically:NO];
            }
            
            NSError *error = nil;
            if (![context save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.masterVC.tableView reloadData];
                [self downloadCompleteAlert];
            });
        });
    }
}

- (void)downloadCompleteAlert
{
    UIAlertView *downloadAlert = [[UIAlertView alloc] initWithTitle:@"Download Successful!"
                                                            message:@"Your download is complete and your PDFs are now available offline!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
    [downloadAlert show];
}

- (void)instantiateDirectoryAtPath:(NSString *)path
{
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error) {
        NSLog(@"%@, %@", error, [error userInfo]);
    }
}

@end
