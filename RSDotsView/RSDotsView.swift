//
//  MHDotsView.swift
//  RSDotsView
//
//  Created by Remi Santos on 10/10/2014.
//  Copyright (c) 2014 Remi Santos. All rights reserved.
//

import UIKit


private class RSDotView: UIView {
  var fillColor: UIColor = .blackColor()
  var diameter: CGFloat = 1
  var shadow = false

  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    fillColor.setFill()
    if shadow {
      CGContextAddEllipseInRect(context,(CGRectMake (2, 1, diameter-4, diameter-4)))
      CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 2, UIColor(white: 0, alpha: 0.2).CGColor)
    } else {
      CGContextAddEllipseInRect(context,(CGRectMake (0, 0, diameter, diameter)))
    }
    CGContextDrawPath(context, .Fill)
    CGContextStrokePath(context)
  }

  var animating: Bool {
    return !(layer.animationKeys()?.isEmpty ?? true)
  }
}


public class RSDotsView: UIView {

  @IBInspectable public var dotsColor: UIColor = .blackColor() {
    didSet { buildView() }
  }

  public var dotsShadow: Bool = false {
    didSet { buildView() }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    buildView()
  }

  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    buildView()
  }

  private func buildView() {
    subviews.forEach { $0.removeFromSuperview() }
    let numberDots: CGFloat = 3

    let margin: CGFloat = dotsShadow ? 2 : 5
    let dotDiameter: CGFloat = dotsShadow ? 14 : 9
    let centerWidth = (dotDiameter * numberDots) + (margin * (numberDots - 1))
    var dotFrame = CGRectMake((self.frame.width - centerWidth) / 2, self.bounds.size.height/2 - dotDiameter/2, dotDiameter, dotDiameter)

    for _ in 0..<Int(numberDots) {
      let dot = RSDotView(frame: dotFrame)
      dot.diameter = dotFrame.size.width
      dot.fillColor = dotsColor
      dot.shadow = dotsShadow
      dot.backgroundColor = .clearColor()

      addSubview(dot)
      dotFrame.origin.x += margin + dotDiameter
    }
  }

  public func showAndStartAnimating() {
    hidden = false
    animating = true
  }

  public func hideAndStopAnimating() {
    hidden = true
    animating = false
  }

  public var animating: Bool = false {
    didSet {
      if animating == oldValue { return }
      if animating { animation() }
    }
  }

  public var scale: CGFloat = 1 {
    didSet {
      for dot in subviews as! [RSDotView] {
        if !dot.animating {
          dot.transform = CGAffineTransformMakeScale(scale, scale)
        }
      }
    }
  }

  private func animation() {
    if !animating { return }
    for dot in subviews as! [RSDotView] {
      if dot.animating {
        return dispatch_async(dispatch_get_main_queue(), animation)
      }
    }
    for (i, dot) in subviews.enumerate() {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(i) * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        self.oneAnimation(dot as! RSDotView)
      }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), animation)
  }

  private func oneAnimation(dot: RSDotView) {
    if dot.animating {
      return dispatch_async(dispatch_get_main_queue()) { self.oneAnimation(dot) }
    }
    UIView.animateWithDuration(0.5, animations: {
      dot.transform = CGAffineTransformMakeScale(0.01, 0.01)
    }) { _ in
      UIView.animateWithDuration(0.5) {
        dot.transform = CGAffineTransformIdentity
      }
    }
  }
}