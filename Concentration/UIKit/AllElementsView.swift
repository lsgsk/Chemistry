import SwiftUI
import Calculator

struct AllElementsView: View {
	private let elementClick: (Element) -> Void
	private let backspaceClick: () -> Void
	
	init(elementClick: @escaping (Element) -> Void,
		 backspaceClick: @escaping () -> Void) {
		self.elementClick = elementClick
		self.backspaceClick = backspaceClick
	}

	var body: some View {
		Grid {
			GridRow {
				ElemetView(.H) { self.elementClick($0) }
				ElemetView(.C) { self.elementClick($0) }
				ElemetView(.N) { self.elementClick($0) }
				ElemetView(.O) { self.elementClick($0) }
				ElemetView(.F) { self.elementClick($0) }
			}
			GridRow {
				ElemetView(.Na) { self.elementClick($0) }
				ElemetView(.P) { self.elementClick($0) }
				ElemetView(.S) { self.elementClick($0) }
				ElemetView(.Cl) { self.elementClick($0) }
				ElemetView(.К) { self.elementClick($0) }
			}
			GridRow {
				ElemetView(.Ca) { self.elementClick($0) }
				ElemetView(.Fe) { self.elementClick($0) }
				ElemetView(.Br) { self.elementClick($0) }
				ElemetView(.I) { self.elementClick($0) }
				BackSpaceView { self.backspaceClick() }
			}
		}
	}
}

struct AllElementsView_Previews: PreviewProvider {
	static var previews: some View {
		AllElementsView(elementClick: { _ in }, backspaceClick: {})
	}
}
