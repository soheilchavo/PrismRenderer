void draw_solid(){

    //Go through each triangle, assign each pixel to a point and pair it with a depth, override a pixel if its depth is less
    
    loadPixels();
    
    for(int i = 0; i < z_buffer.length; i++){ z_buffer[i] = Float.NEGATIVE_INFINITY; }
    
    ArrayList<Triangle> scene_triangles = new ArrayList<Triangle>();
    
    for(Obj obj: objects){
      for(Triangle tri: obj.obj_triangles){
        scene_triangles.add(new Triangle(translate_obj(tri.vertecies,obj),tri.mat));
      }
    }
    
    for (Triangle tri: scene_triangles){
      
      //Translate the flat co-ords of the triangle to the 3d projection (multiply it by rotation and scale matricies)
      PVector[] screen_coords = to_screen_coords(tri.vertecies);
      
      PVector[] triangle_bounds = get_rect_bounds_of_tri(screen_coords);
      int[] triangle_bounds_indecies = get_rect_indecies_of_tri(triangle_bounds);
      
      for(int i = 0; i < triangle_bounds.length; i++){
        
        int index = triangle_bounds_indecies[i];
        boolean in_tri = is_point_in_tri(triangle_bounds[i], screen_coords);
        if(in_tri){
          
          float depth = 0;
          if(rast_alg == RASTERIZATION_ALGORITHM.painters) { depth = -(screen_coords[0].z + screen_coords[1].z + screen_coords[2].z); }
          else if(rast_alg == RASTERIZATION_ALGORITHM.pixel) { depth = get_tri_point_depth(screen_coords, triangle_bounds[i]); }
          
          if(z_buffer[index] < depth){
            boolean on_edge = is_point_on_shape_edge(triangle_bounds[i], screen_coords);
            
            color pixel_col = tri.mat.m_col;
            
            if(on_edge && render_lines)
              pixel_col = line_color;
            
            pixels[index] = pixel_col;
            z_buffer[index] = depth;
         }
      }}
  }
    
  for(Line line : lines)
  {
    //Translate the flat co-ords of the triangle to the 3d projection (multiply it by rotation and scale matricies)
    PVector[] screen_coords = to_screen_coords(new PVector[] {line.a, line.b});
    
    PVector[] line_bounds = get_rect_bounds_of_tri(screen_coords);
    int[] line_bounds_indecies = get_rect_indecies_of_tri(line_bounds);
    
    for(int i = 0; i < line_bounds.length; i++){
      
      int index = line_bounds_indecies[i];
      boolean in_line = is_point_on_shape_edge(line_bounds[i], screen_coords);
      
      if(in_line){
        if(z_buffer[index] == Float.NEGATIVE_INFINITY){
          pixels[index] = line.col;
        }
      }
    }
  }
  
  updatePixels();
}

void draw_wireframe()
{
  for(Triangle tri : tris)
  {
    //Set line color to specified line color (each triangle has one)
    stroke(line_color);
    //Translate the flat co-ords of the triangle to the 3d projection (multiply it by rotation and scale matricies)
    PVector[] screen_coords = to_screen_coords(tri.vertecies);
    //Draw circle at every vertex
    for(PVector v: screen_coords)
    {
      fill(tri.mat.m_col);
      circle(v.x, v.y, vertex_circle_size);
    }
    //Draw lines connecting the 3 vertecies of the triangle
    line(screen_coords[0].x, screen_coords[0].y, screen_coords[1].x, screen_coords[1].y);
    line(screen_coords[1].x, screen_coords[1].y, screen_coords[2].x, screen_coords[2].y);
    line(screen_coords[2].x, screen_coords[2].y, screen_coords[0].x, screen_coords[0].y);
  }
  
  for(Line line : lines)
  {
    //Set line color to specified line color (each triangle has one)
    stroke(line.col);
    //Translate the flat co-ords of the triangle to the 3d projection (multiply it by rotation and scale matricies)
    PVector[] screen_coords = to_screen_coords(new PVector[] {line.a, line.b});
    //Draw circle at every vertex
    for(PVector v: screen_coords)
    {
      fill(line.col);
      circle(v.x, v.y, vertex_circle_size);
    }
    
    line(screen_coords[0].x, screen_coords[0].y, screen_coords[1].x, screen_coords[1].y);
  }
}
