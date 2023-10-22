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

  float area_of_tri = area_triangle(tri[0], tri[1], tri[2]);

  float area_tri_point_1 = area_triangle(point, tri[1], tri[2]);
  float area_tri_point_2 = area_triangle(tri[0], point, tri[2]);
  float area_tri_point_3 = area_triangle(tri[0], tri[1], point);

  if (((area_tri_point_1+area_tri_point_2+area_tri_point_3) - area_of_tri) <= rasterization_slack)
    return true;
  else
    return false;
}


boolean is_point_on_tri_edge(PVector point, PVector[] tri) {

  float[][] equations = new float[][] {
    get_line_equation(tri[0], tri[1]),
    get_line_equation(tri[1], tri[2]),
    get_line_equation(tri[0], tri[2])
  };

  for (float[] equation : equations) {
    float num = abs(equation[0]*point.x + equation[1]*point.y + equation[2]);
    float dem = sqrt(pow(equation[0],2)+pow(equation[1],2));
    if (num/dem <= line_thickness)
      return true;
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
