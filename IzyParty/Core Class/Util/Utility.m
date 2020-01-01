//
//  Utility.m
//  Fisseha
//
//  Created by Manveer Dodiya on 01/04/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

#import "Utility.h"
//#import "SDAVAssetExportSession.h"

#define dbName @"Lineology.db"



@implementation Utility




#pragma mark Color with Hexa String
+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    //if ([cString length] != 6) return  [UIColor grayColor];
    
    if ([cString length] == 6)
    {
        // Separate into r, g, b substrings
        NSRange range;
        range.location = 0;
        range.length = 2;
        NSString *rString = [cString substringWithRange:range];
        
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        
        
        
        // Scan values
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        
        
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:1.0f];
    }
    else
        return [UIColor grayColor];
    
}



+(void)setupButtonStyle:(UIButton*)btn
{
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = UIColor.whiteColor.CGColor;
    btn.layer.borderWidth = 2.0;
    btn.clipsToBounds =YES;
}

+(void)setupViewStyle:(UIView*)view
{
    view.layer.cornerRadius = 5;
    //view.layer.borderWidth = 0.5;
   // view.layer.borderColor = UIColor.lightGrayColor.CGColor;
    view.clipsToBounds =YES;
}


+(void)setTextFieldStyle:(UITextField*)txt
{
    txt.layer.cornerRadius = 20;
    //txt.layer.borderWidth = 1.0;
    //txt.layer.borderColor = UIColor.whiteColor.CGColor;
    txt.clipsToBounds =YES;
}


+(void)setTextFieldPaddingStyle:(UITextField*)txtfield
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    txtfield.leftView = paddingView;
    txtfield.leftViewMode = UITextFieldViewModeAlways;
}




#pragma mark- Email_validation

+ (BOOL)validateEmailWithString:(NSString*)emailtext
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailtext];
}



#pragma Mark - Alert Function

+(void)Alert:(NSString *)Message andTitle:(NSString *)Title andController:(UIViewController*)objController
{
    UIAlertController *alert_controller=[UIAlertController alertControllerWithTitle:Title message:Message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alert_action=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert_controller addAction:alert_action];
    [objController presentViewController:alert_controller animated:YES completion:nil];
}



#pragma mark - check internet connection
/*+(BOOL)checkInternetConnection
{
    
    // Reachability *reachability = [Reachability reachabilityForInternetConnection];
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus == NotReachable;
    
}*/




+(NSString *)getTimeFromDate:(NSString*)strCreateDate
{
    
    ////for date
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *createdDate=[formatter dateFromString:strCreateDate];
    NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:createdDate];
    
    if (distanceBetweenDates<60)
    {
        NSLog(@"Time %f sec",distanceBetweenDates);
        
        NSString *strTime=[NSString stringWithFormat:@"%@ sec",@((int)distanceBetweenDates).stringValue];
        return strTime;
        
    }
    else if (distanceBetweenDates>60 && distanceBetweenDates<60*60)
    {
        NSLog(@"Time %f min",distanceBetweenDates/60);
        NSString *strTime=[NSString stringWithFormat:@"%@ mi",@((int)distanceBetweenDates/60).stringValue];
        return strTime;
        
    }
    
    else if (distanceBetweenDates>60 && distanceBetweenDates<60*60*24)
    {
        NSLog(@"Time %f hr",distanceBetweenDates/(60*60));
        NSString *strTime=[NSString stringWithFormat:@"%@ Hr",@((int)distanceBetweenDates/(60*60)).stringValue];
        
        return strTime;
    }
    else
    {
        [formatter setDateFormat:@"MMM dd"];
        
        NSLog(@"Time %@ ",[formatter stringFromDate:createdDate]);
        return [formatter stringFromDate:createdDate];
    }
    
    return @"";
}






+ (NSString*)base64forData:(NSData*)theData
{
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+(NSString *)GetTimeStamp

{
    return [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
}










#pragma mark Copy Database from resource
#pragma mark Database Copy
+(NSString *)GetDocumentDirectory
{
    
    //NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    
    return homeDir;
}

+(void) checkAndCreateDatabase{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *databasePath = [[Utility GetDocumentDirectory ]stringByAppendingPathComponent:dbName];
    success = [fileManager fileExistsAtPath:databasePath];
    NSLog(@"database path %@",databasePath);
    if(success) {
        
        // ATTENTION -> Those lines will format and update DB
        
        //[fileManager removeItemAtPath:databasePath error:NULL];
        //NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"in_memo.db"];
        //[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
        NSLog(@"YES");
    }
    else
    {
        NSLog(@"NO");
        
        
        NSError *err;
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:&err];
        
        NSLog(@"Error %@", err);
    }
}










@end
