//
//  LoginPresenter.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 12/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
import UIKit
struct ResultViewData:ViewData {
    let id  : Int
    let result : Bool
}
class ResultPresenter {
    var service = GeneralService()
    weak private var view : ViewBuild?
    init(service: GeneralService) {
        self.service = service
    }
    func  atachView(view: ViewBuild ) -> Void {
        self.view = view
    }
    func detachView (){
        view = nil
    }
    func getData(_ url: String,
                 _ parameters : [String: AnyObject],
                 withName : String,
                 imageArr: [UIImage]){
        view?.startLoading()
        service.postAnyData(url,
                            key: "",
                            method: .post,
                            parameters: parameters,
                            withName: withName,
                            imagesArr: imageArr,
                            model: ResultModel(),
                            onSucces: {
                                result in
                                self.view?.stopLoading()
                                if result.count == 0 {
                                    self.view?.setEmptyData()
                                }
                                else {
                                    let resMap = (result as! [ResultModel]).map{
                                        rmap->ResultViewData in
                                        return ResultViewData(id: rmap.id!,
                                                             result : rmap.result)
                                    }
                                    self.view?.setData(data: resMap)
                                }
        },
                            onFailure: {errorMessage in
                                 print("Error = ",errorMessage)
                                self.view?.stopLoading()
    })
    }
}
