//
//  NWPickerField.m
//  NWFieldPicker
//
//  Created by Scott Andrew on 9/25/09.
//  Copyright 2009 NewWaveDigitalMedia. All rights reserved.
//
//  This source code is provided under BSD license, the conditions of which are listed below. 
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted 
//  provided that the following conditions are met:
//
//  • Redistributions of source code must retain the above copyright notice, this list of 
//   conditions and the following disclaimer.
//  • Redistributions in binary form must reproduce the above copyright notice, this list of conditions
//   and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  • Neither the name of Positive Spin Media nor the names of its contributors may be used to endorse or 
//   promote products derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
//  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY 
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
//  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
//  DAMAGE.

#import "NWPickerField.h"
#import "NWPickerView.h"
#import "NSString+NSArrayExtension.h"
NSString* UIPickerViewBoundsUserInfoKey = @"UIPickerViewBoundsUserInfoKey";
NSString* UIPickerViewWillShownNotification = @"UIPickerViewWillShownNotification";
NSString* UIPickerViewDidShowNotification = @"UIPickerViewDidShowNotification";
NSString* UIPickerViewWillHideNotification = @"UIPickerViewWillHideNotification";
NSString* UIPickerViewDidHideNotification = @"UIPickerViewDidHideNotification";



@implementation NWPickerField

@synthesize delegate;
@synthesize formatString;
@synthesize selected_row;
@synthesize pickerToolbar;
@synthesize nextPreviousControl;
@synthesize picker;
@synthesize componentStrings;

- (BOOL)canBecomeFirstResponder {
	return YES;
	
}
-(void) hide{
	pickerview.hidden=YES;
}

-(BOOL) becomeFirstResponder {
	// we will toggle our view here. This allows us to react properly 
    // when in a table cell.
    if (pickerview.hidden)
        [pickerview toggle];
	
	[pickerview reloadAllComponents];
    return YES;
}



-(void) didMoveToSuperview {
	// lets create a hidden picker view.
	pickerview = [[NWPickerView alloc] initWithFrame:CGRectZero];
	pickerview.hidden = YES;
	pickerview.dataSource = self;
	pickerview.delegate = self;
	pickerview.showsSelectionIndicator = YES;
	pickerview.field = self;
	
	/*pickerViewPopup = [[UIActionSheet alloc] initWithTitle:@""
	 delegate:self
	 cancelButtonTitle:nil
	 destructiveButtonTitle:nil
	 otherButtonTitles:nil];
	 
	 // Add the picker
	 
	 
	 pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	 pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
	 [pickerToolbar sizeToFit];
	 
	 
	 //UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextPicker)];
	 //UIBarButtonItem *prevItem = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(prevPicker)];
	 UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	 UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closePicker:)];
	 NSArray *items = [[NSArray alloc] initWithObjects:spaceItem,doneItem, nil];
	 
	 [pickerToolbar setItems:items animated:YES];
	 //	[pickerViewPopup showInView:pickerView];
	 [pickerViewPopup setBounds:CGRectMake(0,0,320, 464)];	*/
	// lets load our indecicator image and get its size.
	CGRect bounds = self.bounds;
	UIImage* image = [UIImage imageNamed:@"downArrow.png"];
	CGSize imageSize = image.size;
	
	// create our indicator imageview and add it as a subview of our textview.
	//CGRect imageViewRect = CGRectMake((bounds.origin.x + bounds.size.width) - imageSize.width - 5, (bounds.size.height/2) - (imageSize.height/2), imageSize.width, imageSize.height);
	CGRect imageViewRect = CGRectMake((bounds.origin.x + bounds.size.width) - imageSize.width - 5, (bounds.size.height/2) - (imageSize.height/2) , imageSize.width, imageSize.height);
	//CGRect imageViewRect = CGRectMake(68,6, imageSize.width, imageSize.height);
	
	indicator = [[UIImageView alloc] initWithFrame:imageViewRect];
	[self addSubview:indicator];
	indicator.image = image;
	indicator.hidden = YES;
	
    // set our default format string.
	self.formatString = @"%@";
    
	int component = 0;
	for (component = 0; component < [pickerview numberOfComponents]; component++) 
		[self selectRow:0 inComponent:component animated:NO];
}

