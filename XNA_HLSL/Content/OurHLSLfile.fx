float4x4 xWorldViewProjection;
Texture xTexture;
bool xSolidBrown;

sampler TextureSampler = sampler_state
{ 
	texture = <xTexture>;
	magfilter = LINEAR;
	minfilter = LINEAR;
	mipfilter=LINEAR;
	AddressU = mirror;
	AddressV = mirror;
};

struct PixelToFrame
{
    float4 Color        : COLOR0;
};

struct VertexToPixel
{
    float4 Position     : POSITION;
    float2 TexCoords    : TEXCOORD0;
};

PixelToFrame OurFirstPixelShader(VertexToPixel PSIn)
{
    PixelToFrame Output = (PixelToFrame)0;
    Output.Color = tex2D(TextureSampler, PSIn.TexCoords);
    if (xSolidBrown == true)
		Output.Color = float4(0.25f, 0.21f, 0.20f, 1);
    return Output;
}

VertexToPixel SimplestVertexShader(float4 inPos : POSITION, float2 inTexCoords : TEXCOORD0)
{
    VertexToPixel Output = (VertexToPixel)0;
    Output.Position = mul(inPos, xWorldViewProjection);
    Output.TexCoords = inTexCoords;
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
