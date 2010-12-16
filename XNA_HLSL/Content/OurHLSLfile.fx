float4x4 xViewProjection;

struct VertexToPixel
{
    float4 Position     : POSITION;
    float4 Color        : COLOR0;
};

VertexToPixel SimplestVertexShader(float4 inPos : POSITION)
{
    VertexToPixel Output = (VertexToPixel)0;

    Output.Position = mul(inPos, xViewProjection);
    Output.Color = 1.0f;
    
    return Output;
}

technique Simplest
{
    pass Pass0
    {
        VertexShader = compile vs_1_1 SimplestVertexShader();
        PixelShader = NULL;
    }
}
