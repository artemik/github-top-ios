//
//  ViewController.h
//  first
//
//  Created by Admin on 04.05.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
  @property (nonatomic, strong) IBOutlet UITableView *tableView;
  @property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;
  @property (nonatomic, strong) IBOutlet UIButton *loadButton;
  @property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@end

