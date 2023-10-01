import Foundation

public struct Molecule: Equatable {
	public struct Radical: Equatable {
		public let element: Element
		public var count: Int
	}
	
	private var molecule: [Radical]

	public init(molecule: [Radical] = []) {
		self.molecule = molecule
	}
}

extension Molecule
{
	public var molarMass: Decimal {
		self.molecule.reduce(Decimal.zero) { $0 + Decimal($1.count) * $1.element.mass }
	}
	
	public var structure: [Radical] {
		self.molecule
	}
	
	public mutating func append(_ element: Element) {
		if let radical = self.molecule.last, radical.element == element {
			self.molecule[self.molecule.count - 1] = Radical(element: radical.element, count: radical.count + 1)
		}
		else {
			self.molecule.append(Radical(element: element, count: 1))
		}
	}
	
	public mutating func removeLast() {
		if let radical = self.molecule.last {
			if radical.count <= 1 {
				self.molecule.removeLast()
			}
			else {
				self.molecule[self.molecule.count - 1] = Radical(element: radical.element, count: radical.count - 1)
			}
		}
	}
}
