Obj get_object_by_name(String object_name){

  for(Obj object: objects){
    if(object.name == object_name)
      return object;
  }
  
  return objects.get(0);

}
