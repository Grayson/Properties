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
	FCSPropertyBlock _willChangeBlock;
	FCSPropertyBlock _didChangeBlock;
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
	if ([change[NSKeyValueChangeNotificationIsPriorKey] boolValue] == YES && self.willChange != nil)
		self.willChange(information);
	else if (self.didChange != nil)
		self.didChange(information);
}

- (FCSPropertyBlock)willChange
{
	return _willChangeBlock;
}

- (void)setWillChange:(FCSPropertyBlock)willChange
{
	if (_willChangeBlock != nil)
	{
		__weak FCSPropertyBlock oldBlock = _willChangeBlock;
		_willChangeBlock = [^(FCSPropertyChangingInformation *info) { willChange(info); oldBlock(info); } copy];
	}
	else
	{
		_willChangeBlock = willChange;
	}
}

- (FCSPropertyBlock)didChange
{
	return  _didChangeBlock;
}

- (void)setDidChange:(FCSPropertyBlock)didChange
{
	if (_didChangeBlock != nil)
	{
		__weak FCSPropertyBlock oldBlock = _didChangeBlock;
		_didChangeBlock = [^(FCSPropertyChangingInformation *info) { didChange(info); oldBlock(info); } copy];
	}
	else
	{
		_didChangeBlock = didChange;
	}
}

@end
