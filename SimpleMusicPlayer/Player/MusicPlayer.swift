//
//  MusicPlayer.swift
//  SimpleMusicPlayer
//
//  Created by 任岐鸣 on 2016/11/15.
//  Copyright © 2016年 Ned. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayer: UIView,UITableViewDelegate,UITableViewDataSource {
    
//    var musicList = ["Real Stuff", "Real Stuff (Instrumental)","我好想你"]
    var fileNameList = ["ES_Real Stuff - Marc Torch","ES_Real Stuff (Instrumental Version) - Marc Torch","missingyou"]
    var fileSuffix = ["mp3","mp3","m4a"]
    
    let topPanel = TopPanel()
    
    let player = PlayerView()
    
//    var audioPlayer = AVAudioPlayer()
    
    lazy var topWhiteBg:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 10
        return view
    }()
    lazy var tableView:AnimTableView = {
        let tableView = AnimTableView()
        tableView.delegate = self
        tableView.dataSource = self
        let playerCellNib = UINib(nibName: "PlayerItemCell", bundle: Bundle(for: PlayerItemCell.self))
        tableView.register(playerCellNib, forCellReuseIdentifier: "cell")
//        tableView.register(ItemCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0)
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 15))
        
        tableView.backgroundColor = .white
        tableView.layer.shadowColor = UIColor.lightGray.cgColor
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = false
        tableView.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        tableView.layer.shadowOpacity = 1.0
        tableView.layer.shadowRadius = 10
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    init() {
        super.init(frame: CGRect.zero)
        setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    func commonInit() {
        
    }
    
    func setUI() {
        
        addSubview(topWhiteBg)
        addSubview(topPanel)
        addSubview(tableView)
        addSubview(player)
        
        topPanel.snp.makeConstraints { (make) in
            make.centerY.equalTo(topWhiteBg)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        
        topWhiteBg.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalTo(tableView)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(player.snp.bottom).offset(-5)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        player.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(topWhiteBg.snp.bottom).offset(-5)
            make.height.equalTo(80)
            make.width.equalToSuperview().multipliedBy(0.95)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNameList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlayerItemCell
        let path = Bundle.main.path(forResource: fileNameList[indexPath.row], ofType: fileSuffix[indexPath.row])
        let fileInfo = EZAudioFileInfo()
        fileInfo.loadFile(path!)
        cell.lblCount.text = "\(indexPath.row + 1)"
        cell.lblTime.text = fileInfo.getDuration()
        cell.lblTitle.text = fileInfo.getTitle()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let path = Bundle.main.path(forResource: fileNameList[indexPath.row], ofType: fileSuffix[indexPath.row])
        let fileInfo = EZAudioFileInfo()
        fileInfo.loadFile(path!)
        fileInfo.placeHolderImage = UIImage.init(named: "cover.jpeg")

        player.audioPlayer = try! AVAudioPlayer.init(data: fileInfo.getData())
        player.audioPlayer.prepareToPlay()
        player.audioPlayer.play()
        player.btnControl.setToPause()
        player.btnControl.isUserInteractionEnabled = true
        player.lblTitle.alpha = 0
        player.lblArtist.alpha = 0
        player.imgCover.alpha = 0.5
        player.lblTitle.text = fileInfo.getTitle()
        player.lblArtist.text = "\(fileInfo.getArtist()) \(fileInfo.getAlbum())"
        player.imgCover.image = fileInfo.getArtwork()
        UIView.animate(withDuration: 0.3, animations: {
            self.player.btnControl.alpha = 1
            self.player.lblTitle.alpha = 1
            self.player.lblArtist.alpha = 1
            self.player.imgCover.alpha = 1
        })
    }
    
}
