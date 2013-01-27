//
//  MYTContentEditViewController.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//
#import <KraCommons/NSNumber+String.h>
#import <KraCommons/KCInputViewController.h>
#import <KraCommons/UIImage+Stretchable.h>

#import <MediaManagement/MMContent.h>

#import "MYTEditViewController.h"

#import "MYTLibraryStore.h"

@interface MYTEditViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (strong, nonatomic) IBOutlet UIPickerView *typePicker;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousItemButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextItemButton;
@property (strong, nonatomic) IBOutlet UIToolbar *contentInputAccessoryView;

@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet KCInputViewController *inputVIewController;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeField;
@property (weak, nonatomic) IBOutlet UITextField *showField;
@property (weak, nonatomic) IBOutlet UITextField *seasonField;
@property (weak, nonatomic) IBOutlet UITextField *episodeField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContentView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UIImageView *descriptionBackground;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *fields;

@property (weak, nonatomic) IBOutlet UIView *activityShield;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIView *currentEditView;

@property (strong, nonatomic, readwrite) MMContent *content;
@property (strong, nonatomic, readwrite) MMContent *previousContent;
@property (strong, nonatomic, readwrite) NSMutableSet *pendingContent;

@end

@implementation MYTEditViewController

#pragma mark - view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Edit";
    
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.content = [self.contentList boundSafeObjectAtIndex: self.index];
    [self updateNextPreviousButtons];
    
    // add the initial edit view to the scene
    UIView *theView = [self loadEditView];
    [self.scrollContentView addSubview: theView];
    self.currentEditView = theView;
    
    self.pendingContent = [NSMutableSet setWithCapacity: self.contentList.count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Synthetic getters/setter
- (void) setContentList:(NSArray *)contentList {
    NSMutableArray *copiedList = [NSMutableArray arrayWithCapacity: contentList.count];
    
    for(MMContent *content in contentList) {
        [copiedList addObjectNilSafe: [content deepCopy]];
    }
    _contentList = copiedList;
}

#pragma mark - Managing the edit view
- (void) presentNextContentItem: (BOOL) forward {
    [self advanceContentItem: forward];
    // before we destroy our fields array with a new one, compute the index of the first responder, if any
    UIView *currentResponder = [self.view kc_findFirstResponder];
    NSInteger responderIndex = [self.fields indexOfObject: currentResponder];
    
    UIView *theView = [self loadEditView];
    // add the new view to the main view
    [self.scrollContentView addSubview: theView];
    
    // apply the relevant transforms for the transition
    CGFloat width = self.scrollContentView.frame.size.width;
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
        if(!finished) {
            return ;
        }
		UITextField *newResponder = [self.fields boundSafeObjectAtIndex: responderIndex];
        [newResponder becomeFirstResponder];
		[self.inputVIewController makeFirstResponderVisible];
		
        [self.currentEditView removeFromSuperview];
        self.currentEditView = theView;
    };
    [UIView animateWithDuration: MEDIUM_ANIMATION_DURATION
                     animations: animation
                     completion:completion];
}

- (void) advanceContentItem: (BOOL) forward {
	NSInteger directionFactor = forward ? 1 : -1;
	self.previousContent = self.content;
    self.index += directionFactor;
    self.content = [self.contentList boundSafeObjectAtIndex: self.index];
	
	// we had a show before, prefill the elements of the next with the same content
	if(self.previousContent.kind == TV_SHOW) {
		self.content.kind = TV_SHOW;
        
		if (self.content.show.length == 0) {
			self.content.show = self.previousContent.show;
		}
		
		if(self.content.season == nil) {
			self.content.season = [self.previousContent.season copy];
		}
		
		if(self.content.episodeNumber == nil && self.previousContent.episodeNumber != nil) {
			self.content.episodeNumber = [NSNumber numberWithInteger: self.previousContent.episodeNumber.intValue + directionFactor];
		}
	}
}

