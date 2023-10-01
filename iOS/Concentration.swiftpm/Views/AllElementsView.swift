import SwiftUI

struct AllElementsView: View {
	private let elementClick: (Element) -> Void
	private let backspaceClick: () -> Void
	
	init(elementClick: @escaping (Element) -> Void,
		 backspaceClick: @escaping () -> Void) {
		self.elementClick = elementClick
		self.backspaceClick = backspaceClick
	}

	var body: some View {
		LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 10) {
			ForEach(Element.allCases, id: \.self) { element in
				ElemetView(element) { self.elementClick($0) }
			}
			BackSpaceView { self.backspaceClick() }
		}
	}
}

struct AllElementsView_Previews: PreviewProvider {
	static var previews: some View {
		AllElementsView(elementClick: { _ in }, backspaceClick: {})
	}
}
