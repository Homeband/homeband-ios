//
//  GroupBioView.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 12/05/18.
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
        } else {
            self.btnFacebook.isEnabled = false
        }
        
        // Twitter
        if(self.group.lien_twitter != ""){
            self.btnTwitter.backgroundColor = self.twitterColor
        } else {
            self.btnTwitter.isEnabled = false
        }
        
        // Instagram
        if(self.group.lien_instagram != ""){
            self.btnInstagram.backgroundColor = self.instagramColor
        } else {
            self.btnInstagram.isEnabled = false
        }
        
        // Youtube
        if(self.group.lien_youtube != ""){
            self.btnYoutube.backgroundColor = self.youtubeColor
        } else {
            self.btnYoutube.isEnabled = false
        }
        
        // Spotify
        if(self.group.lien_spotify != ""){
            self.btnSpotify.backgroundColor = self.spotifyColor
        } else {
            self.btnSpotify.isEnabled = false
        }
        
        // Bandcamp
        if(self.group.lien_bandcamp != ""){
            self.btnBandcamp.backgroundColor = self.bandcampColor
        } else {
            self.btnBandcamp.isEnabled = false
        }
        
        // SoundCloud
        if(self.group.lien_soundcloud != ""){
            self.btnSoundcloud.backgroundColor = self.soundcloudColor
        } else {
            self.btnSoundcloud.isEnabled = false
        }
        
        // Apple
        if(self.group.lien_itunes != ""){
            self.btnApple.backgroundColor = self.appleColor
        } else {
            self.btnApple.isEnabled = false
        }
    }
    
    @IBAction func onClickSocialMedia(_ sender: UIButton) {
    }
    

}
