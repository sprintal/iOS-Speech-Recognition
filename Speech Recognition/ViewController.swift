//
//  ViewController.swift
//  Speech Recognition
//
//  Created by Kang Meng on 31/10/19.
//  Copyright © 2019 Kang Meng. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    @IBOutlet weak var label: UILabel!
    let audioEngine = AVAudioEngine()
    let speechRecognizer : SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-AU"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func recordAndRecognizeSpeech() {
        let node: AVAudioInputNode
        do {
            try node = audioEngine.inputNode
        } catch {
            print(error)
            return
        }
        self.label.text = "reocrding"
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }
        if !myRecognizer.isAvailable {
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.label.text = bestString
            } else if let error = error {
                print(error)
            }
        })
    }

    @IBAction func recognize(_ sender: Any) {
        self.recordAndRecognizeSpeech()
    }
    
}

