//
//  ImaggaClient.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 23/12/2020.
//

import UIKit
import Alamofire

class ImaggaClient {
    static let shared = ImaggaClient()
    private init(){}
    
    enum Auth: String {
        case authorization
        
        var stringValue: String {
            switch self {
            case .authorization:
                return "Basic YWNjX2MyMWUwMTExZTZlOGRkYzpkZjE1NTVmZGYzMTA4ZDczMzJiN2JmMzA3YmM4YTVlYg=="
            }
        }
    }
    
    enum Endpoints {
        case getUploadID,
             getColors
        
        var stringURL: URL {
            switch self {
            case .getUploadID:
                return URL(string: "https://api.imagga.com/v2/uploads")!
            case .getColors:
                return URL(string: "https://api.imagga.com/v2/colors")!

            }
        }
            
    }
    
    func getUploadID<DecodableResponse: Decodable>(data: Data, for decodableResponseType: DecodableResponse.Type, completion: @escaping (DecodableResponse?, Error?) -> Void) {
        
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(Data(base64Encoded: data.base64EncodedData())!, withName: "image")
        }, to: Endpoints.getUploadID.stringURL, headers: [Auth.authorization.rawValue.capitalized: Auth.authorization.stringValue]).responseData { (response) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let result = try decoder.decode(DecodableResponse.self, from: response.data!)
                completion(result, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func getColors<DecodableResponse: Decodable>(uploadID: String, for decodableResponseType: DecodableResponse.Type, completion: @escaping (DecodableResponse?, Error?) -> Void) {
        let parameters = ["image_upload_id": uploadID]
        AF.request(Endpoints.getColors.stringURL, parameters: parameters, headers: [Auth.authorization.rawValue.capitalized: Auth.authorization.stringValue]).responseJSON { (response) in
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(DecodableResponse.self, from: response.data!)
                completion(result, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
}
