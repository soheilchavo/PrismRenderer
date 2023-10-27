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

class Planetary_Body extends Obj{

  Planetary_Body parent_body; 
  String[] inner_rotational_axes;
  String[] outer_rotational_axes;
  float inter_rotational_speed;
  float outer_rotational_speed;
  
  Planetary_Body(String n, String t, Material m, PVector p, PVector s, PVector r, 
    String[] ira, String[] ora, float irs, float ors){
  
    super(n,t,m,p,s,r);
    this.inner_rotational_axes = ira;
    this.outer_rotational_axes = ora;
    
  }

}


enum RENDERING_METHOD { wireframe, solid, none };
enum RASTERIZATION_ALGORITHM { painters, pixel };
