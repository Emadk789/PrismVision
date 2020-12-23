//
//  GetColorsResponse.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 23/12/2020.
//

import Foundation


// MARK: - Get Colors
struct GetColorsResponse: Decodable {
    let result: ColorResult
    let status: ColorStatus
}

// MARK: - Result
struct ColorResult: Decodable {
    let colors: Colors
}

// MARK: - Colors
struct Colors: Decodable {
    let backgroundColors: [Color]
    let colorPercentThreshold: Double
    let colorVariance: Int
    let foregroundColors, imageColors: [Color]
    let objectPercentage: Double
    
    enum CodingKeys: String, CodingKey {
            case backgroundColors = "background_colors"
            case colorPercentThreshold = "color_percent_threshold"
            case colorVariance = "color_variance"
            case foregroundColors = "foreground_colors"
            case imageColors = "image_colors"
            case objectPercentage = "object_percentage"
        }

}

// MARK: - Color
struct Color: Decodable {
    let b: Int
    let closestPaletteColor, closestPaletteColorHTMLCode, closestPaletteColorParent: String
    let closestPaletteDistance: Double
    let g: Int
    let htmlCode: String
    let percent: Double
    let r: Int
    
    enum CodingKeys: String, CodingKey {
            case b
            case closestPaletteColor = "closest_palette_color"
            case closestPaletteColorHTMLCode = "closest_palette_color_html_code"
            case closestPaletteColorParent = "closest_palette_color_parent"
            case closestPaletteDistance = "closest_palette_distance"
            case g
            case htmlCode = "html_code"
            case percent, r
        }

}

// MARK: - Status
struct ColorStatus: Decodable {
    let text, type: String
}
