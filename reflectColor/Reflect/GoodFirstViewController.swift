//
//  GoodFirstViewController.swift
//  reflectColor
//
//  Created by 森杏菜 on 2024/07/21.
//

import UIKit
import Alamofire
import AVFoundation
import SwiftyJSON

class GoodFirstViewController: UIViewController, AVAudioRecorderDelegate{
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL!
    var isRecording: Bool = false
    var retryCount = 0
    let maxRetryCount = 3
    var exampleURL: URL!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var eachBackgrounds: [UILabel]!
    @IBOutlet var answerBackgound: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgrounds()
        self.navigationItem.hidesBackButton = true
        
        
        
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    if granted {
                        print("Permission granted")
                    } else {
                        print("Permission denied")
                    }
    }
    
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default)
                try audioSession.setActive(true)
            } catch {
                print("Failed to set audio session category and mode: \(error)")
                return
            }
        }
    
    @IBAction func back(_ sender: UIButton) {
        let alertController = UIAlertController(title: "確認", message: "今日のふりかえりを終了しますか？", preferredStyle: .alert)
        
        // "はい" アクションを追加
        let yesAction = UIAlertAction(title: "終了", style: .destructive) { _ in
            self.dismiss(animated: true)
            self.tabBarController?.tabBar.isHidden = false
        }
        alertController.addAction(yesAction)
        
        // "いいえ" アクションを追加
        let noAction = UIAlertAction(title: "戻る", style: .cancel, handler: nil)
        alertController.addAction(noAction)
        
        // アラートを表示
        self.present(alertController, animated: true) {
            // アラートビューのサブビューをカスタマイズ
            let alertView = alertController.view.subviews.first
            let containerView = alertView?.subviews.first
            let buttonContainer = containerView?.subviews.first

            // カスタマイズを適用
            for case let button as UIButton in buttonContainer?.subviews ?? [] {
                if button.title(for: .normal) == "終了" {
                    button.setTitleColor(.red, for: .normal)
                    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17) // 太字に設定
                } else if button.title(for: .normal) == "戻る" {
                    button.setTitleColor(.blue, for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 17) // 細字に設定
                }
            }
        }
    }

    func setupBackgrounds() {
        eachBackgrounds.forEach { label in
            label.layer.cornerRadius = 10
            label.clipsToBounds = true
        }
        answerBackgound.layer.borderColor = UIColor(red: 25/255, green: 44/255, blue: 112/255, alpha: 1.0).cgColor
        answerBackgound.layer.borderWidth = 2.0
        answerBackgound.clipsToBounds = true
    }
    
            @IBAction func startRecording(_ sender: UIButton) {
                if !isRecording {
        //            スタートする時
                    isRecording = true
                    let audioFilename = getDocumentsDirectory().appendingPathComponent("recording2.raw")
                    recordingURL = audioFilename
        
                    let settings = [
                        AVFormatIDKey: kAudioFormatLinearPCM,
                        AVSampleRateKey: 16000,
                        AVNumberOfChannelsKey: 1,
                        AVLinearPCMBitDepthKey: 16,
                        AVLinearPCMIsBigEndianKey: false,
                        AVLinearPCMIsFloatKey: false
                    ] as [String : Any]
        
                    do {
                        audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                        audioRecorder?.delegate = self
                        audioRecorder?.record()
                        print("Recording started")
                    } catch {
                        print("Failed to start recording: \(error)")
                    }
                } else {
        //            録音停止する時
                    audioRecorder?.stop()
                    audioRecorder = nil
                    print("Recording stopped")
        //            このrequest()で下に書いてる関数読んで，API通信をしている！
                    request()
                    isRecording = false
                }
            }
        
            func request() {
                    APIManager.shared.request(audioURL: recordingURL) { happiness, disgust, neutral, sadness, anger, text in
                        if let happiness = happiness, let disgust = disgust, let neutral = neutral, let sadness = sadness, let anger = anger, let text = text {
        
        //                    この辺で感情の値を取り出せる！好きに使ってね！
                            print("Happiness: \(happiness)")
                            print("Disgust: \(disgust)")
                            print("Neutral: \(neutral)")
                            print("Sadness: \(sadness)")
                            print("Anger: \(anger)")
        //                    textも出せる！
                            print("Text: \(text)")
                            DispatchQueue.main.async {
        //                        例えば取り出せた文章を出せるよね
                                self.answerBackgound.text = text
        //                        例えばここで次へボタン復活させたら次画面いける
                                self.nextButton.isHidden = false
        
                            }
                        } else {
                            print("Failed to retrieve emotion or text")
                        }
                    }
                }
        
            func getDocumentsDirectory() -> URL {
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                return paths[0]
            }
        
        
        
        
    }

