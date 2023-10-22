class Triangle {
  PVector[] vertecies;
  color triangle_color;
  color line_color;
  
  Triangle(PVector[] verts, float[] col)
  {
    vertecies = verts;
    triangle_color = color(col[0], col[1], col[2]);
    line_color = color(col[0], col[1], col[2]);
  }
  
  Triangle(PVector[] verts, color col, color line_col){
    vertecies = verts;
    triangle_color = col;
    line_color = line_col;
  }
}

class Line {

  PVector a;
  PVector b;
  float thickness;
  
  Line(PVector c, PVector d, float t){
    this.a = c;
    this.b = d;
    this.thickness = t;
  }

}


enum RENDERING_METHOD { wireframe, solid, none };
