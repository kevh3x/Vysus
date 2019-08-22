//
//  SpeechControls.swift
//  SpokenWord
//
//  Created by Kevin Esparza on 7/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Foundation
import Speech

class SpeechControls: UIViewController {
    
    let synthesizer = AVSpeechSynthesizer()
    
    var myUtterance = AVSpeechUtterance(string:"")
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    private var count = 0;
    
    // Two sounds used on the app.
    
    var confirmationEffect: AVAudioPlayer = AVAudioPlayer()
    var confirmationEffect2: AVAudioPlayer = AVAudioPlayer()
    //Changes between true and false to determine if the keyword was used.
    var keyWordUsed = false
    
    func startAudioEngine() {
        
        do {
            try startRecording()
        } catch {
            print("Recording failed")
        }
        // We assign the audio files for keyword confirmation and choice confirmation as soon as the Voice Commands is called to start.
        let audioFile = Bundle.main.path(forResource: "confirmationsound", ofType:".mp3")
        let audioFile2 = Bundle.main.path(forResource: "confirmation2", ofType:".mp3")
        do{
            try confirmationEffect = AVAudioPlayer(contentsOf: URL(fileURLWithPath:audioFile!))
            try confirmationEffect2 = AVAudioPlayer(contentsOf: URL(fileURLWithPath:audioFile2!))
        }
        catch{
            print("One of the audio files have failed to load.")
        }
    }
    
    
    func resetEngine(){
        let inputNode = self.audioEngine.inputNode
        
        inputNode.removeTap(onBus: 0)
        
        do{
            try self.startRecording()
        }
        catch{
            print("Start Recording did not work")
        }
        
        
    }
    
    //This function reads the description text out to the user.
    
    func speakDescription(_ description:String) {
        
        self.myUtterance = AVSpeechUtterance(string:description)
        
        self.myUtterance.rate = 0.5
        
        self.myUtterance.volume = 1.0
        
        self.synthesizer.speak(self.myUtterance)
    }
    
    // Stops Audion Engine in the app.
    func stopAudioEngine() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
    }
    
    //Takes a String sentence and outputs an array of the words in that sentence.
    func stringToArrayOfWords(_ sentences: String) -> [String] {
        var words: [String] = []
        var currWord: String = ""
        for letter in sentences {
            if letter == " " || letter == "." {
                words.append(currWord.lowercased())
                currWord = ""
            } else {
                currWord += String(letter)
            }
        }
        words.append(currWord)
        return words
    }
    
    private func startRecording() throws {
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        try audioSession.overrideOutputAudioPort(.speaker)
        let inputNode = audioEngine.inputNode
        
        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in let isFinal = false
            
            if let result = result {
                // Update the text view with the results.
                let audio = result.bestTranscription.formattedString.lowercased()
                var audioArray = self.stringToArrayOfWords(audio)
                let choice = audioArray[audioArray.count - 1]
                let lastTwoWords = audioArray[max(0, audioArray.count - 2)] + " " + audioArray[max(0, audioArray.count - 1)]
//                print("AudioArray: ")
//                print(audioArray)
                //Compares last two words in the audio array to our keyPhrase
                let checkUsedKeyWord = lastTwoWords == "hey victoria"
                self.audioHandler(checkUsedKeyWord, audio, choice)
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
            }
        }
        
        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
    }
    
    // Checks to see if the keyWord has been used. Must be overwritten on the tutorial to account for speech output (victoria's own voice).
    func audioHandler(_ checkUsedKeyWord: Bool,_ audio: String,_ choice: String) {
        if (checkUsedKeyWord) {
            self.keyWordUsed = true
            self.confirmationEffect.play()
        }
        self.keyWordChecker(audio, choice)
    }
    
    // Checks to see if the keyWord has been used. Must be ovewritten for the tutorial. A keyword is not needed when answering questions: Remove the if in self.keyWordUsed.
    func keyWordChecker(_ audio: String,_ choice: String){
        if self.keyWordUsed {
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            self.choiceHandler(choice)
        }
    }
    
    func choiceHandler(_ choice: String) {
        switch choice {
        //TODO: Connect the SEGUES here:
        // Replace the print statements with the SEGUES
        case "share":
            self.keyWordUsed = false
            self.stopAudioEngine()
            confirmationEffect2.play()
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            performSegue(withIdentifier: "swipeLeftFive", sender: self)
        case "comment":
            self.keyWordUsed = false
            self.stopAudioEngine()
            confirmationEffect2.play()
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            performSegue(withIdentifier: "swipeLeftFour", sender: self)
        case "next":
            self.keyWordUsed = false
            confirmationEffect2.play()
        case "previous":
            self.keyWordUsed = false
            self.stopAudioEngine()
        default:
            print("Nothing done")
        }
    }
    
}
