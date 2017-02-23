//
//  ViewController.h
//  ResumeAndDownloadNSUrlSession
//
//  Created by Nagam Pawan on 10/3/16.
//  Copyright © 2016 Nagam Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLSessionDownloadDelegate, NSURLSessionDelegate>{
    NSURLSession *_session;
}
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSData *resumeData;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *resumeButton;

- (IBAction)cancel:(id)sender;
- (IBAction)resume:(id)sender;

@end

