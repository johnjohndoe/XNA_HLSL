float4x4 xWorldViewProjection;
float4x4 xWorld;
Texture xTexture;
bool xSolidBrown;
float3 xLightPos;
float xLightPower;
float xAmbient;

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
    float3 Normal		: TEXCOORD1;
    float3 Position3D	: TEXCOORD2;
};

float DotProduct(float3 lightPos, float3 pos3D, float3 normal)
{
	float3 lightDir = normalize(pos3D - lightPos);
	return dot(-lightDir, normal);
}

PixelToFrame OurFirstPixelShader(VertexToPixel PSIn)
{
    PixelToFrame Output = (PixelToFrame)0;
    
    float diffuseLightingFactor = DotProduct(xLightPos, PSIn.Position3D, PSIn.Normal);
    diffuseLightingFactor = saturate(diffuseLightingFactor);
    diffuseLightingFactor *= xLightPower;
    Output.Color = diffuseLightingFactor;
    
	float4 baseColor = tex2D(TextureSampler, PSIn.TexCoords);
    if (xSolidBrown == true)
        baseColor = float4(0.25f, 0.21f, 0.20f, 1);
    
    Output.Color = baseColor * (diffuseLightingFactor + xAmbient);
    return Output;
}

VertexToPixel SimplestVertexShader(float4 inPos : POSITION, float3 inNormal : NORMAL0, float2 inTexCoords : TEXCOORD0)
{
    VertexToPixel Output = (VertexToPixel)0;
    Output.Position = mul(inPos, xWorldViewProjection);
    Output.TexCoords = inTexCoords;
	Output.Normal = normalize(mul(inNormal, (float3x3)xWorld));
	Output.Position3D = mul(inPos, xWorld);
    return Output;
}

technique Simplest
{
    pass Pass0
    {
        VertexShader = compile vs_2_0 SimplestVertexShader();
        PixelShader = compile ps_2_0 OurFirstPixelShader();
    }
}
