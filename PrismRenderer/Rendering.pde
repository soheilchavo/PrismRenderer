void draw_solid(){

    //Go through each triangle, assign each pixel to a point and pair it with a depth, override a pixel if its depth is less
    
    loadPixels();
    
    for(int i = 0; i < z_buffer.length; i++){ z_buffer[i] = Float.NEGATIVE_INFINITY; }
    
    for(Triangle tri : tris)
    {
      //Translate the flat co-ords of the triangle to the 3d projection (multiply it by rotation and scale matricies)
      PVector[] screen_coords = to_screen_coords(tri.vertecies);
      
      PVector[] triangle_bounds = get_rect_bounds_of_tri(screen_coords);
      int[] triangle_bounds_indecies = get_rect_indecies_of_tri(triangle_bounds);
      
      for(int i = 0; i < triangle_bounds.length; i++){
        
        int index = triangle_bounds_indecies[i];
        boolean in_tri = is_point_in_tri(triangle_bounds[i], screen_coords);
        if(in_tri){
          
          //float depth = get_tri_point_depth(screen_coords, triangle_bounds[i]);
          float depth = -(screen_coords[0].z + screen_coords[1].z + screen_coords[2].z);
          if(z_buffer[index] < depth){
            boolean on_edge = is_point_on_tri_edge(triangle_bounds[i], screen_coords);
           
            color pixel_col = tri.triangle_color;
            
            if(on_edge)
              pixel_col = tri.line_color;
            
            pixels[index] = pixel_col;
            z_buffer[index] = depth;
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
    stroke(tri.line_color);
    //Translate the flat co-ords of the triangle to the 3d projection (multiply it by rotation and scale matricies)
    PVector[] screen_coords = to_screen_coords(tri.vertecies);
    //Draw circle at every vertex
    for(PVector v: screen_coords)
    {
      fill(tri.triangle_color);
      circle(v.x, v.y, vertex_circle_size);
    }
    //Draw lines connecting the 3 vertecies of the triangle
    line(screen_coords[0].x, screen_coords[0].y, screen_coords[1].x, screen_coords[1].y);
    line(screen_coords[1].x, screen_coords[1].y, screen_coords[2].x, screen_coords[2].y);
    line(screen_coords[2].x, screen_coords[2].y, screen_coords[0].x, screen_coords[0].y);
  }
}
