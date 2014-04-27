//
//  NSObject+FCSPropertySyntax.m
//  PropertyHack
//
//  Created by Grayson Hansard on 4/26/14.
//  Copyright (c) 2014 From Concentrate Software. All rights reserved.
//

#import "NSObject+FCSPropertySyntax.h"
#import <objc/runtime.h>
#import "JRSwizzle.h"

static void * kAssociatedPropertyDictionaryKey = &kAssociatedPropertyDictionaryKey;

@implementation NSObject (FCSPropertySyntax)

+ (void)load
{
	NSError *error = nil;
	[self jr_swizzleMethod:@selector(dealloc) withMethod:@selector(FCSPropertySyntax_dealloc) error:&error];
	NSAssert1(error == nil, @"Error swizzling -dealloc.\n%@", error);
}

- (void)FCSPropertySyntax_dealloc
{
	NSMutableDictionary *dictionary = objc_getAssociatedObject(self, kAssociatedPropertyDictionaryKey);
	for (FCSProperty *property in [dictionary allValues])
		[property removeObservationsForObject:self];
	[self FCSPropertySyntax_dealloc];
}

- (FCSPropertySyntaxBlock)property
{
	return [[^(NSString *propertyName){
		NSMutableDictionary *dictionary = objc_getAssociatedObject(self, kAssociatedPropertyDictionaryKey);
		
		if (dictionary == nil)
		{
			dictionary = [NSMutableDictionary dictionary];
			objc_setAssociatedObject(self, kAssociatedPropertyDictionaryKey, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		}
		
		FCSProperty *property = dictionary[propertyName];
		if (property == nil)
		{
			property = [FCSProperty propertyWithObject:self property:propertyName];
			[dictionary setObject:property forKey:propertyName];
		}
		
		return property;
	} copy] autorelease];
}

@end
