import SwiftUI
import Combine

final class PirsonMethodViewModel: ObservableObject {
	enum KnownVolumes: Equatable {
		case twoSubstance
		case resultSubstance
	}
	
	@Published var selected: PirsonMethodViewModel.KnownVolumes = .twoSubstance
	@Published var value1: Decimal = 0
	@Published var concentration1: Decimal = 0
	@Published var value2: Decimal = 0
	@Published var concentration2: Decimal = 0
	@Published var valueResult: Decimal = 0
	@Published var concentrationResult: Decimal = 0
	
	private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
	
	init() {
		print("### PirsonMethodViewModel init")
		let first = Publishers.CombineLatest($value1.removeDuplicates(), $concentration1.removeDuplicates())
		let second = Publishers.CombineLatest($value2.removeDuplicates(), $concentration2.removeDuplicates())
		let result = Publishers.CombineLatest($valueResult.removeDuplicates(), $concentrationResult.removeDuplicates())
		Publishers.CombineLatest3(first, second, result).sink { first, second, result in
			let value1 = first.0; let concentration1 = first.1
			let value2 = second.0; let concentration2 = second.1
			let valueResult = result.0; let concentrationResult = result.1
			switch self.selected {
			case .twoSubstance:
				let substance1 = value1 * concentration1
				let substance2 = value2 * concentration2
				self.valueResult = value1 + value2
				if value1 + value2 > 0 {
					self.concentrationResult = (substance1 + substance2) / (value1 + value2)
				} else {
					self.concentrationResult = 0
				}
			case .resultSubstance:
				let subConcentr1 = abs(concentration2 - concentrationResult)
				let subConcentr2 = abs(concentration1 - concentrationResult)
				if concentration1 >= 0, concentration1 <= 100,
				   concentration2 >= 0, concentration2 <= 100,
				   subConcentr1 + subConcentr2 > 0,
				   (concentration1 != 0 || concentration2 != 0),
				   max(concentration1, concentration2) >= concentrationResult,
				   min(concentration1, concentration2) <= concentrationResult {
					self.value1 = (subConcentr1 * valueResult) / (subConcentr1 + subConcentr2)
					self.value2 = valueResult - value1
				}
				else {
					self.value1 = Decimal.nan
					self.value2 = Decimal.nan
				}
			}
		}
		.store(in: &cancellables)
	}
}

struct PirsonMethodView: View {
	
	@StateObject private var vm = PirsonMethodViewModel()
	
	var body: some View {
		List {
			Picker(":", selection: $vm.selected) {
				Text("Знаем V и ω растворов").tag(PirsonMethodViewModel.KnownVolumes.twoSubstance)
				Text("Знаем V и ω смеси").tag(PirsonMethodViewModel.KnownVolumes.resultSubstance)
			}
			.labelsHidden()
			.listRowSeparator(.hidden)
			.onChange(of: vm.selected) { _ in hideKeyboard() }
			VStack {
				HStack {
					FloatingTextField("V1, мл.", value: $vm.value1)
						.disabled(vm.selected == .resultSubstance)
					FloatingTextField("ω1%", value: $vm.concentration1)
				}
				HStack {
					FloatingTextField("V2, мл.", value: $vm.value2)
						.disabled(vm.selected == .resultSubstance)
					FloatingTextField("ω2%", value: $vm.concentration2)
				}
				HStack {
					FloatingTextField("V смеси, мл.", value: $vm.valueResult)
						.disabled(vm.selected == .twoSubstance)
					FloatingTextField("ω смеси %", value: $vm.concentrationResult)
						.disabled(vm.selected == .twoSubstance)
				}
			}
			.padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
		}
	}
}

struct PirsonMethodView_Previews: PreviewProvider {
	static var previews: some View {
		PirsonMethodView()
	}
}
