//
//  ViewController.swift
//  AudioPlayer
//
//  Created by ReusHarper on 05/11/22.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    // Conexion de los elementos
    @IBOutlet var lb_title: UILabel!
    @IBOutlet var btnPlay: UIButton!
    @IBOutlet var btnStop: UIButton!
    @IBOutlet var sliderDuration: UISlider!
    @IBOutlet var sliderVolume: UISlider!
    
    var audioPlayer = AVAudioPlayer()
    
    // Para poder ejecutar un codigo cada cierto tiempo
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Establecemos los controles de cada elemento
        self.view.addSubview(sliderDuration)
        sliderDuration.addTarget(self, action: #selector(durationChanged), for: .valueChanged)
        
        self.view.addSubview(btnStop)
        btnStop.addTarget(self, action: #selector(btnStopTouch), for: .touchUpInside)
        
        self.view.addSubview(btnPlay)
        btnPlay.addTarget(self, action: #selector(btnPlayTouch), for: .touchUpInside)
        
        self.view.addSubview(sliderVolume)
        sliderVolume.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
        
        // Obtenemos el recurso de audio
        setAudio()
    }
    
    @IBAction func btnPlayTouch(_ sender: Any) {
        audioPlayer.play()
        btnStop.isEnabled = true
        btnPlay.isEnabled = false
    }
    
    @IBAction func btnStopTouch(_ sender: Any) {
        audioPlayer.stop()
        btnStop.isEnabled = false
        btnPlay.isEnabled = true
    }
    
    @IBAction func durationChanged(_ sender: Any) {
        audioPlayer.currentTime = Double(sliderDuration.value)
    }
    
    @IBAction func volumeChanged(_ sender: Any) {
        audioPlayer.volume = sliderVolume.value
    }
    
    func setAudio() {
        guard let URL = Bundle.main.url(forResource: "MUSIC3", withExtension: "mp3")
        else {
            print("ERROR: El archivo no se encuentra disponible")
            return
        }
        
        do {
            // Intentamos cargar el archivo de audio
            audioPlayer = try AVAudioPlayer(contentsOf: URL)
            startInterface()
        } catch {
            print("ERROR: No se logro reproducir el audio, \(error.localizedDescription)")
        }
    }
        
    func startInterface() {
        // Guardamos el tiempo actuall
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateSliderDuration),
            userInfo: nil,
            repeats: true
        )
        
        sliderDuration.value = 0
        sliderDuration.maximumValue = Float(audioPlayer.duration)
        btnStop.isEnabled = false
        btnPlay.isEnabled = true
        audioPlayer.delegate = self
        audioPlayer.volume = 0.5
        sliderVolume.value = 0.5
    }
    
    @objc func updateSliderDuration() {
        // Se establece la posicion actual del slider mediante el tiempo actual del audioPlayer
        sliderDuration.value = Float(audioPlayer.currentTime)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Cancelamos el timer
        timer?.invalidate()
    }
        
}
