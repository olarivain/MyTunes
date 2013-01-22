//
//  MYTContentEditViewController.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//
#import <MediaManagement/MMContent.h>
#import "MYTEditViewController.h"

@interface MYTEditViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (strong, nonatomic) IBOutlet UIPickerView *typePicker;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousItemButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextItemButton;
@property (strong, nonatomic) IBOutlet UIToolbar *contentInputAccessoryView;

@property (strong, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *typeField;
@property (weak, nonatomic) IBOutlet UITextField *showField;
@property (weak, nonatomic) IBOutlet UITextField *seasonField;
@property (weak, nonatomic) IBOutlet UITextField *episodeField;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *fields;

@property (strong, nonatomic) UIView *currentEditView;

@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic, readwrite) MMContent *previousContent;

@end

@implementation MYTEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.currentIndex = [self.contentList indexOfObject: self.content];
    [self updateNextPreviousButtons];

    // add the initial edit view to the scene
    UIView *theView = [self loadEditView];
    [self.view addSubview: theView];
    self.currentEditView = theView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managing the edit view
- (void) presentNextContentItem: (BOOL) forward {
    UIView *theView = [self loadEditView];
    // add the new view to the main view
    [self.view addSubview: theView];
    
    // apply the relevant transforms for the transition
    CGFloat width = self.currentEditView.frame.size.width;
    CGFloat direction = forward ? 1.0f : -1.0f;
    CGAffineTransform newViewTransform = CGAffineTransformMakeTranslation( direction * width, 0.0f);
    theView.transform = newViewTransform;

    //then animate both together
    KCVoidBlock animation = ^{
        theView.transform = CGAffineTransformIdentity;
        self.currentEditView.transform = CGAffineTransformMakeTranslation(-direction * width, 0.0f);
    };
    // don't forget to swap views out when done
    KCCompletionBlock completion = ^(BOOL finished) {
        [self.currentEditView removeFromSuperview];
        self.currentEditView = theView;
    };
    [UIView animateWithDuration: SHORT_ANIMATION_DURATION
                     animations: animation
                     completion:completion];
}

- (UIView *) loadEditView {
    // load the righ nib
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *nibName = self.content.kind == MOVIE ? @"MYTMovieEditViewController" : @"MYTTVShowEditViewController";
    [bundle loadNibNamed: [KCNibUtils nibName: nibName]
                   owner: self
                 options: nil];
    UIView *view = self.editView;
    self.editView = nil;
    
    // size appropriately
    CGRect frame = view.frame;
    frame.origin = CGPointZero;
    frame.size = self.view.frame.size;
    view.frame = frame;
    
    // set up input view/accesory views
    for(UITextField *field in self.fields) {
		field.inputAccessoryView = self.contentInputAccessoryView;
	}
	self.typeField.inputView = self.typePicker;
    
    // fill the content
    self.nameField.text = self.content.name;
    self.typeField.text = self.content.kindHumanReadable;
    self.showField.text = self.content.show;
    self.seasonField.text = [self.content.season nonZeroStringValue];
    self.episodeField.text = [self.content.episodeNumber nonZeroStringValue];
    
    return view;
}

#pragma mark - managing toolbar buttons
- (void) updateNextPreviousButtons {
    self.previousItemButton.enabled = self.currentIndex > 0;
    self.nextItemButton.enabled = self.currentIndex < (self.contentList.count - 1);
}

#pragma mark - Actions
- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated: YES
							 completion:nil];
}

- (IBAction)done:(id)sender {
	[self dismissViewControllerAnimated: YES
							 completion:nil];
}

- (IBAction) confirmAndEditNextItem:(id)sender {
    // get the next item
    self.previousContent = self.content;
    self.currentIndex += 1;
    self.content = [self.contentList boundSafeObjectAtIndex: self.currentIndex];
    
    // present it
    [self presentNextContentItem: YES];
    
    // and update the bar buttons
    [self updateNextPreviousButtons];
}

- (IBAction) confirmAndEditPreviousItem:(id)sender {
    self.previousContent = self.content;
    self.currentIndex -= 1;
    self.content = [self.contentList boundSafeObjectAtIndex: self.currentIndex];
    
    [self presentNextContentItem: NO];
    
    // and update the bar buttons
    [self updateNextPreviousButtons];
}

#pragma mark - TextField Delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	NSInteger index = [self.fields indexOfObject: textField];
	UITextField *next = [self.fields boundSafeObjectAtIndex: index + 1];
	[next becomeFirstResponder];
	
	return YES;
}

#pragma mark - Picker data source
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 2;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return row == 0 ? @"Movie" : @"TV Show";
}

@end
