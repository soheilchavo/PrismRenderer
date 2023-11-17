void draw_shapes(){
  
    loadPixels();
    for(int i = 0; i < z_buffer.length; i++){ z_buffer[i] = Float.NEGATIVE_INFINITY; }//reset z_buffer
    
    ArrayList<Triangle> scene_triangles = new ArrayList<Triangle>();
    
    for(Obj obj: objects){
      for(Triangle tri: obj.obj_triangles){
        scene_triangles.add(new Triangle(translate_obj(tri.vertecies,obj),tri.mat));
      }
    }
    
    for (Triangle tri: scene_triangles){
      
      PVector[] screen_coords = to_screen_coords(tri.vertecies);
      
      //The pixel bounds of a triangle
      PVector[] triangle_bounds = get_rect_bounds_of_tri(screen_coords);
      
      //The indecies of the pixel bounds
      int[] triangle_bounds_indecies = get_rect_indecies_of_tri(triangle_bounds);
      
      for(int i = 0; i < triangle_bounds.length; i++){
        
        int index = triangle_bounds_indecies[i];
        boolean in_tri = is_point_in_tri(triangle_bounds[i], screen_coords);
        
        if(in_tri){
          
          float depth = 0;
          if(rast_alg == RASTERIZATION_ALGORITHM.painters) { depth = -(screen_coords[0].z + screen_coords[1].z + screen_coords[2].z); }
          else if(rast_alg == RASTERIZATION_ALGORITHM.pixel) { depth = get_tri_point_depth(screen_coords, triangle_bounds[i]); }
          
          if(z_buffer[index] <= depth){
            
            boolean on_edge = is_point_on_shape_edge(triangle_bounds[i], screen_coords);
            
            if(primary_rendering_method == RENDERING_METHOD.solid)
              pixels[index] = point_lighting(tri, depth);
            
            if(on_edge && render_lines)
              pixels[index] = line_color_solid;
            
            z_buffer[index] = depth;
         }
      }
    }
  }
  
  updatePixels();
}

void draw_lines(){

 loadPixels();
 
  for(Line line : lines)
  {
    PVector[] screen_coords = to_screen_coords(new PVector[] {line.a, line.b});
    
    //Pixel boundaries of the lines
    PVector[] line_bounds = get_rect_bounds_of_tri(screen_coords);
    //Pixel indecies of the line boundaries
    int[] line_bounds_indecies = get_rect_indecies_of_tri(line_bounds);
    
    for(int i = 0; i < line_bounds.length; i++){
      
      int index = line_bounds_indecies[i];
      boolean in_line = is_point_on_shape_edge(line_bounds[i], screen_coords);
      
      if(in_line && z_buffer[index] == Float.NEGATIVE_INFINITY)
        pixels[index] = line.col;
    }
  }
  
  updatePixels();
}
