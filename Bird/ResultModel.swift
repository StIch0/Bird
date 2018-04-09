//
//  ResultModel.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 08/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
class ResultModel: GeneralModel {
    var result : Bool = false
    var id : Int? = 0
    
    internal func loadData(_ dict: [String : AnyObject]) {
//        if let data = dict
    }
    internal func build(_ dict: [String : AnyObject]) -> GeneralModel {
        let model = ResultModel()
        model.loadData(dict)
        return model
    }
    
   
   
}
