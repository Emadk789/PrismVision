//
//  TutorialStrings.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 21/01/2021.
//

import Foundation

enum TutorialStrings {
    enum Flash: String {
        case title, body
        
        var stringValue: String {
            switch self {
            case .title:
                return "Flash Button"
            case .body:
                return "Allows you to toggle the flash on your phone"
            }
        }
    }
    enum Camera: String {
        case title, body
        
        var stringValue: String {
            switch self {
            case .title:
                return "Camera Button"
            case .body:
                return "Allows you to detect colors"
            }
        }
    }
    enum Color: String {
        case title, body
        
        var stringValue: String {
            switch self {
            case .title:
                return "Color Label"
            case .body:
                return "Shows the detected color"
            }
        }
    }
    enum Hex: String {
        case title, body
        
        var stringValue: String {
            switch self {
            case .title:
                return "Hex Label"
            case .body:
                return "Shows the Hex value of the detected color"
            }
        }
    }
    enum Album: String {
        case title, body
        
        var stringValue: String {
            switch self {
            case .title:
                return "Album Button"
            case .body:
                return "1. Access the photos' album on your phone \n2. Detect colors on the chosen images"
            }
        }
    }
    enum Pointer: String {
        case title, body
        
        var stringValue: String {
            switch self {
            case .title:
                return "The Pointer"
            case .body:
                return "Drag it around the screen to detect the colors of different points on the screen"
            }
        }
    }
    enum Settings: String {
        case title, body
        
        var stringValue: String {
            switch self {
            case .title:
                return "Settings Button"
            case .body:
                return "1. Change the language of the app \n2. Revisit this tutorial"
            }
        }
    }
    enum Recommendations: String {
        case title, body
        
        var stringValue: String {
            switch self {
            case .title:
                return "Recommendations"
            case .body:
                return "1. Make sure to have the \"Silent Mode\" turned off if you want to lessen to when the app has captured the color \n2. You can also turn on the \"Voice Over\" or the \"Speech Controller\" to interact with the app"
            }
        }
    }
    enum Enjoy: String {
        case title
        
        var stringValue: String {
            switch self {
            case .title:
                return "Enjoy! ✨"
            }
        }
    }
    
}
