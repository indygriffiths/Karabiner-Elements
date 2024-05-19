import Foundation
import ServiceManagement

enum Subcommand: String {
  case registerCoreDaemons = "register-core-daemons"
  case unregisterCoreDaemons = "unregister-core-daemons"

  case registerCoreAgents = "register-core-agents"
  case unregisterCoreAgents = "unregister-core-agents"

  case registerNotificationWindowAgent = "register-notification-window-agent"
  case unregisterNotificationWindowAgent = "unregister-notification-window-agent"

  case status = "status"
}

func registerService(_ service: SMAppService) {
  do {
    try service.register()
    print("Successfully registered \(service)")
  } catch {
    // Note:
    // When calling `SMAppService.daemon.register`, if user approval has not been granted, an `Operation not permitted` error will be returned.
    // To call `register` for all agents and daemons, the loop continues even if an error occurs.
    // Therefore, only log output will be performed here.
    print("Unable to register \(error)")
  }
}

func unregisterService(_ service: SMAppService) {
  do {
    try service.unregister()
    print("Successfully unregistered \(service)")
  } catch {
    print("Unable to unregister \(error)")
  }
}

RunLoop.main.perform {
  let coreDaemons: [SMAppService] = [
    SMAppService.daemon(plistName: "org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist"),
    SMAppService.daemon(plistName: "org.pqrs.karabiner.karabiner_grabber.plist"),
  ]

  let coreAgents: [SMAppService] = [
    SMAppService.agent(plistName: "org.pqrs.karabiner.agent.karabiner_grabber.plist"),
    SMAppService.agent(plistName: "org.pqrs.karabiner.karabiner_console_user_server.plist"),
    SMAppService.agent(plistName: "org.pqrs.karabiner.karabiner_session_monitor.plist"),
  ]

  let notificationWindowAgentService = SMAppService.agent(
    plistName: "org.pqrs.karabiner.NotificationWindow.plist")

  var allServices: [SMAppService] = []
  for s in coreDaemons {
    allServices.append(s)
  }
  for s in coreAgents {
    allServices.append(s)
  }
  allServices.append(notificationWindowAgentService)

  if CommandLine.arguments.count > 1 {
    let subcommand = CommandLine.arguments[1]

    switch Subcommand(rawValue: subcommand) {
    case .registerCoreDaemons:
      for s in coreDaemons {
        registerService(s)
      }
      exit(0)

    case .unregisterCoreDaemons:
      for s in coreDaemons {
        unregisterService(s)
      }
      exit(0)

    case .registerCoreAgents:
      for s in coreAgents {
        registerService(s)
      }
      exit(0)

    case .unregisterCoreAgents:
      for s in coreAgents {
        unregisterService(s)
      }
      exit(0)

    case .registerNotificationWindowAgent:
      registerService(notificationWindowAgentService)
      exit(0)

    case .unregisterNotificationWindowAgent:
      unregisterService(notificationWindowAgentService)
      exit(0)

    case .status:
      for s in allServices {
        switch s.status {
        case .notRegistered:
          print("\(s) notRegistered")
        case .enabled:
          print("\(s) enabled")
        case .requiresApproval:
          print("\(s) requiresApproval")
        case .notFound:
          print("\(s) notFound")
        @unknown default:
          print("\(s) unknown \(s.status)")
        }
      }
      exit(0)

    default:
      print("Unknown subcommand \(subcommand)")
      exit(1)
    }
  }

  print("Usage:")
  print("    Karabiner-Elements-Services subcommand")
  print("")
  print("Subcommands:")
  print("    \(Subcommand.registerCoreDaemons.rawValue)")
  print("    \(Subcommand.unregisterCoreDaemons.rawValue)")

  print("    \(Subcommand.registerCoreAgents.rawValue)")
  print("    \(Subcommand.unregisterCoreAgents.rawValue)")

  print("    \(Subcommand.registerNotificationWindowAgent.rawValue)")
  print("    \(Subcommand.unregisterNotificationWindowAgent.rawValue)")

  print("    \(Subcommand.status.rawValue)")

  exit(0)
}

RunLoop.main.run()
