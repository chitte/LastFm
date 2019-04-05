
import Foundation

enum ServiceError: String {
    case networkError
    case jsonError
    case invalidService
    case InvalidMethod
    case authenticationFailed
    case invalidFormat
    case invalidParameters
    case invalidResourceSpecified
    case operationFailed
    case invalidSessionKey
    case invalidAPIKey
    case serviceOffline
    case invalidMethodSignatureSpecified
    case temporaryError
    case suspendedAPIKey
    case rateLimitExceeded

    var rawValue: String {
        switch self {
        case .networkError:
            return "The Internet connection appears to be offline."
        case .jsonError:
            return "Error trying to convert data to json"
        case .invalidService:
            return "This service does not exist"
        case .InvalidMethod:
            return "No method with that name in this package"
        case .authenticationFailed:
            return "You do not have permissions to access the service"
        case .invalidFormat:
            return "This service doesn't exist in that format"
        case .invalidParameters:
            return "Your request is missing a required parameter"
        case .invalidResourceSpecified:
            return "INVALID_RESOURCE_SPECIFIED"
        case .operationFailed:
            return "Something else went wrong"
        case .invalidSessionKey:
            return "Please re-authenticate"
        case .invalidAPIKey:
            return "You must be granted a valid key by last.fm"
        case .serviceOffline:
            return "This service is temporarily offline. Try again later."
        case .invalidMethodSignatureSpecified:
            return "INVALID_METHOD_SIGNATURE_SPECIFIED"
        case .temporaryError:
            return "There was a temporary error processing your request. Please try again"
        case .suspendedAPIKey:
            return "Access for your account has been suspended, please contact Last.fm"
        case .rateLimitExceeded:
            return "Your IP has made too many requests in a short period"
        }
    }
}

enum APIErrorCode: Int {
    case INVALID_SERVICE = 2
    case INVALID_METHOD = 3
    case AUTHENTICATION_FAILED = 4
    case INVALID_FORMAT = 5
    case INVALID_PARAMETERS = 6
    case INVALID_RESOURCE_SPECIFIED = 7
    case OPERATION_FAILED = 8
    case INVALID_SESSION_KEY = 9
    case INVALID_APIKEY = 10
    case SERVICE_OFFLINE = 11
    case INVALID_METHOD_SIGNATURE_SPECIFIED = 13
    case TEMPORARY_ERROR = 16
    case SUSPENDED_APIKEY = 26
    case RATE_LIMIT_EXCEEDED = 29
}
