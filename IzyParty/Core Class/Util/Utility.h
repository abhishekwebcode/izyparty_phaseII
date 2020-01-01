//
//  Utility.h
//  Fisseha
//
//  Created by Manveer Dodiya on 01/04/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

+(UIColor*)colorWithHexString:(NSString*)hex;

+(void)setupButtonStyle:(UIButton*)btn;

+(void)setTextFieldStyle:(UITextField*)txt;
+(void)setupViewStyle:(UIView*)view;

+(void)setTextFieldPaddingStyle:(UITextField*)txtfield;


+ (BOOL)validateEmailWithString:(NSString*)emailtext;

+(void)Alert:(NSString *)Message andTitle:(NSString *)Title andController:(UIViewController*)objController;



+(NSString *)getTimeFromDate:(NSString*)strCreateDate;

+ (NSString*)base64forData:(NSData*)theData;

+(NSString *)GetTimeStamp;



+(NSString *)GetDocumentDirectory;
+(void) checkAndCreateDatabase;



@end
