//Projects 3d points to flat screen
PVector[] to_screen_coords(PVector[] global_coords)
{
  //new PVector for the result of the matrix multiplication
  PVector[] r = new PVector[global_coords.length];
  //transform matrix, which is the multiplication of the x_z and y_z plane rotations
  float[][] transform_matrix = matrix_3x3_multiply(calculate_x_z_plane(PrismRenderer.camera_x_angle), calculate_y_z_plane(PrismRenderer.camera_y_angle));
  //multiply all vertecies by the transform matrix
  for (int i = 0; i < global_coords.length; i++) {
    //Multiply vertex position by the rotations of camera
    r[i] = rotation_matrix_multiply(global_coords[i], transform_matrix);
    //Handle camera panning and zoom
    r[i].x = r[i].x*camera_fov + camera_x_shift + width/2;
    r[i].y = r[i].y*camera_fov + camera_y_shift + height/2;
    r[i].z = r[i].z*camera_fov;
  }
  return r;
}

//Multiplies a 3x1 vector by a 3x3 matrix
PVector rotation_matrix_multiply(PVector vector, float[][] matrix)
{
  PVector r = new PVector();
  r.x = vector.x*matrix[0][0] + vector.y*matrix[1][0] + vector.z*matrix[2][0];
  r.y = vector.x*matrix[0][1] + vector.y*matrix[1][1] + vector.z*matrix[2][1];
  r.z = vector.x*matrix[0][2] + vector.y*matrix[1][2] + vector.z*matrix[2][2];
  return r;
}

//Multiplies a 3x3 matrix by a 3x3 matrix
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

//Calculates y_z plane rotation based on the camera's angle
float[][] calculate_y_z_plane(float angle)
{
  float[][] rot_matrix = {{1, 0, 0}, {0, cos(angle), sin(angle)}, {0, -sin(angle), cos(angle)}};
  return rot_matrix;
}

//Calculates x_z plane rotation based on the camera's angle
float[][] calculate_x_z_plane(float angle)
{
  float[][] rot_matrix = {{cos(angle), 0, -sin(angle)}, {0, 1, 0}, {sin(angle), 0, cos(angle)}};
  return rot_matrix;
}

void print_3x3_matrix(float[][] matrix)
{
  for (int i = 0; i < 3; i++) {
    println(str(matrix[i][0]) + ", " + str(matrix[i][1]) + ", " + str(matrix[i][2]));
  }
}

void print_float_arr(float[] matrix)
{
  String resultant_string = "";
  for (int i = 0; i < matrix.length; i++)
  {
    resultant_string += str(matrix[i]) + ",";
  }
  println(resultant_string);
}

//Clamps a value so that value is bounded to the min and max
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
  
  for(int i = 0; i < pixel_values.length; i++){
    
    if(current_x == maxX){
      current_x = minX;
      current_y++;
    }
    current_x++;
    
    pixel_values[i] = new PVector(current_x, current_y);
  }
  return pixel_values;
}

int [] get_rect_indecies_of_tri(PVector[] values) {
  
  int[] pixel_indecies = new int[values.length];
  
  for(int i = 0; i < values.length; i++){
    pixel_indecies[i] = pixel_from_pos(round(values[i].x), round(values[i].y));
  }
  
  return pixel_indecies;
}

float side_length_of_tri(PVector a, PVector b){
  return dist(a.x, a.y, b.x, b.y);
}

//Heron's formula, provided by Jim Wang
float area_triangle(PVector a_p, PVector b_p, PVector c_p) {
  float a = side_length_of_tri(a_p, b_p);
  float b = side_length_of_tri(b_p, c_p);
  float c = side_length_of_tri(a_p, c_p);
  float s = (a+b+c)/2;
  
  return sqrt(s*(s-a)*(s-b)*(s-c));
}

boolean is_point_in_tri(PVector point, PVector[] tri) {
  
  float area_of_tri = area_triangle(tri[0], tri[1], tri[2]);
  
  float area_tri_point_1 = area_triangle(point, tri[1], tri[2]);
  float area_tri_point_2 = area_triangle(tri[0], point, tri[2]);
  float area_tri_point_3 = area_triangle(tri[0], tri[1], point);
  
  if(((area_tri_point_1+area_tri_point_2+area_tri_point_3) - area_of_tri) <= rasterization_slack)
    return true;
  else
    return false;
}

int pixel_from_pos(int x, int y) {
  return (x%width) + (y*width);
}

float dist_3d(PVector a, PVector b){
  return sqrt(pow(a.x-b.x, 2)+ pow(a.y-b.y, 2)+ pow(a.z-b.z, 2));
}

void calc_camera_vector(){
  //add camera shift capabilities
  float r = 1/camera_fov;
  camera_vector.x = r*sin(camera_y_angle)*cos(camera_x_angle);
  camera_vector.y = r*sin(camera_y_angle)*sin(camera_x_angle);
  camera_vector.z = r*cos(camera_y_angle);
}
