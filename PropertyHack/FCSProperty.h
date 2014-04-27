//
//  FCSProperty.h
//  PropertyHack
//
//  Created by Grayson Hansard on 4/26/14.
//  Copyright (c) 2014 From Concentrate Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCSPropertyChangingInformation.h"

typedef void (^FCSPropertyBlock)(FCSPropertyChangingInformation *information);

@interface FCSProperty : NSObject

+ (instancetype)propertyWithObject:(id)object property:(NSString *)propertyName;
- (id)initWithObject:(id)object property:(NSString *)propertyName;

@property (nonatomic, copy) FCSPropertyBlock willChange;
@property (nonatomic, copy) FCSPropertyBlock didChange;

- (void)removeObservationsForObject:(id)object;

@end
