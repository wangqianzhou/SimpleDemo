

#import "CustomPlaneNode.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface CustomPlaneNode()
@property(nonatomic, strong)ARPlaneAnchor* anchor;
@property(nonatomic, strong)SCNPlane* planeGeometry;

@end

@implementation CustomPlaneNode

- (instancetype)initWithPlaneAnchor:(ARPlaneAnchor*)planeAnchor
{
    if (self = [super init])
    {
        self.anchor = planeAnchor;
        self.planeGeometry = [SCNPlane planeWithWidth:planeAnchor.extent.x height:planeAnchor.extent.z];
        
        SCNMaterial* material = [SCNMaterial material];
        UIImage* image = [UIImage imageNamed:@"fabric"];
        material.diffuse.contents = image;
        material.lightingModelName = SCNLightingModelPhysicallyBased;
        
        self.planeGeometry.materials = @[material];
        
        SCNNode* planeNode = [SCNNode nodeWithGeometry:self.planeGeometry];
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        planeNode.transform = SCNMatrix4MakeRotation(-M_PI_2, 1.0, 0, 0);
        
        [self setTextureScale];
        
        [self addChildNode:planeNode];
    }
    
    return self;
}

- (void)setTextureScale
{
    CGFloat w = self.planeGeometry.width;
    CGFloat h = self.planeGeometry.height;
    
    // 平面的宽度/高度 width/height 更新时，我希望 tron grid material 覆盖整个平面，不断重复纹理。
    // 但如果网格小于 1 个单位，我不希望纹理挤在一起，所以这种情况下通过缩放更新纹理坐标并裁剪纹理
    SCNMaterial* material = self.planeGeometry.materials.firstObject;
    material.diffuse.contentsTransform = SCNMatrix4MakeScale(w, h, 1);
    material.diffuse.wrapS = SCNWrapModeRepeat;
    material.diffuse.wrapT = SCNWrapModeRepeat;
}

- (void)update:(ARPlaneAnchor*)planeAnchor
{
    // 随着用户移动，平面 plane 的 范围 extend 和 位置 location 可能会更新。
    // 需要更新 3D 几何体来匹配 plane 的新参数。
    self.planeGeometry.width = planeAnchor.extent.x;
    self.planeGeometry.height = planeAnchor.extent.z;
    
    // plane 刚创建时中心点 center 为 0,0,0，node transform 包含了变换参数。
    // plane 更新后变换没变但 center 更新了，所以需要更新 3D 几何体的位置
    
    self.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
    
    [self setTextureScale];
}

@end
