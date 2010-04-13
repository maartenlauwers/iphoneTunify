//
//  CustomImagePicker.h
//  meanPhoto
//
//  Created by lajos kamocsay on 1/10/09.
//  Copyright 2009 soymint.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomImagePicker : UIImagePickerController {
	NSTimer *previewTimer;
}

@property (nonatomic, retain) NSTimer *previewTimer;

-(void)captureButtonAction:(id)sender;

//private
-(void)inspectView: (UIView *)theView depth:(int)depth path:(NSString *)path;
-(NSString *)stringPad:(int)numPad;

@end
