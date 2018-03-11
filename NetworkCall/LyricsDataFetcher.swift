import Foundation

class LyricsDataFetcher {
    
    /// Helper method for building URL
    ///
    /// - Parameter str: String with spaces
    /// - Returns: String with properly formatted white spaces
    func convertWhiteSpace(str: String) -> String {
        let spaces = NSCharacterSet.whitespaces
        var convertedString = ""
        
        var strCodeUnits = [UnicodeScalar]()
        for codeUnit in str.unicodeScalars {
            strCodeUnits.append(codeUnit)
        }
        
        for unit in strCodeUnits {
            if spaces.contains(unit) {
                convertedString.append("%20")
            } else {
                convertedString.append(unit.escaped(asASCII: false))
            }
        }
        return convertedString
    }
    
    /// Method for building URL from base api url
    ///
    /// - Parameter track: Track which has an artist and song title
    /// - Returns: URL with appended search params to make API request against
    func buildURL(track: Track) -> String {
        let baseURL = "https://api.lyrics.ovh/v1/"
        let artist = track.artist
        let title = track.title
        
        let artistNoWhiteSpace = convertWhiteSpace(str: artist)
        let titleNoWhiteSpace = convertWhiteSpace(str: title)
        
        return baseURL + "\(artistNoWhiteSpace)/\(titleNoWhiteSpace)"
    }
    
    
    /// Method which makes GET request against API
    ///
    /// - Parameters:
    ///   - track: Track to look up lyrics for
    ///   - completion: returns lyrics of the Track given as input
    func fetchLyrics(track: Track, completion: @escaping (String) -> ()) {
        guard let lyricsURL = URL(string: buildURL(track: track)) else {
            print("URL did not instantiate")
            completion("")
            return
        }
        
        let task = URLSession.shared.dataTask(with: lyricsURL) { (data, urlResponse, error) in
            guard let data = data else {
                print("No data")
                DispatchQueue.main.async {
                    completion("")
                }
                return
            }
            
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)  else {
                print(lyricsURL)
                print("JSON serialization failed")
                DispatchQueue.main.async {
                    completion("")
                }
                return
            }
            
            guard let songData = [jsonData] as? [[String: Any]] else {
                print("Data was not an array of dictionaries")
                DispatchQueue.main.async {
                    completion("")
                }
                return
            }
            
            let lyricsData = songData.flatMap { lyricsDictionary in
                guard let lyric = lyricsDictionary["lyrics"] as? String else { return nil }
                return lyric
            }
            
            DispatchQueue.main.async {
                completion(lyricsData[0])
            }
        }
        task.resume()
    }
}
