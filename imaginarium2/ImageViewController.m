//
//  ImageViewController.m
//  imaginarium2
//
//  Created by Andres Kwan on 12/2/14.
//  Copyright (c) 2014 Kwan Castle. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIImage * image;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
 
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image; // does not change the frame of the UIImageView
    [self.imageView sizeToFit];   // update the frame of the UIImageView
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
//    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]]; // blocks main queue!
    [self startDownloadingImage];
}

#pragma mark - Multithreading
- (void)startDownloadingImage
{
    self.image = nil;
    
    if (self.imageURL) {
        NSURLRequest * request = [NSURLRequest requestWithURL:self.imageURL];
        
        //background task to handle the download
        // another configuration option is backgroundSessionConfiguration (multitasking API required though)
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        // create the session without specifying a queue to run completion handler on (thus, not main queue)
        // we also don't specify a delegate (since completion handler is all we need)
        NSURLSession * session = [NSURLSession sessionWithConfiguration:config];
//                                                                       delegate:nil
//                                                                  delegateQueue:nil];
        
        NSURLSessionDownloadTask * task = [session downloadTaskWithRequest:request
         completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
             //what happend when done?
             if (!error) {
                 //take in count time!!!
                 //what about if the user ask for another picture?
                 if ([request.URL isEqual:self.imageURL]) {
                     //No in the main queue
                     UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                     //this should happen in the main thread
                     //                         dispatch_async(dispatch_get_main_queue(), ^{self.image = image;});
                     //another way to do it
                     [self performSelectorOnMainThread:@selector(setImage:)
                                            withObject:image
                                         waitUntilDone:NO];
                     
                 }
             }
         }];
        [task resume];
    }
}

@end
