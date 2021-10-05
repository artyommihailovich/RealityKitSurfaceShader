//
//  Rainbow.metal
//  Surface
//
//  Created by Artyom Mihailovich on 10/5/21.
//

#include <metal_stdlib>
#include "RealityKit/RealityKit.h"
using namespace metal;

float3 palette(float t, float3 a, float3 b, float3 c, float3 d ) {
    return a + b*cos( 6.28318*(c*t+d) );
}

[[visible]]
void rainbow(realitykit::surface_parameters parameters) {
    auto surface = parameters.surface();
    float2 uv = parameters.geometry().model_position().xy;
    float time = parameters.uniforms().time() * 0.2;
    
    float2 c1 = float2(sin(time)*0.5, cos(parameters.uniforms().time())*0.7);
    float2 c2 = float2(sin(time*0.7)*0.9, cos(parameters.uniforms().time()*0.65)*0.6);
    
    float d1 = length( uv - c1);
    float3 col1 = palette(d1 + time, float3(0.5,0.5,0.5), float3(0.5,0.5,0.5), float3(1.0,1.0,1.0), float3(0.0,0.33,0.67));
    
    float d2 = length( uv - c2);
    float3 col2 = palette(d2 + time, float3(0.5,0.5,0.5), float3(0.5,0.5,0.5), float3(1.0,1.0,1.0), float3(0.0,0.33,0.67));
    
    surface.set_emissive_color(half3(col1+col2) / 2.0);
}
