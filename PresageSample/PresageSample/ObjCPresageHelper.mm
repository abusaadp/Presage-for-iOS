//
//  NSObject+ObjCPresageHelper.m
//  Custom-KeyBoard
//
//  Created by Abu Saad Papa on 04/08/15.
//  Copyright (c) 2015 ILabs. All rights reserved.
//

#import "ObjCPresageHelper.h"
#include "presage.h"

class ExampleCallback : public PresageCallback
{
public:
    ExampleCallback(const std::string _past_context, const std::string& path) {
        set_stream(_past_context);
        filePath = path;
    }
    
    std::string get_past_stream() const { return past_context; }
    std::string get_future_stream() const { return empty; }
    void set_stream(const std::string context) { past_context = context; }
    
private:
    std::string past_context;
    const std::string empty;
    
    
};

@interface ObjCPresageHelper()
@property (nonatomic, readonly) Presage* presage;
@property (nonatomic, readonly) ExampleCallback* callback;
@end

@implementation ObjCPresageHelper {
NSString *context;
}

- (void)createAndCheckDatabase:(NSString *) filePath
{
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:filePath];
    
    if (success) return;
    
    NSString *filePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db"];
    
    [fileManager copyItemAtPath:filePathFromApp toPath:filePath error:nil];
}

- (id)init
{
    self = [super init];
    if (self) {
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [documentPaths objectAtIndex:0];
        NSString *dictPath = [documentDir stringByAppendingPathComponent:@"db"];
        
        [self createAndCheckDatabase:dictPath];
        
        context = @"sample";
        _callback = new ExampleCallback (context.UTF8String,dictPath.UTF8String);
        _presage = new Presage(_callback);
    }
    return self;
}

-(NSArray *)getSuggesstionsForWord:(NSString *) word
{
    NSMutableArray *result;
    std::vector< std::string > predictions;
    _callback->set_stream(word.UTF8String);
    
    // request prediction
    predictions = _presage->predict ();
    NSInteger count = predictions.size();
    
    if (count) {
        result = [[NSMutableArray alloc] initWithCapacity:count];
        for (int i = 0; i < count; i++) {
            NSString *nsSuggestion = [[NSString alloc] initWithCString:predictions[i].c_str()
                                                              encoding:NSUTF8StringEncoding];
            if (nsSuggestion == NULL) {
                NSLog(@"Failed to convert [%s] to NSString", predictions[i].c_str());
            }else{
                [result addObject:nsSuggestion];
            }
        }
    } else {
        result = [NSMutableArray array];
    }
    
    return result;
}



@end
