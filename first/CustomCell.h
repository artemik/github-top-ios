//
//  CustomCell.h
//  first
//
//  Created by Admin on 04.05.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
    @property (nonatomic, weak) IBOutlet UILabel *nameLabel;
    @property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
    @property (nonatomic, weak) IBOutlet UITextView *urlTextView;
    @property (nonatomic, weak) IBOutlet UILabel *starsLabel;
    @property (nonatomic, weak) IBOutlet UILabel *forksLabel;
@end
