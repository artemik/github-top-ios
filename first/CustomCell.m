//
//  CustomCell.m
//  first
//
//  Created by Admin on 04.05.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize nameLabel = _nameLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize urlTextView = _urlTextView;
@synthesize starsLabel = _starsLabel;
@synthesize forksLabel = _forksLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
