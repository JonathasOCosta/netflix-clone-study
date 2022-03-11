//
//  APICaller.swift
//  netflix-clone
//
//  Created by user210401 on 3/9/22.
//

import Foundation

struct Constants {
    static let API_KEY = "08218d085ac8dc430a9c56882e2c7d7b"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyBuGXns7qk0ucsdFQsfW5Xbl5Gc7nCK-qE"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    static let shared = APICaller()
    
    
    func getTrendingMovies(completion: @escaping (Result<[Titles], Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
                
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success((results.results)))

            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
            
        }
        
        task.resume()
    }
    
    
    func getTrendingTvs(completion: @escaping (Result<[Titles], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success((results.results)))
            }catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Titles], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success((results.results)))
            }catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func getPupular(completion: @escaping (Result<[Titles], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else  {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
               completion(.success((results.results)))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Titles], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else  {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success((results.results)))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Titles], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=pt-BR&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else  {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success((results.results)))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Titles], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else  {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success((results.results)))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else  {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
            }catch{
                completion(.failure(error))
                print(error)
            }
        }
        
        task.resume()
        
    }
    
}
