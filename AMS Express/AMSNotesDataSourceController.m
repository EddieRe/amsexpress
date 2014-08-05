//
//  AMSNotesDataSourceController.m
//  AMS Express
//
//  Created by Colin on 7/30/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSNotesDataSourceController.h"

#import "AMSNotesWebViewController.h"
#import "SavedPDF.h"

@implementation AMSNotesDataSourceController

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.hasParsedLinks) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    
    if (self.hasParsedLinks && section == 0) return self.links.count;
    else return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.hasParsedLinks && section == 0) return @"PDFs on page";
    else return @"Saved PDFs";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell
    cell.textLabel.font = [UIFont fontWithName:@"Heiti TC" size:12];
    [self configureCell:cell atIndexPath:indexPath];
   
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.hasParsedLinks && [indexPath section] == 0) return NO;
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SavedPDF *savedPDF = [self fetchedResultObjectAtIndexPath:indexPath];
        
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:savedPDF.localURL error:&error];
        [self.managedObjectContext deleteObject:savedPDF];        
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (self.hasParsedLinks && [indexPath section] == 0) {
        NSArray *anchorParts = self.links[indexPath.row];
        cell.textLabel.text = anchorParts[0];
        if ([self.delegate dataSourceController:self shouldMarkCellForAnchorParts:anchorParts]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        SavedPDF *savedPDF = [self fetchedResultObjectAtIndexPath:indexPath];
        cell.textLabel.text = savedPDF.name;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - HTML Parser delegate
- (void)htmlParser:(AMSNotesHTMLParser *)htmlParser didFinishParsingWithLinks:(NSArray *)links
{
    self.links = links;
    NSLog(@"%@", self.links);
    [self.tableView reloadData];
    [self.delegate dataSourceController:self didResetLinksWithResult:self.hasParsedLinks];
}

#pragma mark - Convenience methods
- (BOOL)hasParsedLinks
{
    if (self.links == nil) {
        self.links = @[];
    }
    
    if ([self.links isEqualToArray:@[]]) return NO;
    else return YES;
}

- (SavedPDF *)fetchedResultObjectAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger indexPathArray[2];
    indexPathArray[0] = 0;
    indexPathArray[1] = indexPath.row;
    NSIndexPath *correctedIndexPath = [NSIndexPath indexPathWithIndexes:indexPathArray length:2];
    
    return [self.fetchedResultsController objectAtIndexPath:correctedIndexPath];
}


#pragma mark - Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SavedPDF" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:30];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *dateSavedSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[dateSavedSortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"AMSNotesDataSourceController"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
//{
//    [self.tableView beginUpdates];
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
//           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
//{
//    switch(type) {
//        case NSFetchedResultsChangeInsert:
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
//       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
//      newIndexPath:(NSIndexPath *)newIndexPath
//{
//    UITableView *tableView = self.tableView;
//    
//    switch(type) {
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//            break;
//            
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
//{
//    [self.tableView reloadData];
//    [self.tableView endUpdates];
//}

 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
 }
 

@end