- (UIView *) loadEditView {
    // load the righ nib
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *nibName = self.content.kind == MOVIE ? @"MYTMovieEditViewController" : @"MYTTVShowEditViewController";
    [bundle loadNibNamed: nibName
                   owner: self
                 options: nil];
    UIView *view = self.editView;
    self.editView = nil;
	
    self.inputVIewController.textInputFields = self.fields;
    self.descriptionBackground.image = [self.descriptionBackground.image stretchableImageWithDefaultCaps];
    
    // size appropriately
    CGRect frame = view.frame;
    frame.origin = CGPointZero;
    frame.size.width = self.scrollContentView.frame.size.width;
    view.frame = frame;
    self.scrollContentView.contentSize = view.frame.size;
    
    // set up input view/accesory views
	for(UITextView *field in self.fields) {
		field.inputAccessoryView = self.contentInputAccessoryView;
	}
    
    // fill the content
    self.nameField.text = self.content.name;
    self.typeField.selectedSegmentIndex = self.content.kind;
    
    self.showField.text = self.content.show;
    self.seasonField.text = [self.content.season stringValue];
    self.episodeField.text = [self.content.episodeNumber stringValue];
    self.descriptionField.text = self.content.description;
    
    return view;
}

#pragma mark - managing toolbar buttons
- (void) updateNextPreviousButtons {
    self.previousItemButton.enabled = self.index > 0;
    self.nextItemButton.enabled = self.index < (self.contentList.count - 1);
}

#pragma mark - Actions
- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated: YES
							 completion: ^{
                                 InvokeBlock(self.dismissBlock, NO);
                             }];
}

- (IBAction)done:(id)sender {
    [self copyBackToContent];
    
    // resign the responder
    [self.view kc_findAndResignFirstResponder];
    
    self.activityShield.hidden = NO;
    [self.activityIndicator startAnimating];
    
    MYTLibraryStore *store = [MYTLibraryStore sharedInstance];
    [store saveContentList: self.pendingContent
                  callback:^(NSError *error) {
                      [self didSave: error];
                  }];
}

- (void) didSave: (NSError *) error {
    [self.activityIndicator stopAnimating];
    self.activityShield.hidden = YES;
    
    if([error present]) {
        return;
    }
    
    [self dismissViewControllerAnimated: YES
							 completion:^{
                                 InvokeBlock(self.dismissBlock, YES);
                             }];
}

- (IBAction) confirmAndEditNextItem:(id)sender {
    [self copyBackToContent];
    
    // present it
    [self presentNextContentItem: YES];
    
    // and update the bar buttons
    [self updateNextPreviousButtons];
}

- (IBAction) confirmAndEditPreviousItem:(id)sender {
    [self copyBackToContent];
    
    // present it
    [self presentNextContentItem: NO];
    
    // and update the bar buttons
    [self updateNextPreviousButtons];
}

- (IBAction) changeType:(id)sender {
    self.content.kind = self.typeField.selectedSegmentIndex;
    
    UIView *view = [self loadEditView];
    [UIView transitionFromView: self.currentEditView
                        toView: view
                      duration: SHORT_ANIMATION_DURATION
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    completion: ^(BOOL finished) {
                        self.currentEditView = view;
                    }];
}

- (void) copyBackToContent {
    // copy items back into the content object
    self.content.name = self.nameField.text;
    self.content.show = self.showField.text;
    self.content.episodeNumber = [NSNumber numberFromString: self.episodeField.text];
    self.content.season = [NSNumber numberFromString: self.seasonField.text];
    self.content.description = self.descriptionField.text;
    self.content.kind = self.typeField.selectedSegmentIndex;
    
    [self.pendingContent addObjectNilSafe: self.content];
}

#pragma mark - TextField Delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	NSInteger index = [self.fields indexOfObject: textField];
	UITextField *next = [self.fields boundSafeObjectAtIndex: index + 1];
	[next becomeFirstResponder];
	
	return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [self.inputVIewController makeFirstResponderVisible];
}

@end
