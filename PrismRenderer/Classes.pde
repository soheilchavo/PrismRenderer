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
  color col;
  
  Line(PVector c, PVector d, color t){
    this.a = c;
    this.b = d;
    this.col = t;
  }

}


enum RENDERING_METHOD { wireframe, solid, none };
enum RASTERIZATION_ALGORITHM { painters, pixel };
