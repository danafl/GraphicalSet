//
//  SetCardView.m
//  set
//
//  Created by Dana Fleischer on 04/09/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView()
@property (strong,nonatomic) UIColor *background;
@end


@implementation SetCardView


#pragma mark - Properties

- (UIColor *)background{
  if(!_background)
  {
    _background = [UIColor whiteColor];
  }
  return _background;
}


- (void)setSymbol:(NSString *)symbol {
  _symbol = symbol;
  [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading {
  _shading = shading;
  [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color {
  _color = color;
  [self setNeedsDisplay];
}

- (void)setNumber:(NSString *)number {
  _number = number;
  [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{

  if(_selected != selected) {
    if(selected) {
      self.background = [UIColor yellowColor];
    } else {
      self.background = [UIColor whiteColor];
    }
    _selected = selected;
    [self setNeedsDisplay];
  }
}


#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }


- (void)drawRect:(CGRect)rect
{

  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];

  [roundedRect addClip];

  [self.background setFill];
  UIRectFill(self.bounds);

  [[UIColor blackColor] setStroke];
  [roundedRect stroke];

  // TODO:(Dana) Draw cards
  if(self.faceUp)
  {
    [self drawCorners];
  } else {
    [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
  }

}

- (void)pushContextAndRotateUpsideDown
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
  CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - Corners

- (void)drawCorners
{
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;

  UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];

  NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", self.symbol, self.number] attributes:@{ NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle }];

  CGRect textBounds;
  textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
  textBounds.size = [cornerText size];
  [cornerText drawInRect:textBounds];

  [self pushContextAndRotateUpsideDown];
  [cornerText drawInRect:textBounds];
  [self popContext];
}


#pragma mark - Initialization

- (void)setup
{
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
  [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  [self setup];
  return self;
}




	

@end
