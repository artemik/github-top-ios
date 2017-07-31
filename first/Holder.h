//
//  Holder.h
//  first
//
//  Created by Admin on 06.05.17.
//  Copyright © 2017 Admin. All rights reserved.
//

@interface Holder : NSObject

-(id) init;
@property(nonatomic, readwrite) NSString* name;
@property(nonatomic, readwrite) NSString* description;
@property(nonatomic, readwrite) NSString* url;
@property(nonatomic, readwrite) int stars;
@property(nonatomic, readwrite) int forks;

@end

