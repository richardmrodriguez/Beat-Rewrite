//
//  BeatLockButton.m
//  Beat
//
//  Created by Lauri-Matti Parppei on 16.7.2021.
//  Copyright © 2021 KAPITAN!. All rights reserved.
//

#import "BeatLockButton.h"
#import <QuartzCore/QuartzCore.h>

#define FADE_TIME 4.0
#define LOCKED_LABEL @"Document is locked"
#define UNLOCK_LABEL @"Click to unlock"

@interface BeatLockButton ()
@property (nonatomic, weak) IBOutlet NSImageView *image;
@property (nonatomic, weak) IBOutlet NSTextField *label;
@property (nonatomic) CAShapeLayer *shapeLayer;
@property (nonatomic) CALayer *backgroundLayer;
@property (nonatomic) bool mouseOver;
@property (nonatomic) NSTimer *fadeTimer;
@property (nonatomic) IBOutlet id target;
@end

@implementation BeatLockButton


- (void)setupLayer {
	self.wantsLayer = YES;
	
	_backgroundLayer = [CALayer layer];

	_backgroundLayer.cornerRadius = self.frame.size.height / 2;
	_backgroundLayer.backgroundColor = [NSColor.grayColor colorWithAlphaComponent:.9].CGColor;
	_backgroundLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	_backgroundLayer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
	[self.layer addSublayer:_backgroundLayer];
	
	//NSAffineTransform *transform =  [NSAffineTransform transform];
	_shapeLayer = [CAShapeLayer layer];
	CGRect rect = CGRectMake(0, 0, self.frame.size.height - 6, self.frame.size.height - 6);
	CGPathRef path = CGPathCreateWithEllipseInRect(rect, nil);
		
	_shapeLayer.fillColor = NSColor.darkGrayColor.CGColor;
	_shapeLayer.path = path;
	_shapeLayer.bounds = CGRectMake(0,0, rect.size.width, rect.size.height);
	_shapeLayer.position = CGPointMake(rect.size.height / 2 + 3 , rect.size.height / 2 + 3);
	
	[self.layer addSublayer:_shapeLayer];
	CGPathRelease(path);
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}

-(void)updateTrackingAreas
{
	[super updateTrackingAreas];
	for (NSTrackingArea *area in self.trackingAreas) {
		[self removeTrackingArea:area];
	}

	NSInteger opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
	NSTrackingArea *trackingArea = trackingArea = [[NSTrackingArea alloc]initWithRect:(NSRect){ 0, 0, self.frame.size.width, self.frame.size.height } options:opts owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
}

-(void)mouseEntered:(NSEvent *)event {
	self.label.stringValue = UNLOCK_LABEL;
	_shapeLayer.fillColor = NSColor.blackColor.CGColor;
	_image.image = [NSImage imageNamed:NSImageNameLockUnlockedTemplate];
	
	[self displayLabel];
	[self startTimer];
}
-(void)mouseExited:(NSEvent *)event {
	self.label.stringValue = LOCKED_LABEL;
	_shapeLayer.fillColor = NSColor.darkGrayColor.CGColor;
	_image.image = [NSImage imageNamed:NSImageNameLockLockedTemplate];
	
	[self startTimer];
}

-(void)show {
	if (!_shapeLayer) [self setupLayer];
	
	self.hidden = NO;
	[self.label.animator setAlphaValue:1.0];
	self.backgroundLayer.opacity = 1.0;
	[self startTimer];
}
-(void)hide {
	self.hidden = YES;
}

-(void)displayLabel {
	[self.label.animator setAlphaValue:1.0];
	_backgroundLayer.opacity = 1.0;
	[self startTimer];
}
-(void)hideLabel {
	[self.label.animator setAlphaValue:0.0];
	_backgroundLayer.opacity = 0;
}
-(void)startTimer {
	[_fadeTimer invalidate];
	_fadeTimer = [NSTimer scheduledTimerWithTimeInterval:FADE_TIME repeats:NO block:^(NSTimer * _Nonnull timer) {
		[self hideLabel];
	}];
}
-(void)mouseUp:(NSEvent *)event {
	[NSApp sendAction:@selector(unlock) to:self.target from:self];
}
-(void)unlock {}

@end
/*
 
 Ymmärtääkö elämä
 meissä sittenkään itseään
 emmekö me laukausta pistoolin edessämme vieläkään nää
 Olemmeko kuin eksyneet lampaat
 jotka paimenta etsien niityllä käyvät
 Oliko Jeesus Kristus yksi heistä
 vaiko ainoastaan
 yksi meistä
 
 */
