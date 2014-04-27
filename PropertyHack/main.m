//
//  main.m
//  PropertyHack
//
//  Created by Grayson Hansard on 4/26/14.
//  Copyright (c) 2014 From Concentrate Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestObject.h"
#import "NSObject+FCSPropertySyntax.h"

int main(int argc, const char * argv[])
{

	@autoreleasepool {
	    
		TestObject *object = [TestObject new];
		object.property(@"content").didChange = ^(FCSPropertyChangingInformation *info){
			NSLog(@"%@: Did change", info);
		};
		
		object.property(@"content").didChange = ^(FCSPropertyChangingInformation *info){
			NSLog(@"%@: Did change yet again!", info);
		};
		
		object.property(@"content").willChange = ^(FCSPropertyChangingInformation *info){
			NSLog(@"%@: Will change", info);
		};
		
		object.content = @(YES);
		object.content = @(NO);
	    
	}
    return 0;
}

