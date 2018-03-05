import Foundation

typealias JsonDictionary = (String, Any)

class LyricsDataFetcher {
    func fetchLyrics(track: Track, completion: @escaping ([Track]) -> ()) {
        guard let lyricsURL = URL(string: "https://api.lyrics.ovh/v1/\(track.artist)/\(track.title)") else {
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
            
            guard let songData = jsonData as? (String, Any) else {
                print("Data was not an array of dictionaries")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            let allLyrics = songData.1
            
            let newTrack = Track(artist: track.artist, title: track.title, lyrics: allLyrics as! String)

            DispatchQueue.main.async {
                completion([newTrack])
            }
        }
        
        task.resume()
    }
}

