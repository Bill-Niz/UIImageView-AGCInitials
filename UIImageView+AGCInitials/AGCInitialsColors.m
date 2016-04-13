//
//  Created by Andrea Cipriani on 07/04/16.
//
//

#import "AGCInitialsColors.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AGCInitialsColors ()

@property (nonatomic, strong) NSMutableDictionary<NSString*, UIColor*>* cachedColorsForStrings;

@end

@implementation AGCInitialsColors

+ (id _Nonnull)sharedInstance
{
    static AGCInitialsColors* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithDefaultColorPalette];
    });
    return sharedInstance;
}

- (instancetype)initWithDefaultColorPalette
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _colorPalette = [self defaultColorPalette];
    _cachedColorsForStrings = [NSMutableDictionary new];
    return self;
}

- (NSArray<UIColor*>*)defaultColorPalette
{
    return @[UIColorFromRGB(0x6200EA),UIColorFromRGB(0xC51162),UIColorFromRGB(0x304FFE),UIColorFromRGB(0x2962FF),UIColorFromRGB(0x00BFA5),UIColorFromRGB(0xd50000),UIColorFromRGB(0x00C853),UIColorFromRGB(0x64DD17),UIColorFromRGB(0x00B8D4),UIColorFromRGB(0x827717),UIColorFromRGB(0xFFD600),UIColorFromRGB(0xDD2C00),UIColorFromRGB(0x37474F),UIColorFromRGB(0xBF360C),UIColorFromRGB(0x004D40),UIColorFromRGB(0xe53935),UIColorFromRGB(0x0091EA)];
}

- (void)setPalette:(NSArray<UIColor*>*)colorPalette
{
    _colorPalette = colorPalette;
}

- (UIColor* _Nonnull)colorForString:(NSString*)string
{
    if (string == nil){
        string = @"";
    }
    if ([self cachedColorForString:string]) {
        return [self cachedColorForString:string];
    }
    
    unsigned long hashNumber = djb2StringToLong((unsigned char*)[string UTF8String]);
    UIColor* color = _colorPalette[hashNumber % [_colorPalette count]];
    _cachedColorsForStrings[string] = color;
    return color;
}

-(UIColor*)cachedColorForString:(NSString*)string
{
    return _cachedColorsForStrings[string];
}

/*
 http://www.cse.yorku.ca/~oz/hash.html djb2 algorithm to generate an unsigned long hash from a given string
 
 Attention, this method could return different values on differente architectures for the same string
 */
unsigned long djb2StringToLong(unsigned char* str)
{
    unsigned long hash = 5381;
    int c;
    while ((c = *str++)){
        hash = ((hash << 5) + hash) + c;
    }
    return hash;
}

@end
