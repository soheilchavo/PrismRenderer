class Triangle {
  PVector[] vertecies;
  Material mat;
  
  Triangle(PVector[] verts)
  {
    this.vertecies = verts;
    this.mat = new Material(255,255,255, 0, 0, 0);
  }
  
  Triangle(PVector[] verts, Material mat_v)
  {
    this.vertecies = verts;
    this.mat = mat_v;
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
  
  Obj(String n, String t, Material m, PVector p, PVector s, PVector r){
    
    this.obj_triangles = get_prim_tris(t, m);
    
    this.obj_material = m;
    this.scale = s;
    this.rotation = r;
    this.position = p;
    this.name = n;
  }
  
  
}

class Material{

  int[] m_col = new int[3];
  float m_metalic;
  float m_rough;
  float m_e_strength;
  
  Material(int r, int g, int b, float m, float ro, float es){
  
    this.m_col[0] = r;
    this.m_col[1] = g;
    this.m_col[2] = b;
    
    this.m_metalic = m;
    this.m_rough = ro;
    this.m_e_strength = es;
    
  }
  
}

enum RENDERING_METHOD { wireframe, solid, none };
enum RASTERIZATION_ALGORITHM { painters, pixel };
