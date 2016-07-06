//
//  ViewController.swift
//  reproductor
//
//  Created by José-María Súnico on 20160628.
//  Copyright © 2016 José-María Súnico. All rights reserved.
//

/*
Instrucctiones: Hacer una aplicación en Swift que se pueda correr en el simulador de iOS usando Xcode y que permita:
•	Seleccionar entre varias canciones diferentes
	- La selección se puede hacer con un botón o cualquier otro mecanismo que usted desee (tabla, picker, etc.)
	- Las canciones deben estar “en duro”.
	- Sólo deberá tener entre 7 y 10 segundos de cada canción (por cuestiones de espacio).
•	Al seleccionar una canción deberá aparecer su título y la portada de su CD.
•	En cuanto la canción sea seleccionada deberán aparecer sus datos (título y foto) e iniciará la reproducción de inmediato sin que el usuario tenga que hacer nada más.
•	Se podrá controlar la reproducción con 3 botones: Tocar, Pausar o Detener.
•	Se podrá controlar el volumen (aumentarlo o disminuirlo).
	- Este control puede hacerse con 2 botones (+ y -) o con cualquier otro mecanismo que usted desee (slider, etc.)
•	Debe contener un botón de selección aleatoria (shuffle)
*/

import UIKit
import AVFoundation
import AVKit

class Song{
	private var name : String?
	private var coverURL : String?
	private var songURL : NSURL?
	
	required init (name: String?, coverURL: String?, fileName: String?, fileExt: String?) {
		self.name = name!
		self.coverURL = coverURL!
		self.songURL = NSBundle.mainBundle().URLForResource(fileName!, withExtension: fileExt!)
	}
	
	func getName() -> String? {
		return self.name!
	}
	
	func getSongCover() -> String? {
		return self.coverURL!
	}
	func getSongURL() -> NSURL?{
		return self.songURL!
	}
}

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	var reproductor : AVAudioPlayer!
	var playerViewController : AVPlayerViewController!

	@IBOutlet weak var Volume: UISlider!
	@IBAction func volumeControl(sender: UISlider) {
		reproductor.volume = Float(sender.value)
	}
	
	
	@IBOutlet weak var songName: UILabel!
	@IBAction func Play(sender: AnyObject) {
		print("PLAY pressed")
		if !reproductor.playing {
			reproductor.play()
		}
	}
	@IBAction func Pause(sender: AnyObject) {
		print("PAUSE pressed")
		if reproductor.playing {
			reproductor.pause()
		}
		if !reproductor.playing {
			reproductor.play()
		}
	}
	@IBAction func Stop(sender: AnyObject) {
		print("STOP pressed")
		if reproductor.playing {
			reproductor.stop()
		}
		reproductor.currentTime = 0.0
	}
	@IBOutlet weak var songCover: UIImageView!
	@IBOutlet weak var songSelector: UIPickerView!
	var album : [Song] = []

	@IBAction func randomSong(sender: UIButton) {
		print("User wants to be lucky...")
		prepareSong(0, rndm: true)
		reproductor.play()
	}
	
	func prepareSong(row: Int, rndm: Bool) {
		var songIdx = Int(row)
		if (rndm) {
			songIdx = Int( arc4random_uniform(UInt32(album.count-1)))
			songSelector.selectRow(songIdx, inComponent: 0, animated: true)
		}
		
		self.songName.text = album[songIdx].getName()!
		self.songCover.image = UIImage(named: album[songIdx].getSongCover()!)
		do {
			try self.reproductor = AVAudioPlayer(contentsOfURL: self.album[songIdx].getSongURL()!)
		} catch{
			print("Some error when attempting to load the sound file!!!")
		}
		print("\(self.album[songIdx].getName()!) ready to be reproduced!")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// Load songs in album
		album.append(Song(name: "Song 1", coverURL: "image1", fileName: "sound1", fileExt: "mp3"))
		album.append(Song(name: "Song 2", coverURL: "image2", fileName: "sound2", fileExt: "mp3"))
		album.append(Song(name: "Song 3", coverURL: "image3", fileName: "sound3", fileExt: "mp3"))
		album.append(Song(name: "Song 4", coverURL: "image4", fileName: "sound4", fileExt: "mp3"))
		album.append(Song(name: "Song 5", coverURL: "image5", fileName: "sound5", fileExt: "mp3"))
		print("Album initialised with \(self.album.count) elements")
		
		prepareSong(0, rndm: true)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	//This method indicates that the number of components of the view selector is just one, the name of the song
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}

	//This method indicates that the number of items in the component equals the number of elements in the  array
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.album.count
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		print("pickerView is on the move.......(\(self.album[row].getName()!))")
		return self.album[row].getName()
	}

	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
		print("\(self.album[row].getName()!) selected")
		prepareSong(row, rndm: false)
		reproductor.play()
	}
}


