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
            
            float color_depth = depth;
            color pixel_col = color(tri.mat.m_col[0]+color_depth, tri.mat.m_col[1]+color_depth, tri.mat.m_col[2]+color_depth);
            
            if(on_edge && render_lines)
              pixel_col = line_color_solid;
            
            pixels[index] = pixel_col;
            z_buffer[index] = depth;
         }
      }
      }
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
            
            if(on_edge && render_lines)
              pixels[index] = line_color_wireframe;
              z_buffer[index] = depth;
         }
      }
      }
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
