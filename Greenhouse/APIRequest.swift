//
//  APIRequest.swift
//  Greenhouse
//
//  Created by Chase Conklin on 3/25/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import Foundation
import SwiftHTTP

class APIRequest : NSObject {
    var urlString : String
    
    init(urlString: String) {
        self.urlString = urlString
    }

    func sendGETRequest(delegate : APIRequestDelegate) {
        do {
            let opt = try HTTP.GET(self.urlString)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return
                }
                delegate.handlePlantData(response.data)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
 
    func sendPOSTRequest(delegate : APIRequestDelegate, params : [String: AnyObject]) {
        do {
            let opt = try HTTP.POST(self.urlString, parameters: params, requestSerializer: JSONParameterSerializer())
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return
                }                
                delegate.handlePlantData(response.data)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
}
