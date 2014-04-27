//
//  FCSPropertyChangingInformation.h
//  PropertyHack
//
//  Created by Grayson Hansard on 4/26/14.
//  Copyright (c) 2014 From Concentrate Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCSPropertyChangingInformation : NSObject

@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, strong) id observingObject;
@property (nonatomic, strong) id changingObject;
@property (nonatomic, strong) id originalValue;
@property (nonatomic, strong, getter = theNewValue) id newValue;
@property (nonatomic, strong) NSIndexSet *indexes;

+ (instancetype)informationWithKeyPath:(NSString *)keyPath observingObject:(id)observingObject changingObject:(id)changingObject changeDictionary:(NSDictionary *)changeDictionary;
- (id)initWithKeyPath:(NSString *)keyPath observingObject:(id)observingObject changingObject:(id)changingObject changeDictionary:(NSDictionary *)changeDictionary;

@end
