ArrayList<Triangle> tris = new ArrayList<Triangle>();
float stroke_size = 3;
static float camera_x_angle = 0;
static float camera_y_angle = 0;
static float camera_fov = 1;

float mouse_sensitivity = 1;
float mouse_delta_x = 0;
float mouse_delta_y = 0;
float mouse_initial_origin_x = 0;
float mouse_initial_origin_y = 0;

float min_x_rot = 1.8;
float max_x_rot = 2.6;

PVector origin = new PVector(1, 1, 1);
PVector x = new PVector(200, 0, 0);
PVector y = new PVector(0, 200, 0);
PVector z = new PVector(0, 0, 200);

void setup()
{
  strokeWeight(stroke_size);
  stroke(255);
  size(700, 700);
 
  calculate_prim_vertecies();
 
  float poly_size = 50;
  PVector vert1 = new PVector(poly_size, poly_size, poly_size);
  PVector vert2 = new PVector(-poly_size, -poly_size, poly_size);
  PVector vert3 = new PVector(-poly_size, poly_size, -poly_size);
  PVector vert4 = new PVector(poly_size, -poly_size, -poly_size);
 
  Triangle tri1 = new Triangle(new PVector[] {vert1, vert2, vert3}, new float[] {255, 255, 255});
  Triangle tri2 = new Triangle(new PVector[] {vert1, vert2, vert4}, new float[] {255, 255, 255});
  Triangle tri3 = new Triangle(new PVector[] {vert3, vert4, vert1}, new float[] {255, 255, 255});
  Triangle tri4 = new Triangle(new PVector[] {vert3, vert4, vert2}, new float[] {255, 255, 255});
 
  Triangle x_axis = new Triangle(new PVector[] {origin, x, origin}, new float[] {255, 0, 0});
  Triangle y_axis = new Triangle(new PVector[] {origin, y, origin}, new float[] {0, 255, 0});
  Triangle z_axis = new Triangle(new PVector[] {origin, z, origin}, new float[] {0, 0, 255});
 
  tris.add(x_axis);
  tris.add(y_axis);
  tris.add(z_axis);
  tris.add(tri1);
  tris.add(tri2);
  tris.add(tri3);
  tris.add(tri4);
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
