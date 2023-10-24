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
    
    //If there is a vertical line
    float[] equation = get_line_equation(comb[0], comb[1]);
    
      float num = abs(equation[0]*point.x + equation[1]*point.y + equation[2]);
      float dem = sqrt(pow(equation[0],2)+pow(equation[1],2));
      
      if (num/dem <= line_thickness)
        return true;
    
    //comb[0] = first vertex of line, comb[1] = second vertex of line
    //point = the point
    
    //PVector closest_point = new PVector();
    
    //PVector ab = comb[1].sub(comb[0]);
    //PVector ap = point.sub(comb[0]);
    
    //float dot_proj = ap.dot(ab);
    //float len_ab_squared = pow(ab.mag(),2);
    //float normal_proj = dot_proj/len_ab_squared;
    
    //if(normal_proj <= 0) { closest_point = comb[0]; }
    //if(normal_proj >= 1) { closest_point = comb[1]; }
    //else { closest_point = comb[0].add(ab.mult(normal_proj)); }
    
    //if(dist(closest_point.x,closest_point.y,point.x,point.y) <= line_thickness) { return true; }
  }

  return false;
}


PVector get_triangle_normal(PVector[] tri) {
  //Find the two vectors that are coplanar to the triangle (plane)
  PVector AB = new PVector(tri[1].x - tri[0].x, tri[1].y - tri[0].y, tri[1].z - tri[0].z );
  PVector AC = new PVector(tri[2].x - tri[0].x, tri[2].y - tri[0].y, tri[2].z - tri[0].z );
  //Get normal vector by taking their cross product
  PVector n = normalize_vector(vector_cross_product(AB, AC));
  return n;
}

float get_tri_point_depth(PVector[] tri, PVector point_screen) {
  //Find the equation of the plane
  //Get normal vector of triangle
  
  PVector point = new PVector();
  
  PVector u = get_triangle_normal(tri);
  
  point = to_global_coords_point(point_screen);

  //Calculate constant in plane equation
  float k = -(u.x*(tri[0].x)+u.y*(tri[0].y)+u.z*(tri[0].z));

  //plug point in to get the z coord
  point.z = -(k + u.x*point.x + u.y*point.y)/u.z;
  //println(u,k);

  //return distance of point from camera
  //return dist_3d(point, camera_vector);
  return point.z;
}
