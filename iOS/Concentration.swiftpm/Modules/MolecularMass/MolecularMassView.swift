import SwiftUI
import Combine

final class MolecularMassViewModel: ObservableObject {
	enum MolecularMassType {
		case base
		case callback((Decimal) -> Void)
	}

	@Published private var molecule = Molecule()
	@Published var molarMass: Decimal = 0
	@Published var formula = AttributedString()
	@Published var mass: String = ""
	@Published var isAsseptHidden: Bool
	@Published var callback: ((Decimal) -> Void)
	private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
	
	init(type: MolecularMassType) {
		print("### MolecularMassViewModel init")
		switch type {
		case .base:
			self.isAsseptHidden = true
			self.callback = { _ in }
		case .callback(let callback):
			self.isAsseptHidden = false
			self.callback = callback
		}
		self.$molecule.sink { molecule in
			self.molarMass = molecule.molarMass
			if molecule.structure.isEmpty {
				self.formula = "Формула вещества"
				self.mass = "0 а.е.м."
			}
			else {
				self.formula = molecule.structure.reduce(into: AttributedString()) {
					$0.append(AttributedString($1.element.symbol))
					if $1.count > 1 {
						var count = AttributedString("\($1.count)")
						count.font = Font.footnote
						$0.append(count)
					}
				}
				self.mass = "\(molecule.molarMass.description) а.е.м."
			}
		}
		.store(in: &cancellables)
	}

	func append(_ element: Element) {
		self.molecule.append(element)
	}

	func removeLast() {
		self.molecule.removeLast()
	}
}

struct MolecularMassView: View {
	
	@StateObject private var vm: MolecularMassViewModel
	
	init(type: MolecularMassViewModel.MolecularMassType = .base) {
		self._vm = StateObject(wrappedValue: MolecularMassViewModel(type: type))
	}
	
	var body: some View {
		List {
			VStack {
				Text(vm.formula)
					.font(.headline)
					.multilineTextAlignment(.center)
					.padding()
				Text(vm.mass.description)
					.font(.subheadline)
			}
			.frame(maxWidth: .infinity)
			.frame(height: 100)
			.listRowSeparator(.hidden)
			AllElementsView(elementClick: { vm.append($0) },
							backspaceClick: { vm.removeLast() })
			.listRowSeparator(.hidden)
			.frame(maxWidth: .infinity)
			Button {
				vm.callback(vm.molarMass)
			} label: {
				Text("Применить")
					.frame(maxWidth: .infinity)
			}
			.padding()
			.buttonStyle(.borderedProminent)
			.listRowSeparator(.hidden)
			.hidden(vm.isAsseptHidden)
		}
		.buttonStyle(PlainButtonStyle())
	}
}

struct MolecularMassView_Previews: PreviewProvider {
	static var previews: some View {
		MolecularMassView(type: .callback({ _ in }))
	}
}
