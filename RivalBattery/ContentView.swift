import SwiftUI

struct ContentView: View {
    func getRivalBattery() -> (Int?, Bool) {
        let command = Process()
        command.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/rivalcfg")
        command.arguments = ["--battery-level"]
        
        let pipe = Pipe()
        
        command.standardOutput = pipe
        do{
            try command.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            
            if let output = String(data: data, encoding: String.Encoding.utf8) {
                let charging = !output.contains("Discharging")
                if output.contains("]") {
                    let i = output.components(separatedBy: "]")[1].components(separatedBy: " %")[0].replacingOccurrences(of: " ", with: "")
                    return (Int(i), charging)
                }
            }
        } catch {}
        return (nil, false)
    }
    @State private var battery: (Int?, Bool) = (nil, false)
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                if battery.0 != nil {
                    Label("Aerox 3 Wireless", systemImage: "computermouse")
                    Spacer()
                    Text(String(battery.0 ?? 0) + " %")
                    Image(systemName: "battery.0")
                    if battery.1 {
                        Image(systemName: "bolt")
                    }
                }
                else {
                    Text("No supported devices connected")
                }
            }
        }.frame(width: 320, height: 240, alignment: .topLeading).padding()
            .onAppear {
                battery = getRivalBattery()
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    battery = getRivalBattery()
                }
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
