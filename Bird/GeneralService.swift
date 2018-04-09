//
//  GeneralSevice.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 09/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class GeneralService {
    func postAnyData(_ url :String,
                     key : String?,
                     method : HTTPMethod,
                     parameters: [String: AnyObject],
                     withName: String,
                     imagesArr : [UIImage],
                     model : GeneralModel,
                     onSucces successCallback :((_ result: [GeneralModel])->Void)?,
                     onFailure failureCallback: ((_ errorMessage: String) -> Void)?){
        APIManager.instanse.postAnyData(url, key: key, method : method, parameters: parameters, withName: withName, imagesArr: imagesArr, model: model, onSucces:{
            res in
            successCallback?(res)
        }, onFailure:{
            error in
            failureCallback?(error)
        })
    }

}
