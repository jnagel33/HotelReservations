//
//  ImageResizer.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/9/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageResizer : NSObject

+(UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

@end
