Obj get_object_by_name(String object_name)
{
  for(Obj object: objects){
    if(object.name == object_name)
      return object;
  }
  throw new NullPointerException("Object" + object_name + "was not found");
}

void add_obj(String n, String t, Material m, PVector p, PVector s, PVector r)
{
  objects.add(new Obj(n, t, m, p, s, r)); 
}
