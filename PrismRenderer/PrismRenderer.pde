//3D RENDERER//

//CONTROLS:

//LOOK AROUND: DRAG MOUSE WHILE CLICKING LEFT OR RIGHT BUTTON

//ZOOM: SCROLLWHEEL / TRACKPAD

//CAMERA PANNING: WASD OR UP/LEFT/DOWN/RIGHT

//RESET CAMERA POSITION: R

/////////////////////////////////////////////////////////
//Array of objects in scene
ArrayList<Obj> objects = new ArrayList<Obj>();

boolean axes_on = true;
boolean render_lines = false;

//How accurate the point in the triangle needs to be (more is less accurate)
float rasterization_slack = 2;
//How thick ALL lines are
float line_thickness = 0.5;

//Color of lines in the solid pipeline
color line_color_solid = color(0);
//Color of lines in the wireframe pipeline
color line_color_wireframe = color(255);

/////////////////////////////////////////////////////////
//List of lines that will be rendered to the screen
static ArrayList<Line> lines = new ArrayList<Line>();

//Size of the vertex circles
float vertex_circle_size = 7;
//Angles for calculating rotation
static float camera_x_angle = 0;
static float camera_y_angle = 0;
static float camera_z_angle = 0.2;
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

//Background coor
float[] bg_col = new float[] {40, 40, 40};

//Rasterization algorithm: pixel(depth by pixel) or painters (depth by triangle)
RASTERIZATION_ALGORITHM rast_alg = RASTERIZATION_ALGORITHM.pixel;

//Rendering types: wireframe, solid, none
RENDERING_METHOD primary_rendering_method = RENDERING_METHOD.solid;

//Depth value for every pixel
float[] z_buffer;

void setup()
{
  //initialize z buffers to negative infinity (no depth)
  z_buffer = new float[width*height];
  for(int i = 0; i < z_buffer.length; i++){ z_buffer[i] = Float.NEGATIVE_INFINITY; }
  
  //set size of screen
  size(400,400);
  
  //Load all of the models of primatives from folder
  load_primatives();
  
  set_inital_camera();
  
  //Draw XYZ Axes
  if(axes_on)
  {
    lines.add(new Line(origin, x, color (255, 0, 0)));
    lines.add(new Line(origin, y, color (0, 255, 0)));
    lines.add(new Line(origin, z, color (0, 0, 255)));
  }
  
  add_obj(
    "Suzzane", //Name
    "Satellite", //Prim type
    new Material(200,200,200,0,0,0), //Object Material
    new PVector(0,0,0), //Location
    new PVector(5,5,5), //Scale
    new PVector(90,0,0) //Rotation
  );
  
  add_obj(
    "tri", //Name
    "Tetrahedron", //Prim type
    new Material(223,0,0,0,0,0), //Object Material
    new PVector(0,0,2), //Location
    new PVector(35,35,35), //Scale
    new PVector(90,0,0) //Rotation
  );
  
  
}

void draw()
{
  
  if(primary_rendering_method != RENDERING_METHOD.none){
    
    //set background color
    background(bg_col[0], bg_col[1], bg_col[2]);
    
    get_object_by_name("tri").rotation.z += 5;
    
    calc_camera_vector();
    
    if (primary_rendering_method != RENDERING_METHOD.none)
      draw_shapes();
      
    if(render_lines)
      draw_lines();
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
