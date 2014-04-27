//
//  FCSPropertyChangingInformation.m
//  PropertyHack
//
//  Created by Grayson Hansard on 4/26/14.
//  Copyright (c) 2014 From Concentrate Software. All rights reserved.
//

#import "FCSPropertyChangingInformation.h"

@implementation FCSPropertyChangingInformation

+ (instancetype)informationWithKeyPath:(NSString *)keyPath observingObject:(id)observingObject changingObject:(id)changingObject changeDictionary:(NSDictionary *)changeDictionary
{
	return [[[self class] alloc] initWithKeyPath:keyPath observingObject:observingObject changingObject:changingObject changeDictionary:changeDictionary];
}

- (id)initWithKeyPath:(NSString *)keyPath observingObject:(id)observingObject changingObject:(id)changingObject changeDictionary:(NSDictionary *)changeDictionary
{
	if ((self = [self init]) == nil)
		return nil;
	
	self.keyPath = keyPath;
	self.observingObject = observingObject;
	self.changingObject = changingObject;
	self.originalValue = changeDictionary[NSKeyValueChangeOldKey];
	self.newValue = changeDictionary[NSKeyValueChangeNewKey];
	self.indexes = changeDictionary[NSKeyValueChangeIndexesKey];
	
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@\n\tkeyPath: %@\n\tobserving: %@\n\tchanging: %@\n\toriginal: %@\n\tnew: %@\n\tindexes: %@>", [self class], self.keyPath, self.observingObject, self.changingObject, self.originalValue, self.newValue, self.indexes];
}

@end
