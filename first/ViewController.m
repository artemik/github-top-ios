//
//  ViewController.m
//  first
//
//  Created by Admin on 04.05.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "Holder.h"

@interface ViewController ()

@end

@implementation ViewController

NSMutableArray  *tableData;

NSURLSessionDataTask *loadingTask;

int counter = 0; // For fake lost internet connection testing.

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    tableData = [NSMutableArray new];
    [self downloadJson];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 80;
    
    static NSString *simpleTableIdentifier = @"simpleTableCell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    Holder* holder = [tableData objectAtIndex:indexPath.row];
    cell.nameLabel.text = holder.name;
    cell.descriptionLabel.text = holder.description;
    cell.urlTextView.text = holder.url;
    cell.starsLabel.text = [NSString stringWithFormat:@"%d", holder.stars];
    cell.forksLabel.text = [NSString stringWithFormat:@"%d", holder.forks];
    
    return cell;
}

-(void)downloadJson {
    [self setLoadingInProgress:YES];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *today = [dateFormat stringFromDate:[NSDate date]];
    NSLog(@"Today: %@", today);
    
    NSString *serverAddress = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=created:%@&sort=watchers_count", today];

    counter++;
    if (counter % 3 == 0) {
	// Simulate error by specifiyng an invalid URL.
        serverAddress = @"https://api.giERRORthub.com/search/repositories?q=created:2017-05-05&sort=watchers_count";
    }
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:serverAddress] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        if (!error) {
            NSString *json =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"GitHub Response : %@", json);
        
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSArray *repositories = [responseDic objectForKey:@"items"];
        
            [tableData removeAllObjects];
            [repositories enumerateObjectsUsingBlock:^(NSDictionary *repository, NSUInteger idx, BOOL *stop) {
                NSString *name = [repository objectForKey:@"name"];
                NSString *description = [repository objectForKey:@"description"];
                NSString *url = [repository objectForKey:@"html_url"];
                int stars = [[repository objectForKey:@"watchers"] intValue];
                int forks = [[repository objectForKey:@"forks"] intValue];
                
                Holder *holder = [[Holder alloc] init];
                holder.name = name;
                holder.description = description;
                holder.url = url;
                holder.stars = stars;
                holder.forks = forks;
                [tableData addObject:holder];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self scrollToTop];
                [self setLoadingInProgress:NO];
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
            });
        } else {
            NSLog(@"GitHub Response Error: %@", error);
            
            if (error.code != -999) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setLoadingInProgress:NO];
                    
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ERROR", @"Message") message:NSLocalizedString(@"LOAD_FAILED", @"Message") preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"TRY_AGAIN", @"Message") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        [self downloadJson];
                    }];
                    
                    UIAlertAction* noButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"CLOSE", @"Message") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        //Handle close.
                    }];
                    
                    [alert addAction:noButton];
                    [alert addAction:yesButton];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }
        }
    }];
    
    loadingTask = task;
    [loadingTask resume];
}

-(void)scrollToTop {
    if ([tableData count] != 0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)stopLoading {
    [loadingTask cancel];
    [self setLoadingInProgress:NO];
}

-(void)setLoadingInProgress:(BOOL)inProgress {
    self.loadButton.hidden = inProgress;
    self.cancelButton.hidden = !inProgress;
    
    if (inProgress) {
        [self.indicator startAnimating];
    } else {
        [self.indicator stopAnimating];
    }
}

- (IBAction)onLoadClick:(id)sender {
    [self downloadJson];
}


- (IBAction)onCancelClick:(id)sender {
    [self stopLoading];
}

@end
