//
//  NSObject+FCSPropertySyntax.h
//  PropertyHack
//
//  Created by Grayson Hansard on 4/26/14.
//  Copyright (c) 2014 From Concentrate Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCSProperty.h"

typedef FCSProperty *(^FCSPropertySyntaxBlock)(NSString *);

@interface NSObject (FCSPropertySyntax)

- (FCSPropertySyntaxBlock)property;

@end
