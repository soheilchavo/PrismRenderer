class Triangle {
  PVector[] vertecies;
  Material mat;
  
  Triangle(PVector[] verts)
  {
    this.vertecies = verts;
    this.mat = new Material(color(1), 0, 0, 0);
  }
  
  Triangle(PVector[] verts, Material mat_v)
  {
    this.vertecies = verts;
    this.mat = mat_v;
  }
  
  Triangle(PVector[] verts, color material_color)
  {
    this.vertecies = verts;
    this.mat = new Material(material_color,0,0,0);
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

public class Obj{

  ArrayList<Triangle> obj_triangles;
  Material obj_material;
  int[][] triangle_materials;
  
  PVector position;
  PVector scale;
  PVector rotation;
  
  String name;
  
  public Obj(String n, String t, Material m, PVector p, PVector s, PVector r){
    
    this.obj_triangles = get_prim_tris(t, m);
    
    this.obj_material = m;
    this.scale = s;
    this.rotation = r;
    this.position = p;
    this.name = n;
  }
  
  Obj(String n, ArrayList<Triangle> t, Material m, PVector p, PVector s, PVector r){
    this.obj_triangles = t;
    this.obj_material = m;
    this.scale = s;
    this.rotation = r;
    this.position = p;
    this.name = n;
  }
  
}

class Material{

  int m_col;
  float m_metalic;
  float m_rough;
  float m_e_strength;
  
  Material(int c, float m, float r, float es){
  
    this.m_col = c;
    this.m_metalic = m;
    this.m_rough = r;
    this.m_e_strength = es;
    
  }
  
}


enum RENDERING_METHOD { wireframe, solid, none };
enum RASTERIZATION_ALGORITHM { painters, pixel };
