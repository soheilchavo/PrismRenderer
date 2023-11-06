//3D RENDERER//

//CONTROLS:

//LOOK AROUND: DRAG MOUSE WHILE CLICKING LEFT OR RIGHT BUTTON

//ZOOM: SCROLLWHEEL / TRACKPAD

//CAMERA PANNING: WASD OR UP/LEFT/DOWN/RIGHT

//RESET CAMERA POSITION: R

/////////////////////////////////////////////////////////
ArrayList<Obj> objects = new ArrayList<Obj>();

//Try turning on x,y,z axes!
boolean axes_on = true;
boolean render_lines = true;

color line_color_solid = color(0);
color line_color_wireframe = color(255);

int screenSize = 700;
/////////////////////////////////////////////////////////

//List of triangles that will be rendered to the screen
static ArrayList<Triangle> tris = new ArrayList<Triangle>();
static ArrayList<Line> lines = new ArrayList<Line>();
//Line width of triangles
float stroke_size = 4;
//Size of the vertex circles
float vertex_circle_size = 7;
//Angles for calculating rotation
static float camera_x_angle = 0;
static float camera_y_angle = 0;
static float camera_z_angle = 0.4;
static PVector camera_vector = new PVector();
//The field of view of camera (zoom)
static float camera_fov = 2;
//Camera offsets
static float camera_x_shift = 0;
static float camera_y_shift = 0;
//How much the camera will pan when user presses buttons
float shift_sensitivity = 10;
//How sensitive the screen is to rotation
float mouse_sensitivity = 1;
//Vertecies for drawing xyz axes
PVector origin = new PVector(0, 0, 0);
PVector x = new PVector(200, 0, 0);
PVector y = new PVector(0, 200, 0);
PVector z = new PVector(0, 0, 200);

//How much the rasterization algorithm is given slack
float rasterization_slack = 1;
float line_thickness = 1;

RASTERIZATION_ALGORITHM rast_alg = RASTERIZATION_ALGORITHM.pixel;

//Depth value for every pixel
float[] z_buffer;

//enum RENDERING_METHOD { wireframe, solid, none };
RENDERING_METHOD primary_rendering_method = RENDERING_METHOD.solid;

float curr_time;
float delta = 0;

void setup()
{
  curr_time = millis();
  
  //get_tri_point_depth(new PVector[] {new PVector(0,0,0), new PVector(12,0,42), new PVector(-10,-5,0)}, new PVector(0,0));
  //println(is_point_on_shape_edge(new PVector(4,55), new PVector[] { new PVector(0,-100), new PVector(0,24) }));
  //set all z buffers to negative infinity
  z_buffer = new float[width*height];
  for(int i = 0; i < z_buffer.length; i++){ z_buffer[i] = Float.NEGATIVE_INFINITY; }
  //Set default line preferences
  strokeWeight(stroke_size);
  stroke(255);
  //set size of screen
  size(400,400);
 //Calculate the vertecies in the PrimativeData.txt file in order to draw them later
  load_primatives();
  //Set Camera Position
  set_inital_camera();
  //Draw XYZ Axes
  if(axes_on)
  {
    Line x_axis = new Line(origin, x, color (255, 0, 0));
    Line y_axis = new Line(origin, y, color (0, 255, 0));
    Line z_axis = new Line(origin, z, color (0, 0, 255));
    lines.add(x_axis);
    lines.add(y_axis);
    lines.add(z_axis);
  }
  //Spawn Prims
  //for(String[] prim: initial_objs)
  //{
  //  spawn_primative(prim[0], parseFloat(prim[1]), parseFloat(prim[2]), parseFloat(prim[3]), parseFloat(prim[4]), color(parseInt(prim[5]), parseInt(prim[6]), parseInt(prim[7])), color(parseInt(prim[8]), parseInt(prim[9]), parseInt(prim[10])));
  //}
  
  add_obj(
    "Suzzane", //Name
    "Satellite", //Prim type
    new Material(252,155,0,0,0,0), //Object Material
    new PVector(0,0,0), //Location
    new PVector(5,5,5), //Scale
    new PVector(90,0,0) //Rotation
  );
  
  add_obj(
    "Boo", //Name
    "Monkey", //Prim type
    new Material(65,155,233,0,0,0), //Object Material
    new PVector(2,0,0), //Location
    new PVector(45,45,45), //Scale
    new PVector(0,0,0) //Rotation
  );
  
}

void draw()
{
  
  if(primary_rendering_method != RENDERING_METHOD.none){
    background(0,24,53);
    
    calc_camera_vector();
    
    if (primary_rendering_method == RENDERING_METHOD.wireframe)
      draw_wireframe();
    
    if (primary_rendering_method == RENDERING_METHOD.solid){
      draw_solid();
    }
  }
}

void mouseDragged()
{
  //Change screen rotation based on position of mouse
  camera_x_angle = radians(int(mouseX*mouse_sensitivity));
  camera_y_angle = radians(int(mouseY*mouse_sensitivity));
}

void mouseWheel(MouseEvent event)
{
  //Zoom in or out the camera
  camera_fov = clamp(camera_fov - event.getCount()*0.05, 0.01, 4);
}

void keyPressed(){
  //Handle Camera Panning
  if(key == 'a'){
    camera_x_shift += shift_sensitivity;
  }
  if(key == 'd'){
    camera_x_shift -= shift_sensitivity;
  }
  if(key == 'w'){
    camera_y_shift += shift_sensitivity;
  }
  if(key == 's'){
    camera_y_shift -= shift_sensitivity;
  }
  
  if(keyCode == LEFT){
    camera_x_angle += mouse_sensitivity/10;
  }
  if(keyCode == RIGHT){
    camera_x_angle -= mouse_sensitivity/10;
  }
  if(keyCode == UP){
    camera_y_angle += mouse_sensitivity/10;
  }
  if(keyCode == DOWN){
    camera_y_angle -= mouse_sensitivity/10;
  }
  //Reset Camera
  if(key == 'r'){
    set_inital_camera();
  }
}

//Resets camera to original position
void set_inital_camera()
{
  camera_x_angle = 5.5;
  camera_y_angle = 3.59;
  camera_fov = 3;
  camera_x_shift = 0;
  camera_y_shift = 24;
}
