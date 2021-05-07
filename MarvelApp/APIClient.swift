import Foundation
import SwiftHash
import Alamofire
class APIClient {
    static private let baseUrl = "https://gateway.marvel.com/v1/public/characters?"
    static private let APIKey = "cb1b120ff85906ee9b983956ff29e5b6"
    static private let secret = "40ed3ff049eea11fbbe6e53cbe08470d51fd03e6"
    static private let limit = 50
        class func loadHeroes(page:Int = 0, onComplete: @escaping (MarvelInfo?) -> Void){
        let offset = page * limit
        let url = baseUrl + "offset=\(offset)&limit=\(limit)&" + getCredentials()
        AF.request(url).responseJSON { (response) in
            let decode: JSONDecoder = JSONDecoder()
            guard let data = response.data,
                  let marvelInfo = try? decode.decode(MarvelInfo.self, from: data),
                marvelInfo.code == 200 else {
                    onComplete(nil)
                    return
            }
            onComplete(marvelInfo)
        }
    }
    private class func getCredentials() -> String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(ts+secret+APIKey).lowercased()
        return "ts=\(ts)&apikey=\(APIKey)&hash=\(hash)"
    }
}
