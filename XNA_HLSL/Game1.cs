using System;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.GamerServices;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Net;
using Microsoft.Xna.Framework.Storage;

namespace XNAseries3
{
    public class Game1 : Microsoft.Xna.Framework.Game
    {
        struct MyOwnVertexFormat
        {
            private Vector3 position;
            private Vector2 texCoord;

            public MyOwnVertexFormat(Vector3 position, Vector2 texCoord)
            {
                this.position = position;
                this.texCoord = texCoord;
            }
            public static VertexElement[] VertexElements =
            {
                // Describes position.
                new VertexElement(0, 0, VertexElementFormat.Vector3, VertexElementMethod.Default, VertexElementUsage.Position, 0),
                // Describes color. The stream offset equals the size of position.
                new VertexElement(0, sizeof(float)*3, VertexElementFormat.Vector2, VertexElementMethod.Default, VertexElementUsage.TextureCoordinate, 0),
            };
            // Number of bytes that 1 vertex occupies in memory.
            public static int SizeInBytes = sizeof(float) * (3 + 2);
        }
        
        GraphicsDeviceManager graphics;
        GraphicsDevice device;

        Effect effect;
        Matrix viewMatrix;
        Matrix projectionMatrix;
        VertexBuffer vertexBuffer;
        VertexDeclaration vertexDeclaration;
        Vector3 cameraPos;

        Texture2D streetTexture;

        public Game1()
        {
            graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = "Content";
        }

        protected override void Initialize()
        {
            graphics.PreferredBackBufferWidth = 500;
            graphics.PreferredBackBufferHeight = 500;
            graphics.IsFullScreen = false;
            graphics.ApplyChanges();
            Window.Title = "Riemer's XNA Tutorials -- Series 3 -- HLSL";

            base.Initialize();
        }

        protected override void LoadContent()
        {
            device = GraphicsDevice;

            effect = Content.Load<Effect>("OurHLSLfile");
            streetTexture = Content.Load<Texture2D>("streettexture");
            SetUpVertices();
            SetUpCamera();
        }

        private void SetUpVertices()
        {
            MyOwnVertexFormat[] vertices = new MyOwnVertexFormat[3];

            vertices[0] = new MyOwnVertexFormat(new Vector3(-2, 2, 0), new Vector2(0.0f, 0.0f));
            vertices[1] = new MyOwnVertexFormat(new Vector3(2, -2, -2), new Vector2(0.125f, 1.0f));
            vertices[2] = new MyOwnVertexFormat(new Vector3(0, 0, 2), new Vector2(0.25f, 0.0f));

            vertexBuffer = new VertexBuffer(device, vertices.Length * MyOwnVertexFormat.SizeInBytes, BufferUsage.WriteOnly);
            vertexBuffer.SetData(vertices);

            vertexDeclaration = new VertexDeclaration(device, MyOwnVertexFormat.VertexElements);
        }

        private void SetUpCamera()
        {
            cameraPos = new Vector3(0, 5, 6);
            viewMatrix = Matrix.CreateLookAt(cameraPos, new Vector3(0, 0, 1), new Vector3(0, 1, 0));
            projectionMatrix = Matrix.CreatePerspectiveFieldOfView(MathHelper.PiOver4, device.Viewport.AspectRatio, 1.0f, 200.0f);
        }

        protected override void UnloadContent()
        {
        }

        protected override void Update(GameTime gameTime)
        {
            KeyboardState keyState = Keyboard.GetState();

            // Allows to exit the game.
            if (keyState.IsKeyDown(Keys.Escape))
                this.Exit();

            base.Update(gameTime);
        }

        protected override void Draw(GameTime gameTime)
        {
            device.Clear(ClearOptions.Target | ClearOptions.DepthBuffer, Color.DarkSlateBlue, 1.0f, 0);

            effect.CurrentTechnique = effect.Techniques["Simplest"];
            effect.Parameters["xViewProjection"].SetValue(viewMatrix * projectionMatrix);
            effect.Parameters["xTexture"].SetValue(streetTexture);
            effect.Begin();
            foreach (EffectPass pass in effect.CurrentTechnique.Passes)
            {
                pass.Begin();
                device.VertexDeclaration = vertexDeclaration;
                device.Vertices[0].SetSource(vertexBuffer, 0, MyOwnVertexFormat.SizeInBytes);
                device.DrawPrimitives(PrimitiveType.TriangleList, 0, 1);
                pass.End();
            }
            effect.End();

            base.Draw(gameTime);
        }
    }
}
