//
//  CustomPlanNode.h
//  SimpleDemo
//
//  Created by wangqianzhou on 23/01/2018.
//  Copyright © 2018 wangqianzhou. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface CustomPlaneNode : SCNNode

- (instancetype)initWithPlaneAnchor:(ARPlaneAnchor*)planeAnchor;

- (void)update:(ARPlaneAnchor*)planeAnchor;
@end
