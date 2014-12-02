//
//  ImageViewController.h
//  imaginarium2
//
//  Created by Andres Kwan on 12/2/14.
//  Copyright (c) 2014 Kwan Castle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

// Model for this MVC ... URL of an image to display
@property (nonatomic, strong) NSURL *imageURL;

@end
