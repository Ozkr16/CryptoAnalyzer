//
//  Utilities.swift
//  CryptoAnalyzer
//
//  Created by Oscar Gutierrez C on 18/2/17.
//  Copyright © 2017 Trilobytes. All rights reserved.
//

import Foundation

extension String {
	func findIndexesOfAllOccurrences(of another : String) -> [Int] {
		
		var foundRange : Range<String.Index>? = Range<String.Index>(uncheckedBounds: (self.startIndex, self.endIndex))
		var indexes = [Int]()
		
		repeat {
			//let index = currentRange?.lowerBound
			foundRange = self.range(of: another, options: String.CompareOptions.caseInsensitive, range: foundRange, locale: nil)
			
			if let actualRange = foundRange {
				indexes.append(self.distance(from: self.startIndex, to: actualRange.lowerBound))
				foundRange = Range<String.Index>(uncheckedBounds: (self.index(after: actualRange.lowerBound), self.endIndex))
			}
		} while foundRange != nil
		
		return indexes
	}
}
