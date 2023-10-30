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
  PVector inner_rotational_axes;
  PVector outer_rotational_axes;
  float inner_rotational_speed;
  float outer_rotational_speed;
  float orbit_distance;
  
  Planetary_Body(String n, String t, Material m, PVector p, PVector s, PVector r, 
    PVector ira, PVector ora, float irs, float ors, float ord, String parent){
  
    super(n,t,m,p,s,r);
    this.inner_rotational_axes = ira;
    this.outer_rotational_axes = ora;
    
    if(parent == "None"){ this.parent_body = null; }
    else { this.parent_body = get_object_by_name(parent); }
    
    this.inner_rotational_speed = irs;
    this.outer_rotational_speed = ors;
    this.orbit_distance = ord;
    
  }

}


enum RENDERING_METHOD { wireframe, solid, none };
enum RASTERIZATION_ALGORITHM { painters, pixel };
