//
//  FCSProperty.m
//  PropertyHack
//
//  Created by Grayson Hansard on 4/26/14.
//  Copyright (c) 2014 From Concentrate Software. All rights reserved.
//

#import "FCSProperty.h"

@interface FCSProperty ()
@property (nonatomic, weak) id object;
@property (nonatomic, copy) NSString *propertyName;
@end

void *kObservationContext = &kObservationContext;

@implementation FCSProperty
{
@private
	NSMutableDictionary *_didChangeBlocks;
	NSMutableDictionary *_willChangeBlocks;
}

+ (instancetype)propertyWithObject:(id)object property:(NSString *)propertyName
{
	return [[[self class] alloc] initWithObject:object property:propertyName];
}

- (id)initWithObject:(id)object property:(NSString *)propertyName
{
	if ((self = [self init]) == nil)
		return nil;
	
	self.object = object;
	self.propertyName = propertyName;
	
	_didChangeBlocks = [NSMutableDictionary dictionary];
	_willChangeBlocks = [NSMutableDictionary dictionary];
	
	[object addObserver:self forKeyPath:propertyName options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:kObservationContext];
	
	return self;
}

- (void)removeObservationsForObject:(id)object
{
	[object removeObserver:self forKeyPath:self.propertyName];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context != kObservationContext || object != self.object || ![keyPath isEqual:self.propertyName])
		return;

	FCSPropertyChangingInformation *information = [FCSPropertyChangingInformation informationWithKeyPath:keyPath observingObject:nil changingObject:self.object changeDictionary:change];
	
	if ([change[NSKeyValueChangeNotificationIsPriorKey] boolValue])
		[_willChangeBlocks enumerateKeysAndObjectsUsingBlock:^(id key, FCSPropertyObservationBlock block, BOOL *stop) { block(information); }];
	else
		[_didChangeBlocks enumerateKeysAndObjectsUsingBlock:^(id key, FCSPropertyObservationBlock block, BOOL *stop) { block(information); }];
}

- (FCSPropertyObservationRegistrationBlock)onDidChange
{
	return ^(FCSPropertyObservationBlock observer)
	{
		NSUUID *uuid = [NSUUID UUID];
		[_didChangeBlocks setObject:observer forKey:uuid];
		return uuid;
	};
}

- (FCSPropertyObservationRegistrationBlock)onWillChange
{
	return ^(FCSPropertyObservationBlock observer)
	{
		NSUUID *uuid = [NSUUID UUID];
		[_willChangeBlocks setObject:observer forKey:uuid];
		return uuid;
	};
}

- (FCSPropertyObservationRemovalBlock)remove
{
	return ^(id identifier)
	{
		BOOL didRemove;
		if ((didRemove = ([_didChangeBlocks objectForKey:identifier] != nil)))
			[_didChangeBlocks removeObjectForKey:identifier];
		if (!didRemove && (didRemove = [_willChangeBlocks objectForKey:identifier] != nil))
			[_willChangeBlocks removeObjectForKey:identifier];
		return didRemove;
	};
}

@end
