//
//  APIManager.swift
//  reflectColor
//
//  Created by 森杏菜 on 2024/07/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    
    static let shared = APIManager()
    var messageString: String?
    
    private init() {}
    
    func request(audioURL: URL, flag: Int, completion: @escaping (Float?, Float?, Float?, Float?, Float?, String?, String?) -> Void) {
        getAPIKey(audioURL: audioURL, flag: flag, completion: completion)
    }
    
    private func getAPIKey(audioURL: URL, flag: Int, completion: @escaping (Float?, Float?, Float?, Float?, Float?, String?, String?) -> Void) {
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        let parameters: [String: String] = [
            "grant_type": "https://auth.mimi.fd.ai/grant_type/client_credentials",
            "client_id": "41b75cffc72d41f8a57558303539d994:e95be5a71a3f49d28ba79ea45d86fc08",
            "client_secret": "fb8a919f00b22d65f52fd48e65f7c8c56996f117571a0c0466d9cffaed80ecd1e324180af109e5ade959686d2a969c426700f154cfb06510e5742df7b791ecf994090c2a56e16816d3e7a8d3c1d554dcc98f01e57918ed4ad8104a1eac453b7ea3a61729a59c917c9982dc942643b969ae3d0100ef7edb3b5f40ce4fdc07e5285f38356bdc8cd0ffbf12f7146faee98db0cf14b7a92e35bebdfd1ac4f6b2d625fa49c2d194b289ffad7aceb6f492dd6435786947af2c0f0b61cfec922542faad31e62e731df37b513c1d52fb503d09e6f46e8be36ed2da91bbe6775f28289dfecfe72f818080c207324c086a5df31f3ada2811bf4cdef47bc8145939f1d4feaa",
            "scope": "https://apis.mimi.fd.ai/auth/asr/http-api-service;https://apis.mimi.fd.ai/auth/emo-categorical/http-api-service;https://apis.mimi.fd.ai/auth/nict-asr/http-api-service"
        ]
        
        AF.request("https://auth.mimi.fd.ai/v2/token", method: .post, parameters: parameters, headers: headers)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let json = try JSON(data: data)
                        print("Success: \(json)")
                        if let accessToken = json["accessToken"].string {
                            self.getEmotionText(token: accessToken, flag:flag, audioURL: audioURL, completion: completion)
                        } else {
                            print("Failed to get access token")
                            completion(nil, nil, nil, nil, nil, nil, nil)
                        }
                    } catch {
                        print("Failed to parse JSON: \(error)")
                        completion(nil, nil, nil, nil, nil, nil, nil)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    completion(nil, nil, nil, nil, nil, nil, nil)
                }
            }
    }
    
    private func getEmotionText(token: String, flag:Int, audioURL: URL, completion: @escaping (Float?, Float?, Float?, Float?, Float?, String?, String?) -> Void) {
        print("Audio URL: \(audioURL.absoluteString)")
        
        guard let audioData = try? Data(contentsOf:audioURL) else {
            print("Failed to convert audio file to Data")
            completion(nil, nil, nil, nil, nil, nil, nil)
            return
        }
        
        let headersEmotion: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(token)",
            "Content-Type": "audio/x-pcm;bit=16;rate=16000;channels=1",
            "x-mimi-process": "emo-categorical"
        ]
        
        let url = URL(string: "https://service.mimi.fd.ai/")!
        AF.upload(audioData, to: url, headers: headersEmotion).response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    let json = JSON(data)
                    print("Response JSON: \(json)")
                    let emotion = json["response"]["scores"]
                    let happiness = emotion["happiness"].floatValue
                    let disgust = emotion["disgust"].floatValue
                    let neutral = emotion["neutral"].floatValue
                    let sadness = emotion["sadness"].floatValue
                    let anger = emotion["anger"].floatValue
                    
                    self.getText(token: token, flag:flag, audioData: audioData) { text in
                        self.chatGpt(rawData: text!, flag: flag) { gptResponse in
                            completion(happiness, disgust, neutral, sadness, anger, text, gptResponse)
                        }
                    }
                } else {
                    completion(nil, nil, nil, nil, nil, nil, nil)
                }
            case .failure(let error):
                print("Upload Failure: \(error)")
                completion(nil, nil, nil, nil, nil, nil, nil)
            }
        }
    }
    
    private func getText(token: String, flag:Int, audioData: Data, completion: @escaping (String?) -> Void) {
        let headersText: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(token)",
            "Content-Type": "audio/x-pcm;bit=16;rate=16000;channels=1",
            "x-mimi-process": "nict-asr",
            "x-mimi-input-language": "ja",
            "x-mimi-nict-asr-options": "response_format=v2;progressive=false"
        ]
        
        let url = URL(string: "https://service.mimi.fd.ai/")!
        AF.upload(audioData, to: url, headers: headersText).response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    let json = JSON(data)
                    print("Response JSON: \(json)")
                    let text = json["response"][0]["result"].stringValue
                    completion(text)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Upload Failure: \(error)")
                completion(nil)
            }
        }
    }
    
    
    func chatGpt(rawData:String, flag:Int, completion: @escaping (String?) -> Void){
        
        if flag == 0{
            messageString = "下記の文章と下記の条件を参考にしてください。＃文章\(rawData)＃条件・今日の出来事を10字以内で要約・全体の返答としては、「お話をまとめると、今日は[出来事]が主な出来事だと感じました。正しいですか？」に当てはめて返答するように。"
        }else if flag == 1{
            messageString = "ほにゃらら"
        }
        
        
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer ",
            "OpenAI-Organization": "",
            "Content-Type": "application/json"
        ]
        
        let parameters: Parameters = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": messageString]
            ]
        ]
        
        AF.request("https://api.openai.com/v1/chat/completions", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let json = try JSON(data: data)
                        if let chatGPTresponse = json["choices"][0]["message"]["content"].string {
                            completion(chatGPTresponse)
                        } else {
                            print("Failed to get content as string")
                        }
                    } catch {
                        print("Failed to parse JSON: \(error)")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
}
