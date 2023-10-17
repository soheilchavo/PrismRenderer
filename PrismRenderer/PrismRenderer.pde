//3D RENDERER//

//CONTROLS:

//LOOK AROUND: DRAG MOUSE WHILE CLICKING LEFT OR RIGHT BUTTON

//ZOOM: SCROLLWHEEL / TRACKPAD

//CAMERA PANNING: WASD OR UP/LEFT/DOWN/RIGHT

//RESET CAMERA POSITION: R

/////////////////////////////////////////////////////////
//ADD OBJECTS HERE: (Shapes are: Tetrahedron, Cube, Triangle, Plane, Cylinder)

String[][] initial_objs = new String[][] {
  //            Shape         Scale    x    y    z,    r      g      b
  new String[] {"Triangle", "0.5", "0", "0", "0", "255", "255", "255"},
};

//Try turning on x,y,z axes!
boolean axes_on = true;
/////////////////////////////////////////////////////////

//List of triangles that will be rendered to the screen
static ArrayList<Triangle> tris = new ArrayList<Triangle>();
//Line width of triangles
float stroke_size = 4;
//Size of the vertex circles
float vertex_circle_size = 7;
//Angles for calculating rotation
static float camera_x_angle = 5.5;
static float camera_y_angle = 3.5;
static PVector camera_vector = new PVector();
//The field of view of camera (zoom)
static float camera_fov = 2;
//Camera offsets
static float camera_x_shift = 0;
static float camera_y_shift = 0;
//How much the camera will pan when user presses buttons
float shift_sensitivity = 12;
//How sensitive the screen is to rotation
float mouse_sensitivity = 1;
//Vertecies for drawing xyz axes
PVector origin = new PVector(0, 0, 0);
PVector x = new PVector(200, 0, 0);
PVector y = new PVector(0, 200, 0);
PVector z = new PVector(0, 0, 200);

//How much the rasterization algorithm is given slack
float rasterization_slack = 70;

//enum RENDERING_METHOD { wireframe_simple, solid, none };
RENDERING_METHOD primary_rendering_method = RENDERING_METHOD.solid;

void setup()
{
  //Set default line preferences
  strokeWeight(stroke_size);
  stroke(255);
  //set size of screen
  size(900, 900);
 //Calculate the vertecies in the PrimativeData.txt file in order to draw them later
  load_primatives();
  //Set Camera Position
  set_inital_camera();
  //Draw XYZ Axes
  if(axes_on)
  {
    Triangle x_axis = new Triangle(new PVector[] {origin, x, origin}, new float[] {255, 0, 0});
    Triangle y_axis = new Triangle(new PVector[] {origin, y, origin}, new float[] {0, 255, 0});
    Triangle z_axis = new Triangle(new PVector[] {origin, z, origin}, new float[] {0, 0, 255});
   
    tris.add(x_axis);
    tris.add(y_axis);
    tris.add(z_axis);
  }
  //Spawn Prims
  for(String[] prim: initial_objs)
  {
    spawn_primative(prim[0], parseFloat(prim[1]), parseFloat(prim[2]), parseFloat(prim[3]), parseFloat(prim[4]), new float[] {parseInt(prim[5]), parseInt(prim[6]), parseInt(prim[7])});
  }
  
  //loadPixels();
  //for(int i = 0; i < pixels.length; i++){
  //  pixels[i] = color(round((i/width)*height)%255, 0,0);
  //}
  //updatePixels();
}

void draw()
{  
  if(primary_rendering_method != RENDERING_METHOD.none){
    background(0);
   
    calc_camera_vector();
    
    if (primary_rendering_method == RENDERING_METHOD.wireframe_simple)
      draw_wireframe_simple();
    
    if (primary_rendering_method == RENDERING_METHOD.solid)
      draw_solid();
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
  camera_fov = clamp(camera_fov - event.getCount()*0.05, 0.1, 3);
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
  camera_fov = 1.75;
  camera_x_shift = 0;
  camera_y_shift = 24;
}
