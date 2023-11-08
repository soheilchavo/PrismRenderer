ArrayList vertecies = new ArrayList<PVector>();

ArrayList prims = new ArrayList<ArrayList<Triangle>>();

//The order that the prims arraylist is in (in terms of name, ex: Cube: 1, Triangle: 2, etc)
ArrayList prim_order = new ArrayList<String>();

//Loads in the primatives from PrimativeData.txt
void load_primatives()
{
  File directory = new File(sketchPath("/ModelData/"));
  File[] files = directory.listFiles();
  
  for (File modelData : files) {
    
    ArrayList<PVector> model_vertecies = new ArrayList<PVector>();
    ArrayList<Triangle> model_triangles = new ArrayList<Triangle>();
    String modelName = modelData.getName();
    prim_order.add(modelName.substring(0, modelName.length()-4));

    try{
      String[] modelLines = loadStrings(modelData.getCanonicalPath());

      for (String line : modelLines) {
        String[] lineArray = line.split(" ");
        
        if (lineArray[0].contains("v") && lineArray[0].length() == 1) {
          model_vertecies.add(new PVector(float(lineArray[1]), float(lineArray[2]), float(lineArray[3])));
        }
        if (lineArray[0].contains("f") && lineArray[0].length() == 1) {
          
          if(lineArray[1].contains("/")){
          
            model_triangles.add(new Triangle ( new PVector[] {
              model_vertecies.get(int(lineArray[1].substring(0,lineArray[1].indexOf("/")))-1),
              model_vertecies.get(int(lineArray[2].substring(0,lineArray[2].indexOf("/")))-1),
              model_vertecies.get(int(lineArray[3].substring(0,lineArray[3].indexOf("/")))-1)
            }
            ));
          }
          
          else{
            model_triangles.add(new Triangle ( new PVector[] {
              model_vertecies.get(int(lineArray[1])-1),
              model_vertecies.get(int(lineArray[2])-1),
              model_vertecies.get(int(lineArray[3])-1)
            }
            ));
          }
        }
      }
      
    }
    catch(IOException ie) { print("non-existent model path"); }

    prims.add(model_triangles);
  }

}

//Adds new primative
ArrayList<Triangle> get_prim_tris(String type, Material objmat)
{
  //Grab triangle info from prim array
  ArrayList<Triangle> prim_tris = (ArrayList<Triangle>) prims.get(prim_order.indexOf(type));
  ArrayList<Triangle> cloned_tris = new ArrayList<Triangle>();

  for (Triangle tri : prim_tris)
  {
    //Clone the vertecies of the original primative so that we're not changing the base shape
    PVector[] cloned_verts = new PVector[3];
    for (int i = 0; i < tri.vertecies.length; i++)
    {
      cloned_verts[i] = new PVector();
      cloned_verts[i].x = tri.vertecies[i].x;
      cloned_verts[i].y = tri.vertecies[i].y;
      cloned_verts[i].z = tri.vertecies[i].z;
    }
    //Add new triangle to the list of triangles to be rendered every frame
    Triangle cloned_triangle = new Triangle(cloned_verts, objmat);
    cloned_tris.add(cloned_triangle);
  }
  return cloned_tris;
}
