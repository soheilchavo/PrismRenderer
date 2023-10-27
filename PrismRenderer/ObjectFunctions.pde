Obj get_object_by_name(String object_name){

  for(Obj object: objects){
    if(object.name == object_name)
      return object;
  }
  
  return objects.get(0);

}

void add_obj(String n, String t, Material m, PVector p, PVector s, PVector r){
  objects.add(new Obj(n, t, m, p, s, r)); 
}

void add_planetary_obj(String n, String t, Material m, PVector p, PVector s, PVector r){
  objects.add(new Obj(n, t, m, p, s, r)); 
}

void calc_planetary_movement(){

  delta = millis()-curr_time;
  curr_time = millis();
  

}
