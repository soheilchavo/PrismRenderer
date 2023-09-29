//Project flat verts to 3d
PVector[] to_screen_coords(PVector[] global_coords)
{
  //new PVector for the result of the matrix multiplication
  PVector[] r = new PVector[global_coords.length];
  //transform matrix, which is the multiplication of the x_z and y_z plane rotations
  float[][] transform_matrix = matrix_3x3_multiply(calculate_x_z_plane(PrismRenderer.camera_x_angle), calculate_y_z_plane(PrismRenderer.camera_y_angle));
  //multiply all vertecies by the transform matrix
  for(int i = 0; i < global_coords.length; i++){
    r[i] = rotation_matrix_multiply(global_coords[i], transform_matrix);
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
  for(int c = 0; c < 3; c++)
  {
    for(int i = 0; i < 3; i++)
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
  for(int i = 0; i < 3; i++){
    println(str(matrix[i][0]) + ", " + str(matrix[i][1]) + ", " + str(matrix[i][2]));
  }
}

void print_float_arr(float[] matrix)
{
  String resultant_string = "";
  for(int i = 0; i < matrix.length; i++)
  {
    resultant_string += str(matrix[i]) + ",";
  }
  println(resultant_string);
}
