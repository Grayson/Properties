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

		object.property(@"content").onDidChange(^(FCSPropertyChangingInformation *info)
		{
			NSLog(@"onDidChange\n%@", info);
		});
		
		object.property(@"content").onDidChange(^(FCSPropertyChangingInformation *info)
		{
			NSLog(@"Another did change");
		});
		
		id y = object.property(@"content").onWillChange(^(FCSPropertyChangingInformation *info)
		{
			NSLog(@"onWillChange\n%@", info);
		});
				
		object.content = @(YES);
		
		object.property(@"content").remove(y);

		object.content = @(NO);
	}
    return 0;
}

