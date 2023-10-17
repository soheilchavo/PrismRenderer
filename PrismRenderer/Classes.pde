class Triangle {
  PVector[] vertecies;
  float[] triangle_color;
  
  Triangle(PVector[] verts, float[] col)
  {
    vertecies = verts;
    triangle_color = col;
  }
}


enum RENDERING_METHOD { wireframe_simple, solid, none };
