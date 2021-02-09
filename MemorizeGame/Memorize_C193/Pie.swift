//
//  Pie.swift
//  Memorize_C193
//
//  Created by 김현식 on 2021/01/17.
//

import SwiftUI

struct Pie: Shape { //Shape already has Animatable
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false
    
    var animatableData: AnimatablePair<Double,Double> {
        get{
            AnimatablePair(startAngle.radians,endAngle.radians)
        }
        set{
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    //rect in which where we're supposed to fit out Shape
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x:center.x + radius * cos(CGFloat(startAngle.radians)),
            y:center.y + radius * sin(CGFloat(startAngle.radians))
        )
        //CG : Core Grapics
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
        p.addLine(to: center)
        return p
    }
}
