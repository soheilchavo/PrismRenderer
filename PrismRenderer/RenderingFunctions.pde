PVector [] get_rect_bounds_of_tri(PVector[] verts) {

  int minX = width;
  int maxX = 0;
  int minY = width;
  int maxY = 0;

  for (PVector vert : verts) {
    minX = min(int(vert.x), minX);
    minY = min(int(vert.y), minY);
    maxX = max(int(vert.x), maxX);
    maxY = max(int(vert.y), maxY);
  }
  PVector[] pixel_values = new PVector[(minX-maxX)*(minY-maxY)];

  int current_y = minY;
  int current_x = minX;

  for (int i = 0; i < pixel_values.length; i++) {

    if (current_x == maxX) {
      current_x = minX;
      current_y++;
    }
    current_x++;

    pixel_values[i] = new PVector(0, 0);
    if (current_x < width && current_y < height && current_x > 0 && current_y > 0)
      pixel_values[i] = new PVector(current_x, current_y);
  }
  return pixel_values;
}

int [] get_rect_indecies_of_tri(PVector[] values) {

  int[] pixel_indecies = new int[values.length];

  for (int i = 0; i < values.length; i++) {
    pixel_indecies[i] = pixel_from_pos(round(values[i].x), round(values[i].y));
  }

  return pixel_indecies;
}

boolean is_point_in_tri(PVector point, PVector[] tri) {

  ////OLD RAST ALG
  //float area_of_tri = area_triangle(tri[0], tri[1], tri[2]);

  //float area_tri_point_1 = area_triangle(point, tri[1], tri[2]);
  //float area_tri_point_2 = area_triangle(tri[0], point, tri[2]);
  //float area_tri_point_3 = area_triangle(tri[0], tri[1], point);

  //if (((area_tri_point_1+area_tri_point_2+area_tri_point_3) - area_of_tri) <= rasterization_slack)
  //  return true;
  //else
  //  return false;
  
  //New RAST ALG (WAY FASTER)
  
  float d1, d2, d3;
  boolean has_neg, has_pos;

  d1 = sign(point, tri[0], tri[1]);
  d2 = sign(point, tri[1], tri[2]);
  d3 = sign(point, tri[2], tri[0]);

  has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0);
  has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0);

  return !(has_neg && has_pos);
  
}

float sign (PVector p1, PVector p2, PVector p3)
{
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
}

boolean is_point_on_shape_edge(PVector point, PVector[] shape) {
  
  PVector[][] combanations = new PVector[shape.length][3];
  for(int i = 0; i < shape.length; i++){
    
    if(i == shape.length-1)
      combanations[i] = new PVector[] {shape[0], shape[i]};
    else
      combanations[i] = new PVector[] {shape[i], shape[i+1]};
  }

  for (PVector[] comb : combanations) {
    
    PVector a = comb[0];
    PVector b = comb[1];
    
    float distance = 
      ( (b.x-a.x)*(point.y-a.y)-(b.y-a.y)*(point.x-a.x) )/
      ( sqrt( pow((b.x-a.x),2)+pow((b.y-a.y),2) ) );
    
    if(abs(distance) <= line_thickness) { return true; }
  }

  return false;
}


PVector get_triangle_normal(PVector[] tri) {
  //Find the two vectors that are coplanar to the triangle (plane)
  PVector AB = new PVector(tri[1].x - tri[0].x, tri[1].y - tri[0].y, tri[1].z - tri[0].z );
  PVector AC = new PVector(tri[2].x - tri[1].x, tri[2].y - tri[1].y, tri[2].z - tri[1].z );
  //Get normal vector by taking their cross product
  PVector n = normalize_vector(vector_cross_product(AB, AC));
  return n;
}

float calculate_k_constant(PVector vertex, PVector normal){
  return (normal.x*(vertex.x)+normal.y*(vertex.y)+normal.z*(vertex.z));
}

float calculate_z_from_plane(float k, PVector n, PVector point){
  return (-k + n.x*point.x + n.y*point.y)/n.z;
}

float get_tri_point_depth(PVector[] tri, PVector point_screen) {
  //Find the equation of the plane
  //Get normal vector of triangle
  
  PVector global_point = to_global_coords_point(point_screen);
  PVector[] global_tri = to_global_coords_tri(tri);
  
  PVector u = get_triangle_normal(global_tri);
  
  //point = point_screen;
  //Calculate constant in plane equation
  float k = calculate_k_constant(global_tri[0], u);

  //plug point in to get the z coord
  global_point.z = calculate_z_from_plane(k,u,global_point);

  //return distance of point from camera
  //return dist_3d(point, camera_vector);
  return global_point.z;
}

color point_lighting(Triangle tri, float depth){
  
  PVector[] global_tri = to_global_coords_tri(tri.vertecies);
  
  PVector u = get_triangle_normal(global_tri);
  
  float l = depth;
  
  return color(l*tri.mat.m_col[0], l*tri.mat.m_col[1], l*tri.mat.m_col[2]);

}
