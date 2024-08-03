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

class RecordStartViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL!
    var isRecording: Bool = false
    var retryCount = 0
    let maxRetryCount = 3
    var exampleURL: URL!
    var waveView: WaveView!
    
    @IBOutlet var nextButton: UIBarButtonItem!
    @IBOutlet var eachBackgrounds: [UILabel]!
    @IBOutlet var answerBackgound: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        waveView = WaveView(frame: view.bounds)
        waveView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(waveView)
        view.sendSubviewToBack(waveView)
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
            // スタートする時
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
            // 録音停止する時
            audioRecorder?.stop()
            audioRecorder = nil
            print("Recording stopped")
            request()
            isRecording = false
        }
    }
    
    func request() {
        APIManager.shared.request(audioURL: recordingURL) { happiness, disgust, neutral, sadness, anger, text in
            if let happiness = happiness, let disgust = disgust, let neutral = neutral, let sadness = sadness, let anger = anger, let text = text {
                
                // この辺で感情の値を取り出せる！好きに使ってね！
                print("Happiness: \(happiness)")
                print("Disgust: \(disgust)")
                print("Neutral: \(neutral)")
                print("Sadness: \(sadness)")
                print("Anger: \(anger)")
                
                print("Text: \(text)")
                
                DispatchQueue.main.async {
                    
                    let maxEmotionValue = max(happiness, disgust, neutral, sadness, anger)
                    if maxEmotionValue == neutral {
                        
                        self.waveView.waveColor = .gray
                    }
                    // 例えば取り出せた文章を出せるよね
                    self.answerBackgound.text = text
                    // 例えばここで次へボタン復活させたら次画面いける
                    self.nextButton.isHidden = false
                }
            } else {
                print("Failed to retrieve emotion or text")
            }
        }
    }
    
    func presentWaveViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let waveVC = storyboard.instantiateViewController(withIdentifier: "WaveViewController") as? WaveViewController {
            self.present(waveVC, animated: true, completion: nil)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

