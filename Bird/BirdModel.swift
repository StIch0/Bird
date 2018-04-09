//
//  BirdModel.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 08/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
class BirdModel:GeneralModel {
    var birds : [String] = Array()
    internal func loadData(_ dict: [String : AnyObject]) {
        if let data = dict["birds"] {
            self.birds = data as! [String]
        }
    }
    internal func build(_ dict: [String : AnyObject]) -> GeneralModel {
        let model = BirdModel()
        model.loadData(dict)
        return model
    }
}
