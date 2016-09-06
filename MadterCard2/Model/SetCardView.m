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
#define MAX_NUMBER_OF_SYMBOLS 3

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }


- (void)drawRect:(CGRect)rect
{

  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                         cornerRadius:[self cornerRadius]];

  [roundedRect addClip];

  [self.background setFill];
  UIRectFill(self.bounds);

  [[UIColor blackColor] setStroke];
  [roundedRect stroke];

  if(self.faceUp)
  {

    [[self getColorOfSymbol] set];
    for(int i = 0; i < [self getNumberOfSymbols]; i++){
      CGRect rectToDrawIn = [self rectOfSymbelAtIndex:i];
      [self drawSymbol:rectToDrawIn];
    }




  } else {
    [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
  }

}


- (void)drawDiamond:(CGRect)rectToDrawIn{
  UIBezierPath *path = [[UIBezierPath alloc]init];
  int xMiddle = rectToDrawIn.size.width / 2;
  int yMiddle = rectToDrawIn.size.height / 2;
  int xOrigin = rectToDrawIn.origin.x;
  int yOrigin = rectToDrawIn.origin.y;

  [path moveToPoint:CGPointMake(xOrigin + xMiddle, yOrigin + (0.5*yMiddle))];
  [path addLineToPoint:CGPointMake(xOrigin + (1.5*xMiddle), yOrigin + yMiddle)];
  [path addLineToPoint:CGPointMake(xOrigin + xMiddle, yOrigin + (1.5*yMiddle))];
  [path addLineToPoint:CGPointMake(xOrigin + 0.5*xMiddle, yOrigin + yMiddle)];
  [path closePath];
  [self fillSymbolWithShading:path];
  [path stroke];
}


- (void)drawOval:(CGRect)rectToDrawIn{
  int width = rectToDrawIn.size.width;
  int height = rectToDrawIn.size.height;
  UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rectToDrawIn.origin.x + 10,
                                                                         rectToDrawIn.origin.y + 10,
                                                                         (width -20), (height-20))];
  [self fillSymbolWithShading:path];
  [path stroke];
}

- (void)drawSquiggle :(CGRect)rectToDrawIn{
  UIBezierPath *path = [[UIBezierPath alloc]init];
  int xOrigin = rectToDrawIn.origin.x;
  int yOrigin = rectToDrawIn.origin.y;
  int width = rectToDrawIn.size.width;
  int height = rectToDrawIn.size.height;

  [path moveToPoint:CGPointMake(xOrigin + width*0.05, yOrigin + height*0.40)];

  [path addCurveToPoint:CGPointMake(xOrigin + width*0.35, yOrigin + height*0.25)
          controlPoint1:CGPointMake(xOrigin + width*0.09, yOrigin + height*0.15)
          controlPoint2:CGPointMake(xOrigin + width*0.18, yOrigin + height*0.10)];

  [path addCurveToPoint:CGPointMake(xOrigin + width*0.75, yOrigin + height*0.30)
          controlPoint1:CGPointMake(xOrigin + width*0.40, yOrigin + height*0.30)
          controlPoint2:CGPointMake(xOrigin + width*0.60, yOrigin + height*0.45)];

  [path addCurveToPoint:CGPointMake(xOrigin + width*0.97, yOrigin + height*0.35)
          controlPoint1:CGPointMake(xOrigin + width*0.87, yOrigin + height*0.15)
          controlPoint2:CGPointMake(xOrigin + width*0.98, yOrigin + height*0.00)];

  [path addCurveToPoint:CGPointMake(xOrigin + width*0.45, yOrigin + height*0.85)
          controlPoint1:CGPointMake(xOrigin + width*0.95, yOrigin + height*1.10)
          controlPoint2:CGPointMake(xOrigin + width*0.50, yOrigin + height*0.95)];

  [path addCurveToPoint:CGPointMake(xOrigin + width*0.25, yOrigin + height*0.85)
          controlPoint1:CGPointMake(xOrigin + width*0.40, yOrigin + height*0.80)
          controlPoint2:CGPointMake(xOrigin + width*0.35, yOrigin + height*0.75)];

  [path addCurveToPoint:CGPointMake(xOrigin + width*0.05, yOrigin + height*0.40)
          controlPoint1:CGPointMake(xOrigin + width*0.00, yOrigin + height*1.10)
          controlPoint2:CGPointMake(xOrigin + width*0.005, yOrigin + height*0.60)];
  [path closePath];
  [self fillSymbolWithShading:path];
  [path stroke];
}


- (void)pushContextAndRotateUpsideDown {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
  CGContextRotateCTM(context, M_PI);
}

- (void)popContext {
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - Corners

- (void)drawCorners {
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;

  UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];

  NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:
                                    [NSString stringWithFormat:@"%@\n%@", self.color,
                                     self.number] attributes:@{ NSFontAttributeName : cornerFont,
                                                                NSParagraphStyleAttributeName :
                                                                  paragraphStyle }];

  CGRect textBounds;
  textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
  textBounds.size = [cornerText size];
  [cornerText drawInRect:textBounds];

  [self pushContextAndRotateUpsideDown];
  [cornerText drawInRect:textBounds];
  [self popContext];
}


#pragma mark - Initialization

- (void)setup {
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
  [self setup];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  [self setup];
  return self;
}

- (NSUInteger)getNumberOfSymbols {
  return [self.number intValue];
}

- (UIColor *)getColorOfSymbol {
  NSDictionary *colorDict = @{@"red" : [UIColor redColor],
                              @"green" : [UIColor greenColor],
                              @"purple" : [UIColor purpleColor]};
  return colorDict[self.color];
}

- (void)drawSymbol:(CGRect)rectToDrawIn {
  if ([self.symbol isEqualToString:@"▲"]) {
    [self drawDiamond:rectToDrawIn];
  } else if ([self.symbol isEqualToString:@"◼︎"]) {
    [self drawSquiggle:rectToDrawIn];
  } else {
    [self drawOval:rectToDrawIn];
  }
}

- (void)fillSymbolWithShading:(UIBezierPath *)path {
  if ([self.shading isEqualToString:@"solid"]) {
    [path fill];
  } else if ([self.shading isEqualToString:@"striped"]) {
    UIBezierPath *stripes = [UIBezierPath bezierPath];
    for ( int x = 0; x < self.bounds.size.width; x += 2)
    {
      [stripes moveToPoint:CGPointMake( self.bounds.origin.x + x, self.bounds.origin.y )];
      [stripes addLineToPoint:CGPointMake( self.bounds.origin.x + x,
                                          self.bounds.origin.y + self.bounds.size.height)];
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [path addClip];
    [stripes stroke];
    CGContextRestoreGState(context);
  }
}

- (CGRect)rectOfSymbelAtIndex:(NSUInteger)symbolIndex {
  int xOrigin = self.bounds.origin.x;
  int xWidth = self.bounds.size.width;

  int yHeight = self.bounds.size.height / MAX_NUMBER_OF_SYMBOLS;
  unsigned long yOriginOfFirstSymbol = (((MAX_NUMBER_OF_SYMBOLS) -
                                         [self getNumberOfSymbols])*yHeight)/2;
  unsigned long yDiffFromFirst = symbolIndex*yHeight;
  unsigned long yOrigin = yOriginOfFirstSymbol + yDiffFromFirst;

  return CGRectMake(xOrigin, yOrigin, xWidth, yHeight);
}














	

@end
