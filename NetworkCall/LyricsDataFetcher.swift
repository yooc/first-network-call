import Foundation

typealias JsonDictionary = [String: Any]

class LyricsDataFetcher {
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
    
    func buildURL(track: Track) -> String {
        let baseURL = "https://api.lyrics.ovh/v1/"
        let artist = track.artist
        let title = track.title
        
        let artistNoWhiteSpace = convertWhiteSpace(str: artist)
        
        let titleNoWhiteSpace = convertWhiteSpace(str: title)
        
        return baseURL + "\(artistNoWhiteSpace)/\(titleNoWhiteSpace)"
    }
    
    func fetchLyrics(track: Track, completion: @escaping ([Track]) -> ()) {
        guard let lyricsURL = URL(string: buildURL(track: track)) else {
            print("URL did not instantiate")
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: lyricsURL) { (data, urlResponse, error) in
            guard let data = data else {
                print("No data")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)  else {
                print(lyricsURL)
                print("JSON serialization failed")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            guard let songData = [jsonData] as? [[String: Any]] else {
                print("Data was not an array of dictionaries")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            let allLyrics = songData.flatMap { songDictionary in
                guard let lyric = songDictionary["lyrics"] as? String else { return nil }
                return lyric
            }
            
            let newTrack = Track(artist: track.artist, title: track.title, lyrics: allLyrics[0])
            
            DispatchQueue.main.async {
                completion([newTrack])
            }
        }
        task.resume()
        
    }
}

