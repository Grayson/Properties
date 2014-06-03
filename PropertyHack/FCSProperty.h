//
//  FCSProperty.h
//  PropertyHack
//
//  Created by Grayson Hansard on 4/26/14.
//  Copyright (c) 2014 From Concentrate Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCSPropertyChangingInformation.h"

typedef void (^FCSPropertyObservationBlock)(FCSPropertyChangingInformation *);
typedef id (^FCSPropertyObservationRegistrationBlock)(FCSPropertyObservationBlock);
typedef BOOL (^FCSPropertyObservationRemovalBlock)(id);

@interface FCSProperty : NSObject

+ (instancetype)propertyWithObject:(id)object property:(NSString *)propertyName;
- (id)initWithObject:(id)object property:(NSString *)propertyName;

@property (nonatomic, readonly) FCSPropertyObservationRegistrationBlock onDidChange;
@property (nonatomic, readonly) FCSPropertyObservationRegistrationBlock onWillChange;
@property (nonatomic, readonly) FCSPropertyObservationRemovalBlock remove;

- (void)removeObservationsForObject:(id)object;

@end
