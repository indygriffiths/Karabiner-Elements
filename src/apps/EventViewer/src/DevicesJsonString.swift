import SwiftUI

private func callback() {
  guard
    let text = try? String(
      contentsOfFile: DevicesJsonString.shared.deviceDetailsJsonFilePath,
      encoding: .utf8
    )
  else { return }

  Task { @MainActor in
    DevicesJsonString.shared.text = text
  }
}

public class DevicesJsonString: ObservableObject {
  public static let shared = DevicesJsonString()

  let deviceDetailsJsonFilePath = LibKrbn.deviceDetailsJsonFilePath()

  @Published var text = ""

  // We register the callback in the `start` method rather than in `init`.
  // If libkrbn_register_*_callback is called within init, there is a risk that `init` could be invoked again from the callback through `shared` before the initial `init` completes.

  public func start() {
    libkrbn_enable_file_monitors()

    libkrbn_register_file_updated_callback(
      deviceDetailsJsonFilePath.cString(using: .utf8),
      callback)
    libkrbn_enqueue_callback(callback)
  }

  public func stop() {

    libkrbn_unregister_file_updated_callback(
      deviceDetailsJsonFilePath.cString(using: .utf8),
      callback)

    // We don't call `libkrbn_disable_file_monitors` because the file monitors may be used elsewhere.
  }
}
