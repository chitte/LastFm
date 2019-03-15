

import UIKit

let API_KEY = "7677c6773ed8cfeb5f2eb7de4728ea02"
let BASE_URL = "http://ws.audioscrobbler.com/2.0/"

let IS_IPAD = (UIDevice.current.userInterfaceIdiom == .pad) ? true : false

enum AlbumAPIErrorCode: Int {
    case INVALID_SERVICE
    case INVALID_METHOD
    case AUTHENTICATION_FAILED
    case INVALID_FORMAT
    case INVALID_PARAMETERS
    case INVALID_RESOURCE_SPECIFIED
    case OPERATION_FAILED
    case INVALID_SESSION_KEY
    case INVALID_APIKEY
    case SERVICE_OFFLINE
    case INVALID_METHOD_SIGNATURE_SPECIFIED
    case TEMPORARY_ERROR
    case SUSPENDED_APIKEY
    case RATE_LIMIT_EXCEEDED
}

let screenHeight: CGFloat = UIScreen.main.bounds.size.height
let screenWidth: CGFloat = UIScreen.main.bounds.size.width
