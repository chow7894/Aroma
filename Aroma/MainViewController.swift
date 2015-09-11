/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/
import UIKit

class MainViewController: UIViewController {
  
  @IBOutlet var scrollView: UIScrollView!
  
  let restaurants = RestaurantDetailService.sharedService.restaurants
  var restaurantViewControllers = [RestaurantDetailViewController]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = restaurants[0].name
    setupScrollView()
  }
  
  func setupScrollView() {
    scrollView.contentSize = CGSize(width: CGRectGetWidth(view.frame) * CGFloat(restaurants.count), height: CGRectGetHeight(view.frame))
    var index = 0
    for restaurant in restaurants {
      let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("RestaurantDetailViewController") as! RestaurantDetailViewController
      detailViewController.restaurant = restaurant
      detailViewController.containingViewController = self
      let x = CGRectGetWidth(view.frame) * CGFloat(index)
      detailViewController.view.frame = CGRect(x: x,
        y: 0,
        width: CGRectGetWidth(detailViewController.view.frame),
        height: CGRectGetHeight(detailViewController.view.frame))
      scrollView.addSubview(detailViewController.view)
      restaurantViewControllers.append(detailViewController)
      index++
    }
  }
  
  func scrollTo(restaurant: Restaurant) {
    if let index = find(restaurants, restaurant) {
      let rect = CGRect(x: CGRectGetWidth(view.frame) * CGFloat(index),
        y: 0,
        width: CGRectGetWidth(view.frame),
        height: CGRectGetHeight(view.frame))
      scrollView.scrollRectToVisible(rect, animated: true)
    }
  }
}

extension MainViewController: UIScrollViewDelegate {
  
  func updateTitle(scrollView: UIScrollView) {
    let currentRestaurantIndex = Int(floor(scrollView.contentOffset.x / CGRectGetWidth(view.frame)))
    if currentRestaurantIndex >= 0 && restaurants.count > currentRestaurantIndex {
      let currentRestaurant = restaurants[currentRestaurantIndex]
      navigationItem.title = currentRestaurant.name
    }
  }
  
  func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
    updateTitle(scrollView)
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    updateTitle(scrollView)
  }
}

