//
//  APIMAnager.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 09/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
import Alamofire
import  SwiftyJSON
class APIManager {
    static let instanse = APIManager()
    let API_BASE_URL = "http://bird.bsu.ru/basic/web/index.php?r=app/"
    func postAnyData(_ url :String,
                     key: String?,
                     method : HTTPMethod,
                     parameters: [String: AnyObject],
                     withName: String,
                     imagesArr : [UIImage],
                     model: GeneralModel,
                     onSucces successCallback :((_ result: [GeneralModel])->Void)?,
                     onFailure failureCallback: ((_ errorMessage: String) -> Void)?){
        let url = API_BASE_URL + url
        let headers = [
            "Authorization": "YWNjXzJhOGNjYzgzYTc3NTRjMTo2NmQyMTIxOTdmZjNhYzVlYTc1NmEwYzEwNjljNjQ1NQ=="
        ]
        RequestManager.shared.createUploadRequest(
            url,
            method: method,
            headers: headers,
            parameters: parameters,
            withName: withName,
            imagesArr: imagesArr,
            onSucces: {
             (responseJSON : JSON)->Void in
             print("responseJSON",responseJSON.dictionary!)
                if let keyDict = key {
                    if let responseDict = responseJSON[keyDict].arrayObject {
                        let dataDict = responseDict as! [[String : AnyObject]]
                        var dataModel = Array<GeneralModel>()
                        for item in dataDict {
                            let data = model.build(item)
                            dataModel.append(data)
                        }
                        successCallback?(dataModel)
                    }
                    else {
                        failureCallback?("An error has occured.")
                    }
                }
                else {
                    if let responseDict = responseJSON.dictionaryObject {
                        let resultDict = responseDict as [String : AnyObject]
                        var dataModel = Array<GeneralModel>()
                        let data = model.build(resultDict)
                        dataModel.append(data)
                        successCallback?(dataModel)
                    }
                    else {
                        failureCallback?("An error has occured.")
                    }
                }
           
        }, onFailure: {(errorMessage: String)->Void in
            failureCallback?(errorMessage)
        })
    }
}
