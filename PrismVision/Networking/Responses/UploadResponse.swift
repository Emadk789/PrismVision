//
//  uploadResponse.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 23/12/2020.
//

import Foundation

// MARK: - Get Upload ID
struct UploadResponse: Decodable {
    let result: Result,
        status: Status
    
}
struct Result: Decodable {
    let uploadId: String
}
struct Status: Decodable {
    let text: String,
        type: String
}
