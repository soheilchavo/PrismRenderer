Planetary_Body get_object_by_name(String object_name){

  for(Planetary_Body object: objects){
    if(object.name == object_name)
      return object;
  }
  
  return objects.get(0);

}

void add_planetary_body(String n, String t, Material m, PVector p, PVector s, PVector r, PVector ira, PVector ora, float irs, float ors,float ord, String parent){
  objects.add(new Planetary_Body(n, t, m, p, s, r, ira, ora, irs, ors,ord, parent)); 
}

void calc_planetary_movement(){

  delta = millis()-curr_time;
  curr_time = millis();
  //delta = 1;
  for(Planetary_Body body: objects){
    
    body.rotation.x += (body.inner_rotational_axes.x*body.inner_rotational_speed)%360;
    body.rotation.y += (body.inner_rotational_axes.y*body.inner_rotational_speed)%360;
    body.rotation.z += (body.inner_rotational_axes.z*body.inner_rotational_speed)%360;
    
    if(body.parent_body != null){
      body.position.x = body.orbit_distance*sin(frameCount*body.outer_rotational_speed*body.outer_rotational_axes.x)+body.parent_body.position.x;
      body.position.y = body.orbit_distance*cos(frameCount*body.outer_rotational_speed*body.outer_rotational_axes.y)+body.parent_body.position.y;
      body.position.z = -body.orbit_distance*sin(frameCount*body.outer_rotational_speed*body.outer_rotational_axes.z)+body.parent_body.position.z;
    }
    
  }

}
