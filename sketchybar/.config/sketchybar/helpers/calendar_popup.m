#import <AppKit/AppKit.h>
static NSColor *ink(unsigned n){return [NSColor colorWithCalibratedRed:((n>>16)&255)/255.0 green:((n>>8)&255)/255.0 blue:(n&255)/255.0 alpha:1];}
static void label(NSString *s,NSRect r,CGFloat size,BOOL bold,unsigned rgb){
 NSMutableParagraphStyle *style=[NSMutableParagraphStyle new];style.alignment=NSTextAlignmentCenter;
 [s drawInRect:r withAttributes:@{NSFontAttributeName:[NSFont monospacedSystemFontOfSize:size weight:bold?NSFontWeightSemibold:NSFontWeightRegular],NSForegroundColorAttributeName:ink(rgb),NSParagraphStyleAttributeName:style}];
}
int main(int argc,const char **argv){@autoreleasepool{
 if(argc!=3)return 2;
 NSDictionary *d=[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:@(argv[1])] options:0 error:nil];if(!d)return 2;
 NSArray *weeks=d[@"weeks"];CGFloat w=294,h=80+weeks.count*32;
 NSBitmapImageRep *image=[[NSBitmapImageRep alloc]initWithBitmapDataPlanes:NULL pixelsWide:w*2 pixelsHigh:h*2 bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
 [NSGraphicsContext saveGraphicsState];NSGraphicsContext *context=[NSGraphicsContext graphicsContextWithBitmapImageRep:image];
 [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithCGContext:context.CGContext flipped:YES]];
 NSAffineTransform *transform=[NSAffineTransform transform];[transform scaleBy:2];[transform translateXBy:0 yBy:h];[transform scaleXBy:1 yBy:-1];[transform concat];
 [ink(0x202026)setFill];NSRectFill(NSMakeRect(0,0,w,h));
 label(d[@"heading"],NSMakeRect(8,10,w-16,25),16,YES,0xcac8a8);
 NSArray *names=@[@"Su",@"Mo",@"Tu",@"We",@"Th",@"Fr",@"Sa"];
 for(int col=0;col<7;col++)label(names[col],NSMakeRect(14+col*38,43,38,20),11,YES,0x929388);
 for(NSUInteger row=0;row<weeks.count;row++)for(int col=0;col<7;col++){
  int day=[weeks[row][col] intValue];if(!day)continue;
  CGFloat x=14+col*38,y=68+row*32;BOOL today=day==[d[@"today"]intValue];
  if(today){[ink(0xcac8a8)setFill];[[NSBezierPath bezierPathWithRoundedRect:NSMakeRect(x+4,y-2,30,28) xRadius:7 yRadius:7]fill];}
  label([NSString stringWithFormat:@"%d",day],NSMakeRect(x,y,38,24),13,today,today?0x202026:0xd5d4bc);
 }
 [NSGraphicsContext restoreGraphicsState];
 return [[image representationUsingType:NSBitmapImageFileTypePNG properties:@{}]writeToFile:@(argv[2]) atomically:YES]?0:2;
}}
