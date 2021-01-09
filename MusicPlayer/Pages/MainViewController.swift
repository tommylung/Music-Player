//
//  MainViewController.swift
//  MusicPlayer
//
//  Created by Ngan Chak Lung on 9/1/2021.
//

import AVFoundation
import RxSwift
import UIKit

class MainViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var disposeBag = DisposeBag()
    var vm = MainViewModel()
    let player = AVQueuePlayer()
    
    @IBOutlet weak var sbSearch: UISearchBar!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var aivIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var vMainContainer: UIView!
    @IBOutlet weak var tvMain: UITableView!
    @IBOutlet weak var lblNoResult: UILabel!
    
    @IBOutlet weak var vPlayerContainer: UIView!
    @IBOutlet weak var imgvArtwork: UIImageView!
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.bindUI()
        self.fetchData()
    }

    // MARK: - Core
    private func initUI() {
        self.vm.arrTrack.removeAll()
        self.vm.arrPlayedTrack.removeAll()
        
        self.sbSearch.backgroundImage = UIImage()
        self.aivIndicator.isHidden = true
        self.aivIndicator.startAnimating()
        self.lblNoResult.isHidden = false
        self.tvMain.isHidden = true
        self.tvMain.register(MusicTableViewCell.self, forCellReuseIdentifier: String(describing: MusicTableViewCell.self))
        
        self.btnPlay.setImage(UIImage(named: "PlayerPlay"), for: .normal)
    }
    
    private func bindUI() {
        self.vm.psLoading.subscribe(onNext: { [weak self] bLoading in
            guard self != nil else { return }
            self?.aivIndicator.isHidden = !bLoading
        }).disposed(by: self.disposeBag)
        
        self.vm.psError.subscribe(onNext: { [weak self] error in
            guard self != nil else { return }
            print("Error: \(error)")
        }).disposed(by: self.disposeBag)
        
        self.vm.psSearchMusic.subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            
            if let results = response.object(forKey: "results") as? Array<NSDictionary> {
                self.vm.arrTrack = results
                self.lblNoResult.isHidden = results.count > 0
                self.tvMain.isHidden = !(results.count > 0)
            }
            
            self.tvMain.reloadData()
        }).disposed(by: self.disposeBag)
    }
    
    private func fetchData() {
        
    }
    
    func playTrack(_ track: NSDictionary) {
        self.btnPlay.setImage(UIImage(named: "PlayerStop"), for: .normal)
        
        if let arkworkUrl = track.object(forKey: "artworkUrl60") as? String {
            self.imgvArtwork.requestImage(url: arkworkUrl)
        }
        if let trackName = track.object(forKey: "trackName") as? String {
            self.lblTrackName.text = trackName
        }
        if let artistName = track.object(forKey: "artistName") as? String {
            self.lblArtistName.text = artistName
        }
        if let urlTrack = URL(string: track.object(forKey: "previewUrl") as? String ?? "") {
            self.player.removeAllItems()
            self.player.insert(AVPlayerItem(url: urlTrack), after: nil)
            self.player.play()
        }
    }
    
    // MARK: - Action
    @IBAction func pressedbtnSearch(_ sender: Any) {
        self.sbSearch.resignFirstResponder()
        if let strSearch = self.sbSearch.text, !strSearch.isEmpty {
            self.vm.searchMusic(term: strSearch)
        } else {
            self.vm.arrTrack.removeAll()
            self.tvMain.isHidden = true
            self.lblNoResult.isHidden = false
        }
    }
    
    @IBAction func pressedBtnPrevious(_ sender: Any) {
        if self.vm.iCurrentTrack <= 1 {
            self.vm.iCurrentTrack = 1
        } else {
            self.vm.iCurrentTrack -= 1
        }
        
        self.playTrack(self.vm.arrPlayedTrack[self.vm.iCurrentTrack - 1])
    }
    
    @IBAction func pressedBtnPlay(_ sender: Any) {
        if self.player.timeControlStatus == .playing {
            self.player.seek(to: CMTime(value: CMTimeValue(0.0), timescale: CMTimeScale(1.0)))
            self.player.pause()
            self.btnPlay.setImage(UIImage(named: "PlayerPlay"), for: .normal)
        } else {
            self.player.play()
            self.btnPlay.setImage(UIImage(named: "PlayerStop"), for: .normal)
            self.playTrack(self.vm.arrPlayedTrack[self.vm.iCurrentTrack - 1])
        }
    }
    
    @IBAction func pressedBtnNext(_ sender: Any) {
        if self.vm.iCurrentTrack >= self.vm.arrPlayedTrack.count {
            self.vm.iCurrentTrack = self.vm.arrPlayedTrack.count
        } else {
            self.vm.iCurrentTrack += 1
        }
        self.playTrack(self.vm.arrPlayedTrack[self.vm.iCurrentTrack - 1])
    }
    
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tvMain.dequeueReusableCell(withIdentifier: String(describing: MusicTableViewCell.self), for: indexPath) as! MusicTableViewCell
        
        if self.vm.arrTrack.count > indexPath.row {
            let track = self.vm.arrTrack[indexPath.row] as NSDictionary
            cell.updateData(arkworkUrl: track.object(forKey: "artworkUrl60") as? String, trackName: track.object(forKey: "trackName") as? String, artistName: track.object(forKey: "artistName") as? String)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.arrTrack.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.vm.arrTrack.count > indexPath.row {
            let track = self.vm.arrTrack[indexPath.row] as NSDictionary
            self.vm.arrPlayedTrack.append(track)
            self.vm.iCurrentTrack += 1
            self.playTrack(track)
        }
        self.tvMain.reloadData()
    }
}

