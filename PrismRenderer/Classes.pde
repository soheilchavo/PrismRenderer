class Triangle {
  PVector[] vertecies;
  color triangle_color;
  color line_color;
  
  Triangle(PVector[] verts)
  {
    vertecies = verts;
    triangle_color = color(1);
    line_color = color(0);
  }
  
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
  
  Triangle(PVector[] verts, color col){
    vertecies = verts;
    triangle_color = col;
    line_color = col;
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

class Obj{

  Triangle[] obj_triangles;
  Material[] obj_materials;
  int[][] triangle_materials;
  
  PVector position;
  PVector scale;
  PVector rotation;
  
  String name;
  
  Obj(String n, String t, Material[] m, PVector p, PVector s, PVector r){
    this.obj_triangles = new Triangle[1];
    this.obj_materials = m;
    this.scale = s;
    this.rotation = r;
    this.position = p;
    this.name = n;
  }
  
  Obj(String n, Triangle[] t, Material[] m, PVector p, PVector s, PVector r){
    this.obj_triangles = t;
    this.obj_materials = m;
    this.scale = s;
    this.rotation = r;
    this.position = p;
    this.name = n;
  }
  
}

class Material{

  color m_col;
  float m_metalic;
  float m_rough;
  float m_e_strength;
  
  Material(color c, float m, float r, float es){
  
    this.m_col = c;
    this.m_metalic = m;
    this.m_rough = r;
    this.m_e_strength = es;
    
  }
  
}


enum RENDERING_METHOD { wireframe, solid, none };
enum RASTERIZATION_ALGORITHM { painters, pixel };
