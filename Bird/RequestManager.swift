//
//  RequestManager.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 09/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
class RequestManager {
    static let shared = RequestManager()
    
    func createUploadRequest(_ url :String,
                             method: HTTPMethod,
                             headers: [String: String],
                             parameters: [String: AnyObject],
                             withName: String,
                             imagesArr : [UIImage],
                             onSucces successCallback :((JSON)->Void)?,
                             onFailure failureCallback: ((String) -> Void)?){
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            
            for i in 0..<imagesArr.count{
                if  let dat = UIImageJPEGRepresentation((imagesArr[i]), 0.6){
                    multipartFormData.append(dat, withName: withName,  fileName:  "image"+String(format:"%d",i)+".jpg", mimeType: "image/jpeg")
                }
            }
            
            for key in parameters.keys{
                let name = String(key)
                var val = ""
                if name! == "id" {
                    val = String(parameters[name!] as! Int)
                }
                else{
                    val = parameters[name!] as! String
                }
                multipartFormData.append(val.data(using: .utf8)!, withName: name!)
            }
            
        },
                         to: url,
                         method: method,
                         headers : headers,
                         encodingCompletion:{ encodingResult in
                            switch encodingResult{
                            case .success(let upload, _, _):
                                upload.validate().responseJSON{ (responseJSON) in
                                    switch responseJSON.result {
                                    case .success(let value):
                                        let json = JSON(value)
                                        successCallback?(json)
                                    case .failure(let error):
                                        if let callback = failureCallback {
                                            // Return
                                            callback(error.localizedDescription)
                                        }
                                    }
                                    
                                }
                            case .failure(let error):
                                if let callback = failureCallback {
                                    // Return
                                    callback(error.localizedDescription)
                                }
                            }
        }
            
        )
    }
}
