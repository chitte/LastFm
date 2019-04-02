
import Foundation

enum ServiceError: Error {
    case networkError(message: String)
    case statutsCodeError(message: String)
    case jsonError(message: String)
    case unknownError(message: String)
}

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
