//
//  RecordStartViewController.swift
//  reflectColor
//
//  Created by 森杏菜 on 2024/06/23.
//

import UIKit
import Alamofire
import AVFoundation
import SwiftyJSON

class RecordStartViewController: UIViewController, AVAudioRecorderDelegate{
    
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL!
    var isRecording: Bool = false
    var retryCount = 0
    let maxRetryCount = 3
    var exampleURL: URL!
    @IBOutlet var nextButton: UIBarButtonItem!
    @IBOutlet var eachBackgrounds: [UILabel]!
    @IBOutlet var answerBackgound: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        例えば
        nextButton.isHidden = false
        setupBackgrounds()
        
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        recordButton.frame = CGRect(x:172,y:687,width:50,height:50)
        recordButton.layer.cornerRadius = 25.0
        recordButton.layer.masksToBounds = true
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
                UIView.animate(withDuration: 0.2) {
                        self.recordButton.frame = CGRect(x:172,y:687,width:50,height:50)
                        self.recordButton.layer.cornerRadius = 25
                      }
            } catch {
                print("Failed to start recording: \(error)")
            }
            
        } else {
            //            録音停止する時
            audioRecorder?.stop()
            audioRecorder = nil
            print("Recording stopped")
            UIView.animate(withDuration: 0.2) {
                self.recordButton.frame = CGRect(x:172+10,y:687+10,width:30,height:30)
                   self.recordButton.layer.cornerRadius = 3.0
                 }
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

