#import <AppKit/AppKit.h>

static NSColor *color(unsigned rgb, CGFloat alpha) {
    return [NSColor colorWithCalibratedRed:((rgb>>16)&255)/255.0 green:((rgb>>8)&255)/255.0 blue:(rgb&255)/255.0 alpha:alpha];
}
static void text(NSString *value, NSRect box, CGFloat size, BOOL bold, NSColor *ink) {
    NSFont *font=[NSFont monospacedSystemFontOfSize:size weight:bold?NSFontWeightSemibold:NSFontWeightRegular];
    [value drawInRect:box withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:ink}];
}
int main(int argc,const char **argv) { @autoreleasepool {
    if(argc!=3)return 2;
    NSData *input=[NSData dataWithContentsOfFile:@(argv[1])];
    NSDictionary *data=[NSJSONSerialization JSONObjectWithData:input options:0 error:nil];
    if(!data)return 2;
    const CGFloat width=820,height=250,left=220,cell=32;
    NSBitmapImageRep *image=[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:width*2 pixelsHigh:height*2 bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
    [NSGraphicsContext saveGraphicsState];
    NSGraphicsContext *bitmapContext=[NSGraphicsContext graphicsContextWithBitmapImageRep:image];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithCGContext:bitmapContext.CGContext flipped:YES]];
    NSAffineTransform *retina=[NSAffineTransform transform];[retina scaleBy:2];[retina concat];
    NSAffineTransform *flip=[NSAffineTransform transform];[flip translateXBy:0 yBy:height];[flip scaleXBy:1 yBy:-1];[flip concat];
    [color(0x202026,1) setFill];NSRectFill(NSMakeRect(0,0,width,height));
    text(@"World clock · compared with Lima",NSMakeRect(18,8,650,20),12,YES,color(0xcac8a8,1));
    NSArray *rows=data[@"rows"];
    for(NSUInteger row=0;row<rows.count;row++) {
        NSDictionary *entry=rows[row]; CGFloat y=38+row*68;
        text(entry[@"name"],NSMakeRect(18,y+4,198,20),13,YES,color(0xd5d4bc,1));
        text(entry[@"detail"],NSMakeRect(18,y+27,198,18),11,NO,color(0x929388,1));
        NSArray *hours=entry[@"hours"];
        for(NSUInteger col=0;col<hours.count;col++) {
            NSDictionary *hour=hours[col];int h=[hour[@"hour"] intValue];CGFloat x=left+col*cell;
            unsigned fill=(h>=9&&h<18)?0x555651:(h>=6&&h<22)?0x343438:0x28282e;
            [color(fill,1) setFill];[[NSBezierPath bezierPathWithRoundedRect:NSMakeRect(x,y,cell-2,56) xRadius:4 yRadius:4] fill];
            text([NSString stringWithFormat:@"%02d",h],NSMakeRect(x+7,y+12,24,18),11,NO,color(0xd5d4bc,1));
            if(h==0)text(hour[@"date"],NSMakeRect(x+3,y+34,29,16),8,NO,color(0x929388,1));
        }
    }
    CGFloat now=left+[data[@"nowColumn"] doubleValue]*cell;
    [color(0xcac8a8,1) setStroke];NSBezierPath *line=[NSBezierPath bezierPath];[line moveToPoint:NSMakePoint(now,30)];[line lineToPoint:NSMakePoint(now,234)];[line setLineWidth:2];[line stroke];
    text(@"Now",NSMakeRect(now-10,10,34,17),10,YES,color(0xcac8a8,1));
    [NSGraphicsContext restoreGraphicsState];
    NSData *png=[image representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
    return [png writeToFile:@(argv[2]) atomically:YES]?0:2;
} }
