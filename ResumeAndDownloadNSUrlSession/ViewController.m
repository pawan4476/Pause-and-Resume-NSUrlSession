//
//  ViewController.m
//  ResumeAndDownloadNSUrlSession
//
//  Created by Nagam Pawan on 10/3/16.
//  Copyright © 2016 Nagam Pawan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(NSURLSession *)session {
    
    if (!_session) {
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
        
    }
    
    return _session;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:@"http://cdn.tutsplus.com/mobile/uploads/2014/01/5a3f1-sample.jpg"]];
    [self.downloadTask resume];
    [self addObserver:self forKeyPath:@"resumeData" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"downloadTask" options:NSKeyValueObservingOptionNew context:NULL];
    [self.cancelButton setHidden:YES];
    [self.resumeButton setHidden:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)resume:(id)sender {
    
    if (!self.resumeData) return;
    [self.resumeButton setHidden:YES];
    [self.cancelButton setHidden:NO];
    self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    [self.downloadTask resume];
    [self setResumeData:nil];
    
}


- (IBAction)cancel:(id)sender {
    
    if (!self.downloadTask) return;
    [self.cancelButton setHidden:YES];
    [self.resumeButton setHidden:NO];
    [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData){
        if (!resumeData) return;
        [self setResumeData:resumeData];
        [self setDownloadTask:nil];
        
    }];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"resumeData"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.resumeButton setHidden:(self.resumeData == nil)];
            
        });
        
    } else if ([keyPath isEqualToString:@"downloadTask"]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.cancelButton setHidden:(self.downloadTask == nil)];
            
        });
        
    }
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSData *data = [NSData dataWithContentsOfURL:location];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.cancelButton setHidden:YES];
        [self.resumeButton setHidden:YES];
        [self.progressView setHidden:YES];
        [self.imageView setImage:[UIImage imageWithData:data]];
        
    });
    
    [session finishTasksAndInvalidate];
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    float progress = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.progressView setProgress:progress];
        [self.cancelButton setHidden:NO];
        
    });
    
}
@end
