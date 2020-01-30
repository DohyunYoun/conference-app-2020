import Material
import UIKit

final class SidebarViewController: UITableViewController {
    enum SwitchViewControllerType: Int {
        case timeline
        case about
        case info
        case map
        case sponsor
        case contributor
        case setting
    }

    weak var rootViewController: UINavigationController?

    var switchType: SwitchViewControllerType?

    struct Dependency {
        let switchType: SwitchViewControllerType
    }

    func inject(with dependency: Dependency) {
        switchType = dependency.switchType
    }

    static func instantiate(rootViewController: UINavigationController, dependency: Dependency = .init(switchType: .timeline)) -> SidebarViewController {
        guard let viewController = UIStoryboard(name: "SidebarViewController", bundle: .main).instantiateInitialViewController() as? SidebarViewController else { fatalError() }
        viewController.inject(with: dependency)
        viewController.rootViewController = rootViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView?.frame.size.height = 190
        tableView.rowHeight = 65
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // select default cell (timeline)
        let indexPath = IndexPath(row: switchType?.rawValue ?? SwitchViewControllerType.timeline.rawValue, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath), let switchType = SwitchViewControllerType(rawValue: cell.tag) else {
            return
        }

        switch switchType {
        case .timeline:
            if let _ = UIApplication.topViewController() as? FilterViewController {
                navigationDrawerController?.toggleLeftView()
            } else {
                let vc = FilterViewController()
                rootViewController?.pushViewController(vc, animated: true)
                rootViewController?.navigationDrawerController?.toggleLeftView()
            }


        case .about:
            break
        case .info:
            break
        case .map:
            if let _ = UIApplication.topViewController() as? FloorMapViewController {
                navigationDrawerController?.toggleLeftView()
            } else {
                let vc = FloorMapViewController.instantiate()
                rootViewController?.pushViewController(vc, animated: true)
                rootViewController?.navigationDrawerController?.toggleLeftView()
            }

        case .sponsor:
            let vc = SponsorViewController()
            rootViewController?.pushViewController(vc, animated: true)
            rootViewController?.navigationDrawerController?.toggleLeftView()
        case .contributor:
            break
        case .setting:
            break
        }
    }
}
