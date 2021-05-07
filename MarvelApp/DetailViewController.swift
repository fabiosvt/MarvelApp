import UIKit
import SnapKit
class DetailViewController: UIViewController {
    let photoview: UIImageView
    let label: UILabel
    let hero: Hero
    init(hero: Hero) {
        self.photoview = UIImageView()
        self.label = UILabel()
        self.hero = hero
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        photoview.backgroundColor = UIColor.red
        label.text = self.hero.name
        label.backgroundColor = UIColor.red
        if let http = hero.thumbnail.url {
            var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)!
            comps.scheme = "https"
            if let https = comps.url {
                    let task = URLSession.shared.dataTask(with: https) { data, response, error in
                        guard let data = data, error == nil else { return }
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data) {
                                self.photoview.image = image
                            }
                        }
                    }
                    task.resume()
                }
        }
        self.view.addSubview(photoview)
        self.view.addSubview(label)
        photoview.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.center.equalTo(self.view)
        }
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(photoview.snp.bottom).offset(20)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
}
