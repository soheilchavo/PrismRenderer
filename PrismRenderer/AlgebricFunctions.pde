//Projects 3d points to flat screen
PVector[] to_screen_coords(PVector[] global_coords)
{
  //new PVector for the result of the matrix multiplication
  PVector[] screen_coords = new PVector[global_coords.length];
  //transform matrix, which is the multiplication of the x_z and y_z plane rotations
  float[][] transform_matrix = matrix_3x3_multiply(calculate_x_z_plane(PrismRenderer.camera_x_angle), calculate_y_z_plane(PrismRenderer.camera_y_angle));
  //multiply all vertecies by the transform matrix
  for (int i = 0; i < global_coords.length; i++) {
    //Multiply vertex position by the rotations of camera
    screen_coords[i] = rotation_matrix_multiply(global_coords[i], transform_matrix);
    //Handle camera panning and zoom
    screen_coords[i].x = screen_coords[i].x*camera_fov + camera_x_shift + width/2;
    screen_coords[i].y = screen_coords[i].y*camera_fov + camera_y_shift + height/2;
  }
  return screen_coords;
}

//Reverses projection
PVector to_global_coords_point(PVector screen_coords)
{
  //new PVector for the result of the matrix multiplication
  PVector global_coords = new PVector();
  //transform matrix, which is the multiplication of the x_z and y_z plane rotations
  float[][] transform_matrix = matrix_3x3_multiply(calculate_inv_x_z_plane(PrismRenderer.camera_x_angle), calculate_inv_y_z_plane(PrismRenderer.camera_y_angle));
  //multiply all vertecies by the transform matrix
 
  global_coords.x = (screen_coords.x + camera_x_shift + width/2)/camera_fov;
  global_coords.y = (screen_coords.y + camera_y_shift + height/2)/camera_fov;
  global_coords.z = screen_coords.z;
  
  global_coords = rotation_matrix_multiply(global_coords, transform_matrix);
  
  return global_coords;
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

//Calculates y_z plane rotation based on the camera's angle
float[][] calculate_inv_y_z_plane(float angle)
{
  float[][] rot_matrix = {{1, 0, 0}, {0, cos(angle), -sin(angle)}, {0, sin(angle), cos(angle)}};
  return rot_matrix;
}

//Calculates x_z plane rotation based on the camera's angle
float[][] calculate_inv_x_z_plane(float angle)
{
  float[][] rot_matrix = {{cos(angle), 0, sin(angle)}, {0, 1, 0}, {-sin(angle), 0, cos(angle)}};
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

int pixel_from_pos(int x, int y) {
  return x + (y*width);
}

float dist_3d(PVector a, PVector b) {
  return sqrt(pow(a.x-b.x, 2)+ pow(a.y-b.y, 2)+ pow(a.z-b.z, 2));
}

void calc_camera_vector() {
  //add camera shift capabilities
  float r = camera_fov*2;
  camera_vector.x = r*sin(camera_y_angle)*cos(camera_x_angle);
  camera_vector.y = r*sin(camera_y_angle)*sin(camera_x_angle);
  camera_vector.z = r*cos(camera_y_angle);
  //println(camera_vector);
}
PVector vector_cross_product(PVector a, PVector b) {
  return new PVector(
    a.y*b.z - a.z*b.y,
    a.z*b.x - a.x*b.z,
    a.x*b.y - a.y*b.x
    );
}

PVector normalize_vector(PVector v) {

  float len = dist_3d(new PVector(0, 0, 0), v);
  return new PVector(v.x/len, v.y/len, v.z/len);
}

float[] get_line_equation(PVector vert_1, PVector vert_2) {

  float a = vert_2.y-vert_1.y;
  float b = vert_1.x-vert_2.x;
  float c = a*(vert_1.x)+b*(vert_1.y);

  return new float[] {a,b,-c};
}

float side_length_of_tri(PVector a, PVector b) {
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
