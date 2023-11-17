PVector[] to_screen_coords(PVector[] global_coords) //Projects 3d points to flat screen
{
  PVector[] screen_coords = new PVector[global_coords.length];
  
  float[][] transform_matrix = matrix_3x3_multiply(calculate_x_z_plane(PrismRenderer.camera_x_angle), calculate_y_z_plane(PrismRenderer.camera_y_angle));
  transform_matrix = matrix_3x3_multiply(transform_matrix, calculate_x_y_plane(radians(camera_z_angle)));
  
  for (int i = 0; i < global_coords.length; i++) {
    screen_coords[i] = vector_matrix_multiply(global_coords[i], transform_matrix);
    screen_coords[i].x = screen_coords[i].x*camera_fov + camera_x_shift + width/2;
    screen_coords[i].y = screen_coords[i].y*camera_fov + camera_y_shift + height/2;
  }
  
  return screen_coords;
}

PVector[] translate_obj(PVector[] coords, Obj object) //Translates object verteicies by the object transformations
{
  PVector[] translated_coords = new PVector[coords.length];
  
  float[][] transform_matrix = matrix_3x3_multiply(calculate_x_z_plane(radians(object.rotation.x)), calculate_y_z_plane(radians(object.rotation.y)));
  transform_matrix = matrix_3x3_multiply(transform_matrix, calculate_x_y_plane(radians(object.rotation.z)));
  
  for (int i = 0; i < coords.length; i++) {
    translated_coords[i] = vector_matrix_multiply(coords[i], transform_matrix);
    
    translated_coords[i].x = (translated_coords[i].x + object.position.x)*object.scale.x;
    translated_coords[i].y = (translated_coords[i].y + object.position.y)*object.scale.y;
    translated_coords[i].z = (translated_coords[i].z + object.position.z)*object.scale.z;
  }
  
  return translated_coords;
}

PVector to_global_coords_point(PVector screen_coords) //Reverses screen projection for one point
{
  PVector global_coords = new PVector();
  
  global_coords.x = (screen_coords.x + camera_x_shift + width/2)/camera_fov;
  global_coords.y = (screen_coords.y + camera_y_shift + height/2)/camera_fov;
  global_coords.z = screen_coords.z;
  
  return global_coords;
}

PVector[] to_global_coords_tri(PVector[] screen_coords) //Reverses projection for a triangle
{
  PVector[] global_coords = new PVector[screen_coords.length];
  
  for(int i = 0; i < screen_coords.length; i++){
    global_coords[i] = to_global_coords_point(screen_coords[i]);
  }
  
  return global_coords;
}

PVector to_screen_coords_point(PVector local_coords) //Reverse projection for a point
{
  PVector screen_coords = new PVector();
  
  float[][] transform_matrix = matrix_3x3_multiply(calculate_x_z_plane(camera_x_angle), calculate_y_z_plane(camera_y_angle));
  
  screen_coords.x = (local_coords.x + camera_x_shift + width/2)/camera_fov;
  screen_coords.y = (local_coords.y + camera_y_shift + height/2)/camera_fov;
  screen_coords.z = local_coords.z;
  
  screen_coords = vector_matrix_multiply(local_coords, transform_matrix);
  
  return screen_coords;
}

PVector vector_matrix_multiply(PVector vector, float[][] matrix)
{
  PVector r = new PVector();
  r.x = vector.x*matrix[0][0] + vector.y*matrix[1][0] + vector.z*matrix[2][0];
  r.y = vector.x*matrix[0][1] + vector.y*matrix[1][1] + vector.z*matrix[2][1];
  r.z = vector.x*matrix[0][2] + vector.y*matrix[1][2] + vector.z*matrix[2][2];
  return r;
}

float[][] matrix_3x3_multiply(float[][] matrix1, float[][] matrix2)
{
  float[][] r = new float[3][3];
  for (int c = 0; c < 3; c++)
  {
    for (int i = 0; i < 3; i++)
    {
      r[c][i] = matrix1[c][0]*matrix2[0][i] + matrix1[c][1]*matrix2[1][i] + matrix1[c][2]*matrix2[2][i];
    }
  }
  return r;
}

float[][] calculate_y_z_plane(float angle)
{
  float[][] rot_matrix = {{1, 0, 0}, {0, cos(angle), sin(angle)}, {0, -sin(angle), cos(angle)}};
  return rot_matrix;
}

float[][] calculate_x_y_plane(float angle)
{
  float[][] rot_matrix = {{cos(angle), -sin(angle), 0}, {sin(angle), cos(angle), 0}, {0, 0, 1}};
  return rot_matrix;
}

float[][] calculate_x_z_plane(float angle)
{
  float[][] rot_matrix = {{cos(angle), 0, -sin(angle)}, {0, 1, 0}, {sin(angle), 0, cos(angle)}};
  return rot_matrix;
}

float[][] calculate_inv_y_z_plane(float angle)
{
  float[][] rot_matrix = {{1, 0, 0}, {0, cos(angle), -sin(angle)}, {0, sin(angle), cos(angle)}};
  return rot_matrix;
}

float[][] calculate_inv_x_z_plane(float angle)
{
  float[][] rot_matrix = {{cos(angle), 0, sin(angle)}, {0, 1, 0}, {-sin(angle), 0, cos(angle)}};
  return rot_matrix;
}

float clamp(float val, float min, float max)
{
  if (val < min) {
    return min;
  }
  if (val > max) {
    return max;
  }
  return val;
}

int pixel_from_pos(int x, int y) {
  return x + (y*width);
}

float dist_3d(PVector a, PVector b) {
  return sqrt(pow(a.x-b.x, 2)+ pow(a.y-b.y, 2)+ pow(a.z-b.z, 2));
}

void calc_camera_vector() {
  camera_vector.x = camera_fov*sin(camera_y_angle)*cos(camera_x_angle);
  camera_vector.y = camera_fov*sin(camera_y_angle)*sin(camera_x_angle);
  camera_vector.z = camera_fov*cos(camera_y_angle);
}

PVector vector_cross_product(PVector a, PVector b) {
  return new PVector(
    a.y*b.z - a.z*b.y,
    a.z*b.x - a.x*b.z,
    a.x*b.y - a.y*b.x
  );
}

float vector_dot_product(PVector a, PVector b) {
  return (a.mag())*(b.mag())*cos(angle_between_vectors(a,b));
}

float angle_between_vectors(PVector a, PVector b){
  return asin(vector_cross_product(a,b).mag()/(a.mag()*b.mag()));
}

PVector normalize_vector(PVector v) {

  float len = dist_3d(new PVector(0, 0, 0), v);
  return new PVector(v.x/len, v.y/len, v.z/len);
}

float[] get_line_equation(PVector vert_1, PVector vert_2) { //Equation of a line from two points

  float a = vert_2.y-vert_1.y;
  float b = vert_1.x-vert_2.x;
  float c = a*(vert_1.x)+b*(vert_1.y);

  return new float[] {a,b,-c};
}

float side_length_of_tri(PVector a, PVector b) {
  return dist(a.x, a.y, b.x, b.y);
}

float area_triangle(PVector a_p, PVector b_p, PVector c_p) { //Heron's formula, provided by Jim Wang
  float a = side_length_of_tri(a_p, b_p);
  float b = side_length_of_tri(b_p, c_p);
  float c = side_length_of_tri(a_p, c_p);
  float s = (a+b+c)/2;

  return sqrt(s*(s-a)*(s-b)*(s-c));
}
