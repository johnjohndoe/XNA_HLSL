float4x4 xViewProjection;

struct PixelToFrame
{
    float4 Color        : COLOR0;
};

struct VertexToPixel
{
    float4 Position     : POSITION;
    float4 Color        : COLOR0;
    float3 Position3D   : TEXCOORD0;
};

PixelToFrame OurFirstPixelShader(VertexToPixel PSIn)
{
    PixelToFrame Output = (PixelToFrame)0;
    Output.Color.rgb = PSIn.Position3D.xyz;
    return Output;
}

VertexToPixel SimplestVertexShader(float4 inPos : POSITION, float4 inColor : COLOR0)
{
    VertexToPixel Output = (VertexToPixel)0;
    Output.Position = mul(inPos, xViewProjection);
    Output.Position3D = inPos;
    return Output;
}

technique Simplest
{
    pass Pass0
    {
        VertexShader = compile vs_1_1 SimplestVertexShader();
        PixelShader = compile ps_1_1 OurFirstPixelShader();
    }
}
