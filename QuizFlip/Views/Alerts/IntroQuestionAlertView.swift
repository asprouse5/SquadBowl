//
//  IntroAlertView.swift
//  QuizFlip
//
//  Created by Adriana Sprouse on 6/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class IntroQuestionAlertView: UIView, Modal {

    @IBOutlet var contentView: UIView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var qaGif: UIImageView!

    var backgroundView = UIView()
    var parentViewController: UIViewController?

    convenience init(parent: UIViewController) {
        self.init(frame: UIScreen.main.bounds)
        parentViewController = parent
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        addSubview(backgroundView)

        Bundle.main.loadNibNamed("IntroQuestionAlertView", owner: self, options: nil)
        addSubview(contentView)

        contentView.frame = CGRect(origin: contentView.center,
                                   size: CGSize(width: frame.width * 0.8,
                                                height: frame.height * 0.6))

        infoLabel.setTextSize(label: infoLabel)

        qaGif.loadGif(asset: "qaDemo")
    }

    @IBAction func dismissTriggered(_ sender: Any) {
        dismiss(animated: true)
    }
}
