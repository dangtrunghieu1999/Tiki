//
//  BaseViewController.swift
//  Ecom
//
//  Created by Minh Tri on 3/23/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

enum ScreenType {
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6s
    case iPhone6Plus
    case iPhone6sPlus
    case iPhone7
    case iPhone7Plus
    case unknown
    
    var size: CGSize {
        switch self {
        case .iPhone5:
            return CGSize(width: 320.0, height: 568.0)
        case .iPhone6, .iPhone6s, .iPhone7 :
            return CGSize(width: 375.0, height: 667.0)
        case .iPhone6Plus, .iPhone6sPlus, .iPhone7Plus:
            return CGSize(width: 414.0, height: 736.0)
        default: // default is iphone  5
            return CGSize(width: 320.0, height: 568.0)
        }
    }
}

extension UIDevice {
    
    static var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }

    static var screenType: ScreenType? {
        guard iPhone else { return nil }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 1920:
            return .iPhone6Plus
        case 2208:
            return .iPhone6Plus
        default:
            return nil
        }
    }
    
    static func getRatioByWidth(original: ScreenType = .iPhone6) -> CGFloat {
        return UIScreen.main.bounds.width / original.size.width
    }
    
    static func getRatioByHeight(original: ScreenType = .iPhone6) -> CGFloat {
        return UIScreen.main.bounds.height / original.size.height
    }
    
    static var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}

struct Platform {
    public static let isSimulator: Bool = {
        var isSim = false
        #if targetEnvironment(simulator)
        isSim = true
        #endif
        return isSim
    }()
}

enum UIUserInterfaceIdiom: Int {
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize {
    public static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    public static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    public static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    public static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType {
    public static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    public static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    public static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    public static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    public static let IS_IPHONE_X         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    public static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    public static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

enum DeviceModel : String {
    case simulator     = "simulator/sandbox",
    //iPod
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    //iPad
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPadAir            = "iPad Air ",
    iPadAir2           = "iPad Air 2",
    iPad5              = "iPad 5", //aka iPad 2017
    iPad6              = "iPad 6", //aka iPad 2018
    //iPad mini
    iPadMini           = "iPad Mini",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadMini4          = "iPad Mini 4",
    //iPad pro
    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro10_5        = "iPad Pro 10.5\"",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    //iPhone
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPhone6            = "iPhone 6",
    iPhone6plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6Splus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    iPhoneXS           = "iPhone XS",
    iPhoneXSMax        = "iPhone XS Max",
    iPhoneXR           = "iPhone XR",
    //Apple TV
    AppleTV            = "Apple TV",
    AppleTV_4K         = "Apple TV 4K",
    unrecognized       = "?unrecognized?"
}

extension UIDevice {
    
    var modelName: DeviceModel {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        
        var modelMap : [String : DeviceModel] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            //iPod
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            //iPad
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad6,11"  : .iPad5, //aka iPad 2017
            "iPad6,12"  : .iPad5,
            "iPad7,5"   : .iPad6, //aka iPad 2018
            "iPad7,6"   : .iPad6,
            //iPad mini
            "iPad2,5"   : .iPadMini,
            "iPad2,6"   : .iPadMini,
            "iPad2,7"   : .iPadMini,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            //iPad pro
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7,
            "iPad7,3"   : .iPadPro10_5,
            "iPad7,4"   : .iPadPro10_5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9,
            //iPhone
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7plus,
            "iPhone9,4" : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8plus,
            "iPhone10,5" : .iPhone8plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            //AppleTV
            "AppleTV5,3" : .AppleTV,
            "AppleTV6,2" : .AppleTV_4K
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return DeviceModel.unrecognized
    }
}

enum ScreenMetrics {
    case undefined
    
    /// iPhone 4, 4s
    case inch3_5
    
    /// iPhone 5, 5s, 5c, SE
    case inch4
    
    /// iPhone 6, 6s, 7, 8
    case inch4_7
    
    /// iPhone 6+, 6s+, 7+, 8+
    case inch5_5
    
    /// iPhone X, XS
    case inch5_8
    
    /// iPhone XR
    case inch6_1
    
    /// iPhone XMax
    case inch6_5
    
    /// iPad, iPad Air, iPad Pro 9.7, iPad Pro 10.5
    case iPad
    
    /// iPad Pro 12.9
    case iPad_12_9
}

private extension ScreenMetrics {
    var heightInPoints: CGFloat {
        switch self {
        case .undefined: // iPhoneX
            return 812
        case .inch3_5:
            return 480
        case .inch4:
            return 568
        case .inch4_7:
            return 667
        case .inch5_5:
            return 736
        case .inch5_8:
            return 812
        case .inch6_1, .inch6_5:
            return 896
        case .iPad:
            return 1024
        case .iPad_12_9:
            return 1366
        }
    }
}

extension UIScreen {
    private var epsilon: CGFloat {
        return 1/self.scale
    }
    
    var pointsPerPixel: CGFloat {
        return self.epsilon
    }
    
    var screenMetric: ScreenMetrics {
        let screenHeight = self.fixedCoordinateSpace.bounds.height
        switch screenHeight {
        case ScreenMetrics.inch3_5.heightInPoints:
            return .inch3_5
        case ScreenMetrics.inch4.heightInPoints:
            return .inch4
        case ScreenMetrics.inch4_7.heightInPoints:
            return .inch4_7
        case ScreenMetrics.inch5_5.heightInPoints:
            return .inch5_5
        case ScreenMetrics.inch5_8.heightInPoints:
            return .inch5_8
        case ScreenMetrics.inch6_1.heightInPoints:
            return .inch6_1
        case ScreenMetrics.inch6_5.heightInPoints:
            return .inch6_5
        case ScreenMetrics.iPad.heightInPoints:
            return .iPad
        case ScreenMetrics.iPad_12_9.heightInPoints:
            return .iPad_12_9
        default:
            return .undefined
        }
    }
    
    var defaultPortraitKeyboardHeight: CGFloat {
        switch self.screenMetric {
        case .inch3_5, .inch4:
            return 253
        case .inch4_7:
            return 260
        case .inch5_5:
            return 271
        case .inch5_8:
            return 335
        case .inch6_1, .inch6_5:
            return 346
        case .iPad:
            return 313
        case .iPad_12_9:
            return 378
        case .undefined:
            return 335 // iPhoneX
        }
    }
    
    var defaultLandscapeKeyboardHeight: CGFloat {
        switch self.screenMetric {
        case .inch3_5, .inch4:
            return 199
        case .inch4_7, .inch5_5:
            return 200
        case .inch5_8, .inch6_1, .inch6_5:
            return 209
        case .iPad:
            return 398
        case .iPad_12_9:
            return 471
        case .undefined:
            return 209 // iPhone X
        }
    }
    
    public var defaultKeyboardHeightForCurrentOrientation: CGFloat {
        if UIDevice.current.orientation.isPortrait {
            return self.defaultPortraitKeyboardHeight
        } else {
            return self.defaultLandscapeKeyboardHeight
        }
    }
}
