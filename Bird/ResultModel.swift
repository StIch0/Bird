//
//  ResultModel.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 08/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
class ResultModel: GeneralModel {
    internal func loadData(_ dict: [String : AnyObject]) {
        
    }

    internal func build(_ dict: [String : AnyObject]) -> GeneralModel {
        let model = ResultModel()
        return model
    }
    var result : Bool = false
    var id : Int? = 0
    
    func loadData(_ dict: AnyObject) {
        id = dict as? Int ?? 0
        result = dict as? Bool ?? false
    }
   class func build(_ dict: AnyObject) -> GeneralModel {
        let model = ResultModel()
        model.loadData(dict)
        return model
    }
    
   
   
}
