//
//  MainViewModel.swift
//  MusicPlayer
//
//  Created by Ngan Chak Lung on 9/1/2021.
//

import Alamofire
import Foundation
import RxSwift
import SwiftyJSON

class MainViewModel {
    var arrTrack = [NSDictionary]()
    var arrPlayedTrack = [NSDictionary]()
    var iCurrentTrack = 0
    
    let psLoading = PublishSubject<Bool>()
    let psError = PublishSubject<Error>()
    let psSearchMusic = PublishSubject<(NSDictionary)>()
    
    func searchMusic(term strTerm: String) {
        let params: Parameters = ["term": strTerm, "entity": "musicTrack"]
        self.psLoading.onNext(true)
        
        AF.request("https://itunes.apple.com/search", method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let json):
                self.psLoading.onNext(false)
                if let dictJson = json as? NSDictionary {
                    self.psSearchMusic.onNext(dictJson)
                }
            case .failure(let error):
                self.psLoading.onNext(false)
                self.psError.onNext(error)
                print("Request failed with error: \(error)")
            }
        }
    }
}
