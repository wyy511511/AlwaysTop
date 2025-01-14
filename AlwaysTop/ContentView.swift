//
//  ContentView.swift
//  AlwaysTop
//
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        StickiesView()
            .frame(minWidth: 300, minHeight: 10)
    }
}

struct StickiesView: NSViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            guard let window = view.window else { return }
            window.title = "Stickies Window"
            window.styleMask = [.titled, .closable, .resizable, .miniaturizable]
            window.level = .floating
            window.backgroundColor = NSColor.yellow
            window.isOpaque = true
            window.hasShadow = true
            

            let eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if event.keyCode == 125 { // keyCode 125 is ⬇️
                    captureBottomArea(of: window)
                }
                return event
            }
            

            context.coordinator.eventMonitor = eventMonitor
            

            if let closeButton = window.standardWindowButton(.closeButton) {
                closeButton.target = context.coordinator
                closeButton.action = #selector(Coordinator.onWindowClose)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}

    class Coordinator: NSObject {
        var eventMonitor: Any?

        @objc func onWindowClose() {
            if let eventMonitor = eventMonitor {
                NSEvent.removeMonitor(eventMonitor)
                self.eventMonitor = nil
                print("Remove event monitor")
            }
        }
    }
}



func captureBottomArea(of window: NSWindow) {
    let windowFrame = window.frame
    let captureHeight: CGFloat = 50
    let bottomRect = CGRect(x: windowFrame.origin.x,
                            y: windowFrame.origin.y,
                            width: windowFrame.size.width,
                            height: captureHeight)
    
    guard let cgImage = CGWindowListCreateImage(bottomRect, .optionOnScreenOnly, CGWindowID(window.windowNumber), .bestResolution) else {
        print("‼️ Screenshot failure")
        return
    }

    let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
    let pngData = bitmapRep.representation(using: .png, properties: [:])
    
    //use sandbox for temp file
    let tempDirectory = FileManager.default.temporaryDirectory
    let filePath = tempDirectory.appendingPathComponent("BottomScreenshot.png")
    
    do {
        try pngData?.write(to: filePath)
        print("screenshot saved to : \(filePath)")
    } catch {
        print("Fail to save \(error.localizedDescription)")
    }
}
