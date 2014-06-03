//
//  FCSPropertyChangingInformation.h
//  PropertyHack
//
//  Created by Grayson Hansard on 4/26/14.
//  Copyright (c) 2014 From Concentrate Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCSPropertyChangingInformation : NSObject

@property (nonatomic, readonly, copy) NSString *keyPath;
@property (nonatomic, readonly) id observingObject;
@property (nonatomic, readonly) id changingObject;
@property (nonatomic, readonly) id originalValue;
@property (nonatomic, readonly, getter = theNewValue) id newValue;
@property (nonatomic, readonly) NSIndexSet *indexes;

+ (instancetype)informationWithKeyPath:(NSString *)keyPath observingObject:(id)observingObject changingObject:(id)changingObject changeDictionary:(NSDictionary *)changeDictionary;
- (id)initWithKeyPath:(NSString *)keyPath observingObject:(id)observingObject changingObject:(id)changingObject changeDictionary:(NSDictionary *)changeDictionary;

@end
