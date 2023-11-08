void draw_shapes(){

    loadPixels();
    
    //reset z_buffer
    for(int i = 0; i < z_buffer.length; i++){ z_buffer[i] = Float.NEGATIVE_INFINITY; }
    
    ArrayList<Triangle> scene_triangles = new ArrayList<Triangle>();
    
    for(Obj obj: objects){
      for(Triangle tri: obj.obj_triangles){
        scene_triangles.add(new Triangle(translate_obj(tri.vertecies,obj),tri.mat));
      }
    }
    
    for (Triangle tri: scene_triangles){
      
      //Projected vertecies
      PVector[] screen_coords = to_screen_coords(tri.vertecies);
      
      //The pixel bounds of a triangle
      PVector[] triangle_bounds = get_rect_bounds_of_tri(screen_coords);
      
      //The indecies of the pixel bounds
      int[] triangle_bounds_indecies = get_rect_indecies_of_tri(triangle_bounds);
      
      for(int i = 0; i < triangle_bounds.length; i++){
        
        //pixel index of the point
        int index = triangle_bounds_indecies[i];
        
        //is the point in the pixel
        boolean in_tri = is_point_in_tri(triangle_bounds[i], screen_coords);
        if(in_tri){
          
          //get the depth relative to the camera
          float depth = 0;
          if(rast_alg == RASTERIZATION_ALGORITHM.painters) { depth = -(screen_coords[0].z + screen_coords[1].z + screen_coords[2].z); }
          else if(rast_alg == RASTERIZATION_ALGORITHM.pixel) { depth = get_tri_point_depth(screen_coords, triangle_bounds[i]); }
          
          //if the point is closer to the camera than the other points
          if(z_buffer[index] <= depth){
            
            //is point on the pixel of the edge
            boolean on_edge = is_point_on_shape_edge(triangle_bounds[i], screen_coords);
            
            //color of the pixel based on lighting
            if(primary_rendering_method == RENDERING_METHOD.solid)
              pixels[index] = point_lighting(tri, depth);
            
            if(on_edge && render_lines)
              pixels[index] = line_color_solid;
            
            //set z-buffer for next point
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
    //Reverses screen projection
    PVector[] screen_coords = to_screen_coords(new PVector[] {line.a, line.b});
    
    //Pixel boundaries of the lines
    PVector[] line_bounds = get_rect_bounds_of_tri(screen_coords);
    
    //Pixel indecies of the line boundaries
    int[] line_bounds_indecies = get_rect_indecies_of_tri(line_bounds);
    
    for(int i = 0; i < line_bounds.length; i++){
      
      //pixel index
      int index = line_bounds_indecies[i];
      
      //is the point on the line
      boolean in_line = is_point_on_shape_edge(line_bounds[i], screen_coords);
      
      if(in_line){
        
        //If line has a higher z-buffer
        if(z_buffer[index] == Float.NEGATIVE_INFINITY){
          pixels[index] = line.col;
        }
      }
    }
  }
  updatePixels();
}
