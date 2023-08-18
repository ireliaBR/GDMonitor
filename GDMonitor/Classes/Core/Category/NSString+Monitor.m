//
//  NSString+Monitor.m
//  GDMonitor
//
//  Created by fdd on 2023/8/18.
//

#import "NSString+Monitor.h"

@interface NSMutableString (Replacement)
- (void)replaceOccurencesOfString:(NSString *)string with:(NSString *)replacement;
- (void)removeLastKeyPathComponent;
@end

@implementation NSMutableString (Replacement)

- (void)replaceOccurencesOfString:(NSString *)string with:(NSString *)replacement {
    [self replaceOccurrencesOfString:string withString:replacement options:0 range:NSMakeRange(0, self.length)];
}

- (void)removeLastKeyPathComponent {
    if (![self containsString:@"."]) {
        [self deleteCharactersInRange:NSMakeRange(0, self.length)];
        return;
    }

    BOOL putEscapesBack = NO;
    if ([self containsString:@"\\."]) {
        [self replaceOccurencesOfString:@"\\." with:@"\\~"];

        // Case like "UIKit\.framework"
        if (![self containsString:@"."]) {
            [self deleteCharactersInRange:NSMakeRange(0, self.length)];
            return;
        }

        putEscapesBack = YES;
    }

    // Case like "Bund" or "Bundle.cla"
    if (![self hasSuffix:@"."]) {
        NSUInteger len = self.pathExtension.length;
        [self deleteCharactersInRange:NSMakeRange(self.length-len, len)];
    }

    if (putEscapesBack) {
        [self replaceOccurencesOfString:@"\\~" with:@"\\."];
    }
}

@end

@implementation NSString (GDTypeEncoding)

- (NSCharacterSet *)gd_classNameAllowedCharactersSet {
    static NSCharacterSet *classNameAllowedCharactersSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *temp = NSMutableCharacterSet.alphanumericCharacterSet;
        [temp addCharactersInString:@"_"];
        classNameAllowedCharactersSet = temp.copy;
    });
    
    return classNameAllowedCharactersSet;
}

- (BOOL)gd_typeIsConst {
    if (!self.length) return NO;
    return [self characterAtIndex:0] == GDTypeEncodingConst;
}

- (GDTypeEncoding)gd_firstNonConstType {
    if (!self.length) return GDTypeEncodingNull;
    return [self characterAtIndex:(self.gd_typeIsConst ? 1 : 0)];
}

- (GDTypeEncoding)gd_pointeeType {
    if (!self.length) return GDTypeEncodingNull;
    
    if (self.gd_firstNonConstType == GDTypeEncodingPointer) {
        return [self characterAtIndex:(self.gd_typeIsConst ? 2 : 1)];
    }
    
    return GDTypeEncodingNull;
}

- (BOOL)gd_typeIsObjectOrClass {
    GDTypeEncoding type = self.gd_firstNonConstType;
    return type == GDTypeEncodingObjcObject || type == GDTypeEncodingObjcClass;
}

- (Class)gd_typeClass {
    if (!self.gd_typeIsObjectOrClass) {
        return nil;
    }
    
    NSScanner *scan = [NSScanner scannerWithString:self];
    // Skip const
    [scan scanString:@"r" intoString:nil];
    // Scan leading @"
    if (![scan scanString:@"@\"" intoString:nil]) {
        return nil;
    }
    
    // Scan class name
    NSString *name = nil;
    if (![scan scanCharactersFromSet:self.gd_classNameAllowedCharactersSet intoString:&name]) {
        return nil;
    }
    // Scan trailing quote
    if (![scan scanString:@"\"" intoString:nil]) {
        return nil;
    }
    
    // Return found class
    return NSClassFromString(name);
}

- (BOOL)gd_typeIsNonObjcPointer {
    GDTypeEncoding type = self.gd_firstNonConstType;
    return type == GDTypeEncodingPointer ||
           type == GDTypeEncodingCString ||
           type == GDTypeEncodingSelector;
}

@end

@implementation NSString (KeyPaths)

- (NSString *)gd_stringByRemovingLastKeyPathComponent {
    if (![self containsString:@"."]) {
        return @"";
    }

    NSMutableString *mself = self.mutableCopy;
    [mself removeLastKeyPathComponent];
    return mself;
}

- (NSString *)gd_stringByReplacingLastKeyPathComponent:(NSString *)replacement {
    // replacement should not have any escaped '.' in it,
    // so we escape all '.'
    if ([replacement containsString:@"."]) {
        replacement = [replacement stringByReplacingOccurrencesOfString:@"." withString:@"\\."];
    }

    // Case like "Foo"
    if (![self containsString:@"."]) {
        return [replacement stringByAppendingString:@"."];
    }

    NSMutableString *mself = self.mutableCopy;
    [mself removeLastKeyPathComponent];
    [mself appendString:replacement];
    [mself appendString:@"."];
    return mself;
}

@end