-(void) didMoveToWindow {
	UIWindow* appWindow = [self window];
    
    // the app window can be null when being popped off 
    // the controller stack.
	if (appWindow != nil) {
        CGRect windowBounds = [appWindow bounds];
		
        // caluclate our hidden rect.
        CGRect pickerHiddenFrame = windowBounds;
        pickerHiddenFrame.origin.y = pickerHiddenFrame.size.height+216;
        pickerHiddenFrame.size.height = 216;
		
        // calucate our visible rect
        CGRect pickerVisibleFrame = windowBounds;
        pickerVisibleFrame.origin.y = windowBounds.size.height - 216;
        pickerVisibleFrame.size.height = 216;
		
        // tell the picker view the frames.
        pickerview.hiddenFrame = pickerHiddenFrame;
        pickerview.visibleFrame = pickerVisibleFrame;
		
        // set the initial frame so its hidden.
        pickerview.frame = pickerHiddenFrame;
		
//        // add the picker view to our window so its top most like a keyboard.
//		[pickerToolbar removeFromSuperview];
//		pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//		pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
//		
//		UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closePickerDel:)];
//		UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//		
//		UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
//                                                                                 NSLocalizedString(@"Previous",@"Previous form field"),
//                                                                                 NSLocalizedString(@"Next",@"Next form field"),																				  
//                                                                                 nil]];
//        control.segmentedControlStyle = UISegmentedControlStyleBar;
//        control.tintColor = [UIColor darkGrayColor];
//        control.momentary = YES;
//        [control addTarget:self action:@selector(nextPrevious:) forControlEvents:UIControlEventValueChanged];			
//        
//        UIBarButtonItem *controlItem = [[UIBarButtonItem alloc] initWithCustomView:control];
//        self.nextPreviousControl = control;
//        
//        NSArray *items = [[NSArray alloc] initWithObjects: controlItem,flex, barButtonItem, nil];
//		[pickerToolbar setItems:items];		
//		
//		
//		[pickerview addSubview:pickerToolbar];
		//[appWindow addSubview:keyboardToolbar];
        [appWindow addSubview:pickerview];
		
		
		/*[pickerViewPopup addSubview:pickerToolbar];
		 [pickerViewPopup addSubview:pickerView];
		 [appWindow addSubview:pickerViewPopup];	*/
    }
}


-(void) pickerViewHidden:(BOOL)wasHidden {
	// hide our show our indicator when notified by the picker.
	indicator.hidden = wasHidden;
}


#pragma mark -
#pragma mark UIPickerView wrappers
#pragma mark -

-(void) selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
	
	// when selection is given then make sure we update our edit control and the picker.
	//picker selectRow: [component1Data count] * (kRowMultiplier / 2) inComponent:0 animated:NO];
	[pickerview selectRow:row inComponent:component animated:animated];
	[self pickerView:pickerview didSelectRow:row inComponent:component];
}

-(NSInteger) selectedRowInComponent:(NSInteger)component {
    return [pickerview selectedRowInComponent:component];
}

#pragma mark -
#pragma mark UIPickerViewDataSource handlers
#pragma mark -

// returns the number of 'columns' to display.
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	// we always have 1..
	NSInteger count = [delegate numberOfComponentsInPickerField:self];
	NSInteger item = 0;
	
    // if we have component strings release them.
    componentStrings = nil;    
	componentStrings = [[NSMutableArray alloc] init];
	
    // put a blank place holder in here for nothing.
	for (item = 0; item < count; item++) {
		[componentStrings addObject:@""];
	}
	
	return count;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {	
	return [delegate pickerField:self numberOfRowsInComponent:component];
}
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    return [delegate pickerView:self widthForComponent:component];
//}
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [delegate pickerField:self titleForRow:row forComponent:component];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	NSString* string = [delegate pickerField:self titleForRow:row forComponent:component];
	[componentStrings replaceObjectAtIndex:component withObject:string];
	
    // format our text representing the change in the selection.
	self.text = [NSString stringWithFormat:formatString array:componentStrings];
	//[pickerView setHidden:YES];
	self.selected_row=row;
	[delegate pickerField:self didSelectRow:row inComponent:component];
	[pickerView reloadAllComponents];
}


//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
//		  forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//	
//	UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 18)] ;
//	rowView.backgroundColor = [UIColor clearColor];
//	rowView.userInteractionEnabled = NO;
//	
//	UIImageView *checkmarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 24, 19)];
//	
//	UIFont *font = [ UIFont boldSystemFontOfSize:18];
//	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 240, 18) ];
//	
//	NSString *pickerText = [delegate pickerField:self titleForRow:row forComponent:component];
//	titleLabel.text =pickerText;
//	titleLabel.textAlignment = UITextAlignmentLeft;
//	titleLabel.backgroundColor = [UIColor clearColor];
//	titleLabel.font = font;
//	titleLabel.opaque = NO;
//	
//	//if ([selected_property_id intValue] == row) {
//	if(row==self.selected_row){
//		float rd = 39.00/255.00;
//		float gr = 81.00/255.00;
//		float bl = 133.00/255.00;
//		
//		UIColor *lblColor = [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0f];
//		
//		titleLabel.textColor = lblColor;
//		checkmarkImageView.image = [UIImage imageNamed:@"checkmark.png"];
//	}else {
//		titleLabel.textColor = [UIColor blackColor];
//		checkmarkImageView.image = nil;
//	}
//	
//	[rowView addSubview:checkmarkImageView];
//	[rowView addSubview:titleLabel];
//	
//	return rowView; 
//	
//	
//}
-(void) nextPrevious:(id)semder
{
    //int tag = self.tag;
    [[self delegate] nextPreviousPicker:semder tag:self.tag];
}
- (void) closePickerDel:(id)sender
{
	//[[self delegate]  closePicker:self];
	[self hide];
	[[self delegate] closePickerView:self];
	
}

- (void) isPickerNotified:(id)sender
{
	[[self delegate] isPickerNotif:self];
	
	
}
// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
	return CGRectInset ( bounds , 10 , 0.5);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
	return CGRectInset( bounds , 10 , 0.5 );
}
@end
