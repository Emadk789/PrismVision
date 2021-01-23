//
//  TutorialStrings.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 21/01/2021.
//

import Foundation


enum TutorialStrings {
    enum type {
        case title, body
    }
    
    case flash(for: type),
         camera(for: type),
         color(for: type),
         hex(for: type),
         album(for: type),
         pointer(for: type),
         settings(for: type),
         recommendations(for: type),
         enjoy(for: type)
    
    var stringValue: String {
        switch self {
        case let .flash(type):
            switch type {
            case .title:
                return "Flash Button"
            case .body:
                return "Allows you to toggle the flash on your phone"
            }
        case let .camera(type):
            switch type {
            case .title:
                return "Camera Button"
            case .body:
                return "Allows you to detect colors"
            }
        case let .color(type):
            switch type {
            case .title:
                return "Color Label"
            case .body:
                return "Shows the detected color"
            }
        case let .hex(type):
            switch type {
            case .title:
                return "Hex Label"
            case .body:
                return "Shows the Hex value of the detected color"
            }
        case let .album(type):
            switch type {
            case .title:
                return "Album Button"
            case .body:
                return "1. Access the photos' album on your phone \n\n2. Detect colors on the chosen images"
            }
        case let .pointer(type):
            switch type {
            case .title:
                return "The Pointer"
            case .body:
                return "Drag it around the screen to detect the colors of different points on the screen"
            }
        case let .settings(type):
            switch type {
            case .title:
                return "Settings Button"
            case .body:
                return "1. Change the language of the app \n\n2. Revisit this tutorial"
            }
        case let .recommendations(type):
            switch type {
            case .title:
                return "Recommendations"
            case .body:
                return "1. Make sure to have the \"Silent Mode\" turned off if you want to listen to when the app has captured the color \n2. You can also turn on the \"Voice Over\" or the \"Speech Controller\" to interact with the app \n3. To have better results, make sure that you use the app in a very well lit environment \n4. Make sure to have the object to be detected at a reasonable distance from the phone"
            }
        case let .enjoy(type):
            switch type {
            case .title:
                return "Enjoy! ✨"
            case.body: return ""
            }
        }
    }
//    enum Flash: String {
//        case title, body
//        
//        var stringValue: String {
//            switch self {
//            case .title:
//                return "Flash Button"
//            case .body:
//                return "Allows you to toggle the flash on your phone"
//            }
//        }
//    }
//    enum Camera: String {
//        case title, body
//        
//        var stringValue: String {
//            switch self {
//            case .title:
//                return "Camera Button"
//            case .body:
//                return "Allows you to detect colors"
//            }
//        }
//    }
//    enum Color: String {
//        case title, body
//        
//        var stringValue: String {
//            switch self {
//            case .title:
//                return "Color Label"
//            case .body:
//                return "Shows the detected color"
//            }
//        }
//    }
//    enum Hex: String {
//        case title, body
//        
//        var stringValue: String {
//            switch self {
//            case .title:
//                return "Hex Label"
//            case .body:
//                return "Shows the Hex value of the detected color"
//            }
//        }
//    }
//    enum Album: String {
//        case title, body
//        
//        var stringValue: String {
//            switch self {
//            case .title:
//                return "Album Button"
//            case .body:
//                return "1. Access the photos' album on your phone \n2. Detect colors on the chosen images"
//            }
//        }
//    }
//    enum Pointer: String {
//        case title, body
//        
//        var stringValue: String {
//            switch self {
//            case .title:
//                return "The Pointer"
//            case .body:
//                return "Drag it around the screen to detect the colors of different points on the screen"
//            }
//        }
//    }
//    enum Settings: String {
//        case title, body
//        
//        var stringValue: String {
//            switch self {
//            case .title:
//                return "Settings Button"
//            case .body:
//                return "1. Change the language of the app \n2. Revisit this tutorial"
//            }
//        }
//    }
//    enum Recommendations: String {
//        case title, body
//        
//        var stringValue: String {
//            switch self {
//            case .title:
//                return "Recommendations"
//            case .body:
//                return "1. Make sure to have the \"Silent Mode\" turned off if you want to lessen to when the app has captured the color \n2. You can also turn on the \"Voice Over\" or the \"Speech Controller\" to interact with the app"
//            }
//        }
//    }
//    enum Enjoy: String {
//        case title
//        
//        var stringValue: String {
//            switch self {
//            case .title:
//                return "Enjoy! ✨"
//            }
//        }
//    }
    
}
