//
//  GDRuntimeConstants.h
//  GDMonitor
//
//  Created by fdd on 2023/8/18.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define GDEncodeClass(class) ("@\"" #class "\"")
#define GDEncodeObject(obj) (obj ? [NSString stringWithFormat:@"@\"%@\"", [obj class]].UTF8String : @encode(id))

// Arguments 0 and 1 are self and _cmd always
extern const unsigned int kGDNumberOfImplicitArgs;

// See https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
extern NSString *const kGDPropertyAttributeKeyTypeEncoding;
extern NSString *const kGDPropertyAttributeKeyBackingIvarName;
extern NSString *const kGDPropertyAttributeKeyReadOnly;
extern NSString *const kGDPropertyAttributeKeyCopy;
extern NSString *const kGDPropertyAttributeKeyRetain;
extern NSString *const kGDPropertyAttributeKeyNonAtomic;
extern NSString *const kGDPropertyAttributeKeyCustomGetter;
extern NSString *const kGDPropertyAttributeKeyCustomSetter;
extern NSString *const kGDPropertyAttributeKeyDynamic;
extern NSString *const kGDPropertyAttributeKeyWeak;
extern NSString *const kGDPropertyAttributeKeyGarbageCollectable;
extern NSString *const kGDPropertyAttributeKeyOldStyleTypeEncoding;

typedef NS_ENUM(NSUInteger, GDPropertyAttribute) {
    GDPropertyAttributeTypeEncoding       = 'T',
    GDPropertyAttributeBackingIvarName    = 'V',
    GDPropertyAttributeCopy               = 'C',
    GDPropertyAttributeCustomGetter       = 'G',
    GDPropertyAttributeCustomSetter       = 'S',
    GDPropertyAttributeDynamic            = 'D',
    GDPropertyAttributeGarbageCollectible = 'P',
    GDPropertyAttributeNonAtomic          = 'N',
    GDPropertyAttributeOldTypeEncoding    = 't',
    GDPropertyAttributeReadOnly           = 'R',
    GDPropertyAttributeRetain             = '&',
    GDPropertyAttributeWeak               = 'W'
}; //NS_SWIFT_NAME(GD.PropertyAttribute);

typedef NS_ENUM(char, GDTypeEncoding) {
    GDTypeEncodingNull             = '\0',
    GDTypeEncodingUnknown          = '?',
    GDTypeEncodingChar             = 'c',
    GDTypeEncodingInt              = 'i',
    GDTypeEncodingShort            = 's',
    GDTypeEncodingLong             = 'l',
    GDTypeEncodingLongLong         = 'q',
    GDTypeEncodingUnsignedChar     = 'C',
    GDTypeEncodingUnsignedInt      = 'I',
    GDTypeEncodingUnsignedShort    = 'S',
    GDTypeEncodingUnsignedLong     = 'L',
    GDTypeEncodingUnsignedLongLong = 'Q',
    GDTypeEncodingFloat            = 'f',
    GDTypeEncodingDouble           = 'd',
    GDTypeEncodingLongDouble       = 'D',
    GDTypeEncodingCBool            = 'B',
    GDTypeEncodingVoid             = 'v',
    GDTypeEncodingCString          = '*',
    GDTypeEncodingObjcObject       = '@',
    GDTypeEncodingObjcClass        = '#',
    GDTypeEncodingSelector         = ':',
    GDTypeEncodingArrayBegin       = '[',
    GDTypeEncodingArrayEnd         = ']',
    GDTypeEncodingStructBegin      = '{',
    GDTypeEncodingStructEnd        = '}',
    GDTypeEncodingUnionBegin       = '(',
    GDTypeEncodingUnionEnd         = ')',
    GDTypeEncodingQuote            = '\"',
    GDTypeEncodingBitField         = 'b',
    GDTypeEncodingPointer          = '^',
    GDTypeEncodingConst            = 'r'
}; //NS_SWIFT_NAME(GD.TypeEncoding);
