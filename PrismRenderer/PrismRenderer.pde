//PRISM RENDERER//

//List of triangles that will be rendered to the screen
static ArrayList<Triangle> tris = new ArrayList<Triangle>();
//Line width of triangles
float stroke_size = 3;
//Angles for calculating rotation
static float camera_x_angle = 0;
static float camera_y_angle = 0;
//The field of view of camera (zoom)
static float camera_fov = 1;

//How sensitive the screen is to rotation
float mouse_sensitivity = 1;

PVector origin = new PVector(1, 1, 1);
PVector x = new PVector(200, 0, 0);
PVector y = new PVector(0, 200, 0);
PVector z = new PVector(0, 0, 200);

void setup()
{
  //Set default line preferences
  strokeWeight(stroke_size);
  stroke(255);
  //set size of screen
  size(700, 700);
 //Calculate the vertecies in the PrimativeData.txt file in order to draw them later
  load_primatives();
  
  //Draw XYZ Axes
  Triangle x_axis = new Triangle(new PVector[] {origin, x, origin}, new float[] {255, 0, 0});
  Triangle y_axis = new Triangle(new PVector[] {origin, y, origin}, new float[] {0, 255, 0});
  Triangle z_axis = new Triangle(new PVector[] {origin, z, origin}, new float[] {0, 0, 255});
 
  tris.add(x_axis);
  tris.add(y_axis);
  tris.add(z_axis);
  
  //Spawn Prims
  spawn_primative("Cube", 1, 0, 0, 0, new float[] {255, 255, 255});
}

void draw()
{  
  background(0);
 
  for(Triangle tri : tris)
  {
    //Set line color to specified line color (each triangle has one)
    stroke(tri.triangle_color[0], tri.triangle_color[1], tri.triangle_color[2]);
    //Translate the flat co-ords of the triangle to the 3d projection (multiply it by rotation and scale matricies)
    PVector[] screen_coords = to_screen_coords(tri.vertecies);
    //Draw lines connecting the 3 vertecies of the triangle
    line(screen_coords[0].x + width/2, screen_coords[0].y + height/2, screen_coords[1].x+ width/2, screen_coords[1].y + height/2);
    line(screen_coords[1].x + width/2, screen_coords[1].y + height/2, screen_coords[2].x+ width/2, screen_coords[2].y + height/2);
    line(screen_coords[2].x + width/2, screen_coords[2].y + height/2, screen_coords[0].x+ width/2, screen_coords[0].y + height/2);
  }
}

void mouseDragged()
{
  //Change screen rotation based on position of mouse
  camera_x_angle = radians(int(mouseX*mouse_sensitivity));
  camera_y_angle = radians(int(mouseY*mouse_sensitivity));
}
