ArrayList<Triangle> tris = new ArrayList<Triangle>(); 
float stroke_size = 4;
static float camera_x_angle = 0;
static float camera_y_angle = 0;

float mouse_sensitivity = 1;
float mouse_delta_x = 0;
float mouse_delta_y = 0;
float mouse_initial_origin_x = 0;
float mouse_initial_origin_y = 0;

float min_x_rot = 1.8;
float max_x_rot = 2.6;

PVector origin = new PVector(1, 1, 1);
PVector x = new PVector(200, 0, 1);
PVector y = new PVector(0, 200, 1);
PVector z = new PVector(0, 0, 200);

void setup() 
{
  strokeWeight(stroke_size);
  stroke(255);
  size(800, 800);
  
  PVector vert5 = new PVector(-20, 200, 1);
  PVector vert6 = new PVector(200, -40, -300);
  PVector vert7 = new PVector(50, 30, 1);
  
  Triangle tri_three = new Triangle(new PVector[] {vert5, vert6, vert7}, new float[] {255, 255, 255});
  
  Triangle x_axis = new Triangle(new PVector[] {origin, x, origin}, new float[] {255, 0, 0});
  Triangle y_axis = new Triangle(new PVector[] {origin, y, origin}, new float[] {0, 255, 0});
  Triangle z_axis = new Triangle(new PVector[] {origin, z, origin}, new float[] {0, 0, 255});
  
  tris.add(tri_three);
  tris.add(x_axis);
  tris.add(y_axis);
  tris.add(z_axis);

  print_3x3_matrix(calculate_x_z_plane(radians(90)));
}

void draw(){
  background(0);
  for(Triangle tri : tris){
    stroke(tri.triangle_color[0], tri.triangle_color[1], tri.triangle_color[2]);
    PVector[] screen_coords = to_screen_coords(tri.vertecies);
    line(screen_coords[0].x + width/2, screen_coords[0].y + height/2, screen_coords[1].x+ width/2, screen_coords[1].y + height/2);
    line(screen_coords[1].x + width/2, screen_coords[1].y + height/2, screen_coords[2].x+ width/2, screen_coords[2].y + height/2);
    line(screen_coords[2].x + width/2, screen_coords[2].y + height/2, screen_coords[0].x+ width/2, screen_coords[0].y + height/2);
  }
}

void mouseDragged(){
  camera_x_angle = radians(int(mouseX*mouse_sensitivity));
  camera_y_angle = radians(int(mouseY*mouse_sensitivity));
}
