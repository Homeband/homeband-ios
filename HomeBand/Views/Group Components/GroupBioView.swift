//
//  GroupBioView.swift
//  HomeBand
//
//  Created on 12/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

class GroupBioView: UIViewController {

    private let facebookColor: UIColor = UIColor(hex: 0x3b5998, alpha: 1)
    private let twitterColor: UIColor = UIColor(hex: 0x1da1f2, alpha: 1)
    private let instagramColor: UIColor = UIColor(hex: 0x833ab4, alpha: 1)
    private let youtubeColor: UIColor = UIColor(hex: 0xff0000, alpha: 1)
    private let spotifyColor: UIColor = UIColor(hex: 0x1db954, alpha: 1)
    private let bandcampColor: UIColor = UIColor(hex: 0x629aa9, alpha: 1)
    private let soundcloudColor: UIColor = UIColor(hex: 0xff3300, alpha: 1)
    private let appleColor: UIColor = UIColor(hex: 0xff2d55, alpha: 1)
    
    
    private var group:Groupe!
    
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnInstagram: UIButton!
    @IBOutlet weak var btnYoutube: UIButton!
    @IBOutlet weak var btnSpotify: UIButton!
    @IBOutlet weak var btnBandcamp: UIButton!
    @IBOutlet weak var btnSoundcloud: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var tvBiographie: UITextView!
    
    init(_ group:Groupe) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UIApplication.
        checkButtons()
        initBio()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initBio(){
        self.tvBiographie.text = self.group.biographie
    }
    
    func checkButtons() {
        // Facebook
        if(self.group.lien_facebook != ""){
            self.btnFacebook.backgroundColor = self.facebookColor
            self.btnFacebook.isEnabled = true
        } else {
            self.btnFacebook.isEnabled = false
        }
        
        // Twitter
        if(self.group.lien_twitter != ""){
            self.btnTwitter.backgroundColor = self.twitterColor
            self.btnTwitter.isEnabled = true
        } else {
            self.btnTwitter.isEnabled = false
        }
        
        // Instagram
        if(self.group.lien_instagram != ""){
            self.btnInstagram.backgroundColor = self.instagramColor
            self.btnInstagram.isEnabled = true
        } else {
            self.btnInstagram.isEnabled = false
        }
        
        // Youtube
        if(self.group.lien_youtube != ""){
            self.btnYoutube.backgroundColor = self.youtubeColor
            self.btnYoutube.isEnabled = true
        } else {
            self.btnYoutube.isEnabled = false
        }
        
        // Spotify
        if(self.group.lien_spotify != ""){
            self.btnSpotify.backgroundColor = self.spotifyColor
            self.btnSpotify.isEnabled = true
        } else {
            self.btnSpotify.isEnabled = false
        }
        
        // Bandcamp
        if(self.group.lien_bandcamp != ""){
            self.btnBandcamp.backgroundColor = self.bandcampColor
            self.btnBandcamp.isEnabled = true
        } else {
            self.btnBandcamp.isEnabled = false
        }
        
        // SoundCloud
        if(self.group.lien_soundcloud != ""){
            self.btnSoundcloud.backgroundColor = self.soundcloudColor
            self.btnSoundcloud.isEnabled = true
        } else {
            self.btnSoundcloud.isEnabled = false
        }
        
        // Apple
        if(self.group.lien_itunes != ""){
            self.btnApple.backgroundColor = self.appleColor
            self.btnApple.isEnabled = true
        } else {
            self.btnApple.isEnabled = false
        }
    }
    
    @IBAction func onClickFacebook(_ sender: Any) {
        let link = self.group.lien_facebook
        let toRemove = "http(s)?:\\/\\/(.)*(\\.)?facebook\\.com\\/"
        let pageID = link.replacingOccurrences(of: toRemove, with: "", options: .regularExpression)
        let app = "fb://profile/" + pageID
        
        UIApplication.tryURL(urls: [
            app,
            link
        ])
    }
    
    @IBAction func onClickTwitter(_ sender: Any) {
        let link = self.group.lien_twitter
        let toRemove = "http(s)?:\\/\\/(.)*(\\.)?twitter\\.com\\/"
        let pageID = link.replacingOccurrences(of: toRemove, with: "", options: .regularExpression)
        let app = "twitter://user?screen_name=" + pageID
        
        UIApplication.tryURL(urls: [
            app,
            link
            ])
    }
    
    @IBAction func onClickInstagram(_ sender: Any) {
        let link = self.group.lien_instagram
        let toRemove = "http(s)?:\\/\\/(.)*(\\.)?instagram\\.com\\/"
        let pageID = link.replacingOccurrences(of: toRemove, with: "", options: .regularExpression)
        let app = "instagram://user?username=" + pageID
        
        UIApplication.tryURL(urls: [
            app,
            link
            ])
    }
    
    @IBAction func onClickYoutube(_ sender: Any) {
        let link = self.group.lien_youtube
        let toRemove = "http(s)?:\\/\\/(.)*(\\.)?youtube\\.com\\/channel\\/"
        let pageID = link.replacingOccurrences(of: toRemove, with: "", options: .regularExpression)
        let app = "youtube://www.youtube.com/channel/" + pageID
        
        UIApplication.tryURL(urls: [
            app,
            link
            ])
    }
    
    @IBAction func onClickSpotify(_ sender: Any) {
        let link = self.group.lien_spotify
        let toRemove = "http(s)?:\\/\\/(.)*(\\.)?spotify\\.com\\/artist\\/"
        let pageID = link.replacingOccurrences(of: toRemove, with: "", options: .regularExpression)
        let app = "spotify:artist:" + pageID
        
        UIApplication.tryURL(urls: [
            app,
            link
            ])
    }
    
    @IBAction func onClickSoundcloud(_ sender: Any) {
        let link = self.group.lien_soundcloud
        let toRemove = "http(s)?:\\/\\/(.)*(\\.)?soundcloud\\.com\\/"
        let pageID = link.replacingOccurrences(of: toRemove, with: "", options: .regularExpression)
        let app = "soundcloud:users:" + pageID
        
        UIApplication.tryURL(urls: [
            app,
            link
            ])
    }
    
    @IBAction func onClickBandcamp(_ sender: Any) {
        let link = self.group.lien_bandcamp
        // let toRemove = "http(s)?:\\/\\/"
        // var pageID = link.replacingOccurrences(of: toRemove, with: "", options: .regularExpression)
        // let toRemove2 = "(\\.)bandcamp\\.com\\/"
        // pageID = pageID.replacingOccurrences(of: toRemove2, with: "", options: .regularExpression)
        
        // let app = "x-bandcamp://user/" + pageID
        
        UIApplication.tryURL(urls: [
            link
            ])
    }
}
