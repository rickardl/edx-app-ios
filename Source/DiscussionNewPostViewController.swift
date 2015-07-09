//
//  DiscussionNewPostViewController.swift
//  edX
//
//  Created by Tang, Jeff on 6/1/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

import UIKit


class DiscussionNewPostViewControllerEnvironment: NSObject {
    weak var router: OEXRouter?
    let networkManager : NetworkManager?
    
    init(networkManager : NetworkManager, router: OEXRouter?) {
        self.networkManager = networkManager
        self.router = router
    }
}

class DiscussionNewPostViewController: UIViewController, UITextViewDelegate {
    
    private let MIN_HEIGHT : CGFloat = 66 // height for 3 lines of text
    private let environment: DiscussionNewPostViewControllerEnvironment
    private let insetsController = ContentInsetsController()
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var backgroundView: UIView!

    @IBOutlet var newPostView: UIView!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var discussionQuestionSegmentedControl: UISegmentedControl!
    @IBOutlet var bodyTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var topicButton: UIButton!
    @IBOutlet var postDiscussionButton: UIButton!
    private let course: OEXCourse
    
    private let topicsArray: [String]
    private let topics: [DiscussionTopic]
    private let selectedTopic: String
    
    init(env: DiscussionNewPostViewControllerEnvironment, course: OEXCourse, selectedTopic: String, topics: [DiscussionTopic], topicsArray: [String]) {
        self.environment = env
        self.course = course
        self.selectedTopic = selectedTopic
        self.topics = topics
        self.topicsArray = topicsArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func postTapped(sender: AnyObject) {
        postDiscussionButton.enabled = false
        // create new thread (post)
        // TODO: get topic ID from the selected topic name
        
        let json = JSON([
            "course_id" : course.course_id,
            "topic_id" : "b770140a122741fea651a50362dee7e6", // TODO: replace this with real topic ID, selectable from the Topic dropdown in Create a new post UI.
            "type" : "discussion",
            "title" : titleTextField.text,
            "raw_body" : contentTextView.text,
            ])
        
        let apiRequest = DiscussionAPI.createNewThread(json)        
        environment.networkManager?.taskForRequest(apiRequest) {[weak self] result in
            // result.data is optional DiscussionThread; result.data!.title 
            self?.navigationController?.popViewControllerAnimated(true)
            self?.postDiscussionButton.enabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSBundle.mainBundle().loadNibNamed("DiscussionNewPostView", owner: self, options: nil)
        view.addSubview(newPostView)
        newPostView?.autoresizingMask =  UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin
        newPostView?.frame = view.frame
        
        contentTextView.layer.cornerRadius = 10
        contentTextView.layer.masksToBounds = true
        contentTextView.delegate = self
        backgroundView.backgroundColor = OEXStyles.sharedStyles().neutralXLight()
        
        discussionQuestionSegmentedControl.setTitle(OEXLocalizedString("DISCUSSION", nil), forSegmentAtIndex: 0)
        discussionQuestionSegmentedControl.setTitle(OEXLocalizedString("QUESTION", nil), forSegmentAtIndex: 1)
        titleTextField.placeholder = OEXLocalizedString("TITLE", nil)
        topicButton.setTitle(selectedTopic, forState: .Normal)
        
        weak var weakSelf = self
        topicButton.oex_addAction({ (action : AnyObject!) -> Void in
            // TODO: replace the code below and show postsVC.topicsVC.topicsArray in native UI
            for topic in weakSelf!.topics {
                println(">>>> \(topic.name)")
                if topic.children != nil {
                    for child in topic.children! {
                        println("     \(child.name)")
                    }
                }
            }
        }, forEvents: UIControlEvents.TouchUpInside)
        
        postDiscussionButton.setTitle(OEXLocalizedString("POST_DISCUSSION", nil), forState: .Normal)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addAction {[weak self] _ in
            self?.contentTextView.resignFirstResponder()
            self?.titleTextField.resignFirstResponder()
        }
        self.newPostView.addGestureRecognizer(tapGesture)

        self.insetsController.setupInController(self, scrollView: scrollView)

    }
    
    func textViewDidChange(textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSizeMake(fixedWidth, CGFloat.max))
        if newSize.height >= MIN_HEIGHT {
            bodyTextViewHeightConstraint.constant = newSize.height
        }
    }
}