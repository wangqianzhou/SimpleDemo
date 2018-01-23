//
//  ViewController.m
//  SimpleDemo
//
//  Created by wangqianzhou on 13-12-15.
//  Copyright (c) 2013年 wangqianzhou. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import "CustomPlaneNode.h"

@interface ViewController ()<ARSessionDelegate, ARSCNViewDelegate>
@property(nonatomic, strong)ARSCNView* sceneView;
@property(nonatomic, strong)NSMutableDictionary* planes;
@end

@implementation ViewController
- (void)loadView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    UIView* mainView = [[UIView alloc] initWithFrame:screen];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    self.view = mainView;
    
    _sceneView = [[ARSCNView alloc] initWithFrame:mainView.bounds];
    [mainView addSubview:_sceneView];
    
//    SCNDebugOptionShowPhysicsShapes                                                                  = 1 << 0, //show physics shape
//    SCNDebugOptionShowBoundingBoxes                                                                  = 1 << 1, //show object bounding boxes
//    SCNDebugOptionShowLightInfluences                                                                = 1 << 2, //show objects's light influences
//    SCNDebugOptionShowLightExtents                                                                   = 1 << 3, //show light extents
//    SCNDebugOptionShowPhysicsFields                                                                  = 1 << 4, //show SCNPhysicsFields forces and extents
//    SCNDebugOptionShowWireframe                                                                      = 1 << 5, //show wireframe on top of objects
//    SCNDebugOptionRenderAsWireframe API_AVAILABLE(macos(10.13), ios(11.0), tvos(11.0), watchos(4.0)) = 1 << 6, //render objects as wireframe
//    SCNDebugOptionShowSkeletons     API_AVAILABLE(macos(10.13), ios(11.0), tvos(11.0), watchos(4.0)) = 1 << 7, //show skinning bones
//    SCNDebugOptionShowCreases       API_AVAILABLE(macos(10.13), ios(11.0), tvos(11.0), watchos(4.0)) = 1 << 8, //show subdivision creases
//    SCNDebugOptionShowConstraints   API_AVAILABLE(macos(10.13), ios(11.0), tvos(11.0), watchos(4.0)) = 1 << 9, //show slider constraint
//    SCNDebugOptionShowCameras       API_AVAILABLE(macos(10.13), ios(11.0), tvos(11.0), watchos(4.0)) = 1 << 10 //show cameras
    
    _sceneView.debugOptions = 0x11111111111;
    
    _planes = [NSMutableDictionary dictionary];
}

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(@available(iOS 11.0, *))
    {
        ARWorldTrackingConfiguration* config = [[ARWorldTrackingConfiguration alloc] init];
        config.planeDetection = ARPlaneDetectionHorizontal;

        
        _sceneView.delegate = self;
        _sceneView.session.delegate = self;
        [_sceneView.session runWithConfiguration:config];
        
        _sceneView.showsStatistics = YES;
        
        
        SCNScene* scene = [SCNScene scene];
        
        SCNBox* box = [SCNBox boxWithWidth:0.5 height:0.5 length:0.5 chamferRadius:0];
        
        SCNNode* boxNode = [SCNNode nodeWithGeometry:box];
        boxNode.position = SCNVector3Make(0, 0, -1);
        
        [scene.rootNode addChildNode:boxNode];
        
        _sceneView.scene = scene;

    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_sceneView.session pause];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return 0;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark- ARSessionDelegate

/**
 This is called when a new frame has been updated.
 
 @param session The session being run.
 @param frame The frame that has been updated.
 */
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
//    NSLog(@"%s", __FUNCTION__);
}

/**
 This is called when new anchors are added to the session.
 
 @param session The session being run.
 @param anchors An array of added anchors.
 */
- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"%s", __FUNCTION__);
}

/**
 This is called when anchors are updated.
 
 @param session The session being run.
 @param anchors An array of updated anchors.
 */
- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"%s", __FUNCTION__);
}

/**
 This is called when anchors are removed from the session.
 
 @param session The session being run.
 @param anchors An array of removed anchors.
 */
- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark- ARSCNViewDelegate

/**
 Implement this to provide a custom node for the given anchor.
 
 @discussion This node will automatically be added to the scene graph.
 If this method is not implemented, a node will be automatically created.
 If nil is returned the anchor will be ignored.
 @param renderer The renderer that will render the scene.
 @param anchor The added anchor.
 @return Node that will be mapped to the anchor or nil.
 */
//- (nullable SCNNode *)renderer:(id <SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor
//{
//    NSLog(@"%s", __FUNCTION__);
//    return nil;
//}

/**
 Called when a new node has been mapped to the given anchor.
 
 @param renderer The renderer that will render the scene.
 @param node The node that maps to the anchor.
 @param anchor The added anchor.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"%s", __FUNCTION__);
    
    ARPlaneAnchor* planeAnchor = (ARPlaneAnchor*)anchor;
    if (![planeAnchor isKindOfClass:[ARPlaneAnchor class]])
    {
        return ;
    }
    
    CustomPlaneNode* planeNode = [[CustomPlaneNode alloc] initWithPlaneAnchor:planeAnchor];
    [self.planes setObject:planeNode forKey:planeAnchor.identifier];
    
    [node addChildNode:planeNode];   
}

/**
 Called when a node will be updated with data from the given anchor.
 
 @param renderer The renderer that will render the scene.
 @param node The node that will be updated.
 @param anchor The anchor that was updated.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"%s", __FUNCTION__);
}

/**
 Called when a node has been updated with data from the given anchor.
 
 @param renderer The renderer that will render the scene.
 @param node The node that was updated.
 @param anchor The anchor that was updated.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"%s", __FUNCTION__);
    
    // Update content only for plane anchors and nodes matching the setup created in `renderer(_:didAdd:for:)`.
    ARPlaneAnchor* planeAnchor = (ARPlaneAnchor*)anchor;
    if (![planeAnchor isKindOfClass:[ARPlaneAnchor class]])
    {
        return ;
    }
    
    CustomPlaneNode* planeNode = [self.planes objectForKey:planeAnchor.identifier];
    [planeNode update:planeAnchor];
}

/**
 Called when a mapped node has been removed from the scene graph for the given anchor.
 
 @param renderer The renderer that will render the scene.
 @param node The node that was removed.
 @param anchor The anchor that was removed.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"%s", __FUNCTION__);
    
    ARPlaneAnchor* planeAnchor = (ARPlaneAnchor*)anchor;
    if (![planeAnchor isKindOfClass:[ARPlaneAnchor class]])
    {
        return ;
    }
    
    [self.planes removeObjectForKey:planeAnchor.identifier];
}

@end
