//
//  ViewController.swift
//  CryptoAnalyzer
//
//  Created by Oscar Gutierrez C on 6/2/17.
//  Copyright © 2017 Trilobytes. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextDelegate,
NSTextFieldDelegate {
	
	@IBOutlet weak var textToAnalyzeField: NSTextField!
	@IBOutlet weak var ResultsLabel: NSTextField!
	@IBOutlet weak var bigramasLabel: NSTextFieldCell!
	@IBOutlet weak var trigramasLabel: NSTextField!
	@IBOutlet weak var keyValueTable: NSTableView!
	@IBOutlet weak var keyColumn: NSTableColumn!
	@IBOutlet weak var valueColumn: NSTableColumn!
	@IBOutlet weak var subtextsLabel: NSTextField!
	@IBOutlet weak var arbolesLabel: NSTextField!
	
	
	var tableViewKeyCollection : [String] = []
	var tableViewValueCollection : [String] = []
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		textToAnalyzeField.delegate = self
		tableViewKeyCollection = ["Indice Coincidencia", "Kasinsky", "Babage"]
		tableViewValueCollection = ["", "", ""]
		keyValueTable.delegate = self
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	override func controlTextDidChange(_ notification: Notification) {
		let textField = notification.object as! NSTextField
		
		//let numeroItems = Double(textToAnalyzeField.stringValue.characters.count)
		let symbols = textField.stringValue.lowercased().replacingOccurrences(of: " ", with: "").characters.map{String($0)}
		
		let rawResults = calculateNgramFrequency(of: symbols, withNgramLength: 1)
		let frequencyResults = rawResults.map{(simbolo, frecuencia) in return (simbolo, frecuencia/*/numeroItems*100*/)}
		let formatedString = formatFrequency(results: frequencyResults, taking: frequencyResults.count)
		self.ResultsLabel.stringValue = formatedString
		
		let IC = calculateCoincidenceIndex(of: rawResults, with: symbols.count)
		tableViewValueCollection[0] = "\(IC)"
		keyValueTable.reloadData()
		
		let bigramFrequency = calculateNgramFrequency(of: symbols, withNgramLength: 2)
		let formatedBigrams = formatFrequency(results: bigramFrequency, taking: 35)
		
		let trigramFrequency = calculateNgramFrequency(of: symbols, withNgramLength: 3)
		let formatedTrigrams = formatFrequency(results: trigramFrequency, taking: 35)
		
		self.bigramasLabel.stringValue = "Los 20 Bigramas Más Frecuentes: \n\(formatedBigrams)"
		self.trigramasLabel.stringValue = "Los 20 Trigramas Más Frecuentes: \n\(formatedTrigrams)"
		
		let subtextos = divideTextInSubtext(texto: textField.stringValue, numeroTextos: 5)
		let formattedSubtexts = formatSubtexts(subtextos: subtextos)
		self.subtextsLabel.stringValue = formattedSubtexts
		
		let frequencyTrees =  produceFrequencyTreesFor(subtexts: subtextos)
		self.arbolesLabel.stringValue = frequencyTrees
	}
	
	func calculateNgramFrequency(of symbols: [String], withNgramLength: Int) -> [(String, Double)] {
		
		var results =  [(String, Double)]()
		let conteo: Int = symbols.count - withNgramLength
		var index = 0
		
		while(index <= conteo){
			var index2 = 0
			var nGramaBuscado = ""
			while(index2 < withNgramLength){
				nGramaBuscado += symbols[index + index2]
				index2 += 1
			}
			
			if let indiceElementoBuscado = results.index(where:{ (nGrama,valor) in nGrama == nGramaBuscado}) {
				var elementoAModificar = results.remove(at: indiceElementoBuscado)
				elementoAModificar.1 += 1
				results.append(elementoAModificar)
			}else{
				results.append((nGramaBuscado, 1))
			}
			
			index += 1
			
		}
		
		results.sort(by: {$0.1 > $1.1})
		
		return results
	}
	
	func formatFrequency(results: [(String, Double)], taking maxNumberOfItems: Int) -> String {
		var parcialResult : String = ""
		
		var numeroItemsProcesados = 0
		for (letra, frecuencia) in results.sorted(by: {$0.1 > $1.1})
		{
			
			
			parcialResult += "\(letra) : \(frecuencia)\n"
			numeroItemsProcesados += 1
			if numeroItemsProcesados >= maxNumberOfItems {
				break
			}
		}
		return parcialResult
	}
	
	func calculateCoincidenceIndex(of frequency: [(String, Double)], with textLeght: Int ) -> Double {
		
		var acumular: Double = 0
		for (_, frecuencia) in frequency {
			acumular += frecuencia*(frecuencia-1)
			
		}
		return acumular/Double(textLeght*(textLeght-1))
	}
	
	func divideTextInSubtext(texto: String, numeroTextos: Int) -> [String]{
		let caracteres = texto.lowercased().replacingOccurrences(of: " ", with: "").characters.map{String($0)}
		var currentT = 0;
		var textos = [String](repeating: "", count: numeroTextos)
		
		for letra in caracteres {
			
			textos[currentT] += letra
			currentT += 1
			
			if currentT % numeroTextos == 0
			{
				currentT = 0
			}
		}
		return textos
	}
	
	func formatSubtexts(subtextos : [String]) -> String {
		var formateado: String = ""
		var contador = 0
		for sub in subtextos {
			formateado += "T\(contador): \n\(sub) \n"
			contador += 1
		}
		return formateado
	}
	
	func produceFrequencyTreesFor(subtexts: [String]) -> String {
		var currentTextIndex = 0;
		var longestTextIndex = 0
		var normalizedSubTexts = [[String]](repeating: [""], count: subtexts.count)
		for tN in subtexts {
			normalizedSubTexts[currentTextIndex] = tN.lowercased().replacingOccurrences(of: " ", with: "").characters.map{String($0)};
			if(tN.characters.count >= subtexts[longestTextIndex].characters.count){
				longestTextIndex = currentTextIndex
			}
			currentTextIndex += 1
		}
		
		var arbolesTodosLosTextos = ""
		currentTextIndex = 0
		for tN in subtexts {
			let freqSubN = calculateNgramFrequency(of: normalizedSubTexts[currentTextIndex], withNgramLength: 1).sorted(by: {$0.1 > $1.1})
			var arbolSubtextoCompleto = ""
			
			for (letra, _) in freqSubN {
				let indexesOfLetra = tN.findIndexesOfAllOccurrences(of: letra)
				var ramaArbolPorLetra = "-\(letra)-"
				
				for index in indexesOfLetra {
					let letterIndexOnPreviousText : String
					let letterIndexOnNextText : String
					
					let previousText = currentTextIndex - 1 >= 0 ? currentTextIndex - 1 : normalizedSubTexts.count - 1
					if previousText == normalizedSubTexts.count - 1{
						
						if index == 0 { //First letter, first text, previous item is last letter of whole text: meaning last letter of the longest subtext
							letterIndexOnPreviousText = "*"//normalizedSubTexts[longestTextIndex][normalizedSubTexts[longestTextIndex].count - 1]
						}else{
							letterIndexOnPreviousText = normalizedSubTexts[previousText][index-1]
						}
					}else{
						letterIndexOnPreviousText = normalizedSubTexts[previousText][index]
					}
					
					if currentTextIndex == longestTextIndex && index == normalizedSubTexts[longestTextIndex].count - 1 { //Last letter longest text next item is first letted of whole text: first letter of the first subtext
						letterIndexOnNextText = "*"//normalizedSubTexts[0][0]
					}else{
						let nextText = currentTextIndex + 1 < normalizedSubTexts.count ? currentTextIndex + 1 : 0
						letterIndexOnNextText = normalizedSubTexts[nextText][index]
					}
					
					
					ramaArbolPorLetra = letterIndexOnPreviousText + ramaArbolPorLetra + letterIndexOnNextText
				}
				arbolSubtextoCompleto += "\(ramaArbolPorLetra)\n"
			}
			
			currentTextIndex += 1
			arbolesTodosLosTextos += "[ T\(currentTextIndex): \(arbolSubtextoCompleto) ]\n"
		}
		return arbolesTodosLosTextos
	}
	
}
