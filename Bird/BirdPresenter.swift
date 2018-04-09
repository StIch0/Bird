//
//  BirdPresenter.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 09/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
import UIKit
struct BirdViewData: ViewData {
    let birds : [String]
}
class BirdPresenter  {
    let service : GeneralService
    weak private var view : ViewBuild?
    init(service : GeneralService) {
        self.service = service
    }
    func  atachView(view: ViewBuild ) -> Void {
        self.view = view
    }
    func detachView (){
        view = nil
    }
    func getData (_ url: String,
                  _ parameters : [String: AnyObject],
                  withName : String,
                  imageArr: [UIImage]) {
        self.view?.startLoading()
        service.postAnyData(APISelected.get_bird.rawValue,
                            key: nil,
                            method : .get,
                            parameters: parameters,
                            withName: withName,
                            imagesArr: imageArr,
                            model: BirdModel(),
                            onSucces: { result in
            self.view?.stopLoading()
            if result.count == 0 {
                self.view?.setEmptyData()
            }
            else {
                let resMap = (result as! [BirdModel]).map{
                    rmap->BirdViewData in
                    return BirdViewData(birds: rmap.birds)
                }
                self.view?.setData(data: resMap)
            }
                                
        }
            , onFailure: {
                errorMessage  in
                print("Error = ", errorMessage)
                self.view?.stopLoading()
        })
    }
}
