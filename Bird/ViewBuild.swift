//
//  ViewBuild.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 09/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
protocol ViewBuild : NSObjectProtocol {
    func setData(data : [ViewData]) -> Void
    func setEmptyData()
    func startLoading()
    func stopLoading()
}
