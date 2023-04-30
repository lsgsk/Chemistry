import SwiftUI
import Combine
import Calculator

final class MassFractionViewModel: ObservableObject {
	enum Characteristic: String, CaseIterable {
		case substance
		case solvent
		case concentration
	}

	@Published var selected: Characteristic = .concentration

	@Published var substance: Decimal = Decimal.zero
	@Published var solvent: Decimal = Decimal.zero
	@Published var concentration: Decimal = Decimal.zero

	@Published var isSubstanceDisabled = false
	@Published var isSolventDisabled = false
	@Published var isConcentrationDisabled = false

	private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

	init() {
		print("### MassFractionViewModel init")
		$selected.sink { [weak self] selected in
			guard let self else { return }
			switch selected {
			case .substance:
				self.isSubstanceDisabled = true
				self.isSolventDisabled = false
				self.isConcentrationDisabled = false
			case .solvent:
				self.isSubstanceDisabled = false
				self.isSolventDisabled = true
				self.isConcentrationDisabled = false
			case .concentration:
				self.isSubstanceDisabled = false
				self.isSolventDisabled = false
				self.isConcentrationDisabled = true
			}
		}
		.store(in: &cancellables)

		Publishers.CombineLatest4($selected.removeDuplicates(),
								  $substance.removeDuplicates(),
								  $solvent.removeDuplicates(),
								  $concentration.removeDuplicates())
		.sink { [weak self] (selected, substance, solvent, concentration) in
			guard let self else { return }
			switch selected {
			case .substance:
				self.substance = MassFraction(solvent: solvent, concentration: concentration).value
			case .solvent:
				self.solvent = MassFraction(substance: substance, concentration: concentration).value
			case .concentration:
				self.concentration = MassFraction(substance: substance, solvent: solvent).value
			}
		}
		.store(in: &cancellables)
	}
}

struct MassFractionView: View {
	@StateObject private var vm = MassFractionViewModel()
	
	var body: some View {
		List {
			Picker("", selection: $vm.selected) {
				Text("Ищем m вещества")
					.tag(MassFractionViewModel.Characteristic.substance)
				Text("Ищем m растворителя")
					.tag(MassFractionViewModel.Characteristic.solvent)
				Text("Ищем ω (массовую долю)")
					.tag(MassFractionViewModel.Characteristic.concentration)
			}
			.labelsHidden()
			.listRowSeparator(.hidden)
			.onChange(of: vm.selected) { _ in hideKeyboard() }
			VStack {
				FloatingTextField("m вещества:", value: $vm.substance)
					.disabled(vm.isSubstanceDisabled)
				FloatingTextField("m растворителя", value: $vm.solvent)
					.disabled(vm.isSolventDisabled)
				FloatingTextField("ω %:", value: $vm.concentration)
					.disabled(vm.isConcentrationDisabled)
			}
		}
	}
}

struct MassFractionView_Previews: PreviewProvider {
	static var previews: some View {
		MassFractionView()
	}
}
