//
//  AMSNotesDataSourceController.h
//  AMS Express
//
//  Created by Colin on 7/30/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMSNotesHTMLParser.h"

@class AMSNotesDataSourceController, SavedPDF;

@protocol AMSNotesDataSourceControllerDelegate <NSObject>

- (void)dataSourceController:(AMSNotesDataSourceController *)dataSourceController didResetLinksWithResult:(BOOL)result;
- (BOOL)dataSourceController:(AMSNotesDataSourceController *)dataSourceController shouldMarkCellForAnchorParts:(NSArray *)anchorParts;

@end

@class AMSNotesMasterViewController;

@interface AMSNotesDataSourceController : NSObject <NSFetchedResultsControllerDelegate, UITableViewDataSource, AMSNotesHTMLParserDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UINavigationController *detailNavigationVC;
@property (nonatomic, strong) NSArray *links;
@property id <AMSNotesDataSourceControllerDelegate> delegate;

- (BOOL)hasParsedLinks;
- (SavedPDF *)fetchedResultObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
