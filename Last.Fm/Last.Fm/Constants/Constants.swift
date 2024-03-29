

import UIKit

let API_KEY = "7677c6773ed8cfeb5f2eb7de4728ea02"
let BASE_URL = "http://ws.audioscrobbler.com/2.0/"

let IS_IPAD = (UIDevice.current.userInterfaceIdiom == .pad) ? true : false

let albumsSearchURL: String = "\(BASE_URL)?method=album.search&album=believe&api_key=\(API_KEY)&format=json"
let albumsBaseInfoURL = "\(BASE_URL)?method=album.getinfo&api_key=\(API_KEY)"


let screenHeight: CGFloat = UIScreen.main.bounds.size.height
let screenWidth: CGFloat = UIScreen.main.bounds.size.width
