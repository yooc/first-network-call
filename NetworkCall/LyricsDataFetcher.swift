import Foundation

typealias JsonDictionary = [String: Any]

class LyricsDataFetcher {
    func fetchLyrics(completion: @escaping ([Track]) -> ()) {
        let baseURL = "https://api.lyrics.ovh/v1/"
        guard let lyricsURL = URL(string: "\(baseURL)/ \(Track.artist)/ \(Track.title)") else {
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
                print("JSON serialization failed")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            guard let songData = jsonData as? [[Track]] else {
                print("Data was not an array of dictionaries")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            let songNames = songData.flatMap { songDictionary in
                guard let lyrics = songDictionary["lyrics"] as? String else { return nil }
                return lyrics
            }
            
            DispatchQueue.main.async {
                completion(songNames)
            }
        }
        
        task.resume()
    }
}

