ArrayList<Obj> objects = new ArrayList<Obj>();

boolean axes_on = true;
boolean render_lines = true;
float rasterization_slack = 2;
float line_thickness = 0.5;

color line_color_solid = color(0);
color line_color_wireframe = color(255);

int screen_size = 500;

static ArrayList<Line> lines = new ArrayList<Line>();

static float camera_x_angle = 0;
static float camera_y_angle = 0;
static float camera_z_angle = 0.2;
static float camera_x_shift = 0;
static float camera_y_shift = 0;
static float camera_fov = 2;

static PVector camera_vector = new PVector();

float shift_sensitivity = 10;
float mouse_sensitivity = 1;

PVector origin = new PVector(0, 0, 0);
PVector x = new PVector(100, 0, 0);
PVector y = new PVector(0, 100, 0);
PVector z = new PVector(0, 0, 100);

float[] background_col = new float[] {40, 40, 40};

RASTERIZATION_ALGORITHM rast_alg = RASTERIZATION_ALGORITHM.pixel; //pixel or painters (depth by face)
RENDERING_METHOD primary_rendering_method = RENDERING_METHOD.solid; //wireframe, solid, none

float[] z_buffer; //Depth value for every pixel

void setup()
{
  fullScreen();//set size of screen
  
  z_buffer = new float[width*height]; //initialize z buffers to negative infinity (no depth)
  for(int i = 0; i < z_buffer.length; i++){ z_buffer[i] = Float.NEGATIVE_INFINITY; }
  
  load_primatives();
  set_inital_camera();
  
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
    background(background_col[0], background_col[1], background_col[2]);
  
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
  camera_x_angle = radians(int(mouseX*mouse_sensitivity));
  camera_y_angle = radians(int(mouseY*mouse_sensitivity));
}

void mouseWheel(MouseEvent event)
{
  camera_fov = clamp(camera_fov - event.getCount()*0.05, 0.01, 4);
}

void keyPressed(){
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
  
  if(key == 'r'){
    set_inital_camera();
  }
}

void set_inital_camera()
{
  camera_x_angle = 5.5;
  camera_y_angle = 3.59;
  camera_fov = 3;
  camera_x_shift = 0;
  camera_y_shift = 24;
}
