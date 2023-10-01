import SwiftUI

struct BackSpaceView: View {
	private let action: () -> Void
	
	init(action: @escaping () -> Void) {
		self.action = action
	}
	
	var body: some View {
		Button {
			self.action()
		} label: {
			Text("⌫").font(Font.largeTitle)
		}
		.frame(width: 60, height: 60)
		.border(.blue)
		.foregroundColor(.blue)
	}
}

struct BackspaceView_Previews: PreviewProvider {
	static var previews: some View {
		BackSpaceView() { }
	}
}
