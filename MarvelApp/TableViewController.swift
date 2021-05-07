import UIKit
private let baseURL = "https://gateway.marvel.com/v1/public/characters?"
private let apiKey = "cb1b120ff85906ee9b983956ff29e5b6"
private let secret = "40ed3ff049eea11fbbe6e53cbe08470d51fd03e6"
class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let tableView = UITableView()
    var heroes: [Hero] = []
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    var loadingHeroes = false
    var currentPage = 0
    var total = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Marvel"
        setupTableView()
        loadHeroes()
    }
    func setupTableView() {
        let headerView:UIView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:60))
        let label = UILabel(frame:CGRect(x:20, y:20, width:180,height:30))
        label.text = "Marvel Heroes"
        label.textColor = UIColor.white
        headerView.addSubview(label)
        headerView.backgroundColor = UIColor.red
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    func loadHeroes() {
        guard !loadingHeroes else {
          return
        }
        loadingHeroes = true
        APIClient.loadHeroes(page: currentPage) { (info) in
            if let info = info {
                self.heroes += info.data.results
                self.total = info.data.total
                self.currentPage += 1
                DispatchQueue.main.async {
                    self.loadingHeroes = false
                    self.label.text = "Não foram encontrados mais heróis."
                    self.tableView.reloadData()
                }
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return heroes.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "identifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = heroes[indexPath.row].name
        cell?.detailTextLabel?.text = heroes[indexPath.row].description
        cell?.detailTextLabel?.font = UIFont .systemFont(ofSize: CGFloat(13))
        cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell!
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(heroes[indexPath.row])
        let push = DetailViewController(hero: heroes[indexPath.row])
        self.present(push, animated: true, completion: nil)
    }
    private func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.init(rawValue: 1)!
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.height * 4) && !loadingHeroes {
            loadHeroes()
        }
    }
}
