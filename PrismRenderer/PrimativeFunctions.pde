//List of prebuilt vertecies for Primatives (Cube, Rectangular Prism, etc)
ArrayList vertecies = new ArrayList<PVector>();
//List of prebuilt primatives
ArrayList prims = new ArrayList<ArrayList<Triangle>>();
//The order that the prims arraylist is in (in terms of name, ex: Cube: 1, Triangle: 2, etc)
ArrayList prim_order = new ArrayList<String>();

//Loads in the primatives from PrimativeData.txt
void load_primatives()
{
  //Array of every line in text file
  String[] lines = loadStrings("PrimativeData.txt");
  //If the specific line being read in the loop is a primative (vs. a vertex)
  boolean capturing_tris = false;
 
  for(String line: lines)
  {
    //Read triangle data and write primatives
    if(capturing_tris)
    {
      //Split vertecies by openning brackets (because they are ordered)
      String[] bracket_split = line.split("\\(");
      //Add the name of the primative to the order array
      prim_order.add(bracket_split[0].substring(0, bracket_split[0].length()-1));
      //List of triangles in primative
      ArrayList tris = new ArrayList<Triangle>();
      //Extracting the color information of the triangle
      String[] col_strings = bracket_split[bracket_split.length-1].substring(bracket_split[bracket_split.length-1].indexOf("[")).split(",");
      //Turning the color string into a float[] which the Triangle class requires
      float[] col_floats = new float[] {parseFloat(col_strings[0].substring(1)), parseFloat(col_strings[1]), parseFloat(col_strings[2].substring(0, col_strings[2].length()-1))};

      //Loop through every vertex
      for(int i = 1; i < bracket_split.length; i++)
      {
        //Extract x, y, z from ordered triplet
        String[] comma_split = bracket_split[i].split(",");
        int v1 = parseInt(comma_split[0])-1;
        int v2 = parseInt(comma_split[1])-1;
        //Last vertex requires extra parsing because it has ending bracket and comma
        int v3 = parseInt(comma_split[2].substring(0, comma_split[2].indexOf(")")))-1;
        //Create a triangle from the extracted vertecies
        Triangle triangle = new Triangle(new PVector[] {(PVector) vertecies.get(v1), (PVector) vertecies.get(v2), (PVector) vertecies.get(v3)}, col_floats);
        tris.add(triangle);
      }
      prims.add(tris);
    }
    //If the vertex information has been processed and now we have to process triangle info
    else if(line.contains("PRIMS")){
      capturing_tris = true;
    }
    //Process vertex info
    else {
      String[] comma_split = line.split(",");
      float x = parseFloat(comma_split[0].substring(comma_split[0].indexOf("=")+1));
      float y = parseFloat(comma_split[1]);
      float z = parseFloat(comma_split[2]);
      vertecies.add(new PVector(x, y, z));
    }
    
  }
}

//Adds new primative
void spawn_primative(String type, float scale, float x_translate, float y_translate, float z_translate, float[] col)
{
  //Grab triangle info from prim array
  ArrayList<Triangle> prim_tris = (ArrayList<Triangle>) prims.get(prim_order.indexOf(type));
  
  for(Triangle tri: prim_tris)
  {
    for(PVector vertex: tri.vertecies)
    {
      vertex.x = vertex.x*scale + x_translate;
      vertex.y = vertex.y*scale + y_translate;
      vertex.z = vertex.z*scale + z_translate;
    }
    tri.triangle_color = col;
    
    PrismRenderer.tris.add(tri);
  }
}
