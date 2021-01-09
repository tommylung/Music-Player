//
//  MusicTableViewCell.swift
//  MusicPlayer
//
//  Created by Ngan Chak Lung on 9/1/2021.
//

import RxSwift
import SnapKit
import UIKit

class MusicTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()
    
    var imgvArtwork = UIImageView()
    var lblTrackName = UILabel()
    var lblArtistName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Core
    private func initUI() {
        self.removeAllSubviews()
        
        self.addSubview(self.imgvArtwork)
        self.addSubview(self.lblTrackName)
        self.addSubview(self.lblArtistName)
        
        self.imgvArtwork.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(50)
            $0.width.equalTo(50)
        }
        
        self.lblTrackName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalTo(self.imgvArtwork.snp.right).offset(10)
            $0.right.equalToSuperview().inset(10)
        }
        
        self.lblArtistName.snp.makeConstraints {
            $0.top.equalTo(self.lblTrackName.snp.bottom).offset(10)
            $0.left.equalTo(self.imgvArtwork.snp.right).offset(10)
            $0.right.equalToSuperview().inset(10)
        }
    }
    
    private func refresh() {
        self.imgvArtwork.image = nil
        self.lblTrackName.text = nil
        self.lblTrackName.text = nil
    }
    
    func updateData(arkworkUrl strArkworkUrl: String? = nil, trackName strTrackName: String? = nil, artistName strArtistName: String? = nil) {
        self.refresh()
        
        if let strArkworkUrl = strArkworkUrl {
            self.imgvArtwork.requestImage(url: strArkworkUrl)
        }
        if let strTrackName = strTrackName {
            self.lblTrackName.text = strTrackName
        }
        if let strArtistName = strArtistName {
            self.lblArtistName.text = strArtistName
        }
    }
}
