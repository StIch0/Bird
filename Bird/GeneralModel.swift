//
//  GeneralModel.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 08/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
protocol GeneralModel {
    func loadData(_ dict : [String: AnyObject]) -> Void
    func build (_ dict : [String :AnyObject])->GeneralModel
}
