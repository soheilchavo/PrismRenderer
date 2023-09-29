ArrayList vertecies = new ArrayList<PVector>();
ArrayList prims = new ArrayList<ArrayList<Triangle>>();
ArrayList prim_order = new ArrayList<String>();

void calculate_prim_vertecies(){
  String[] lines = loadStrings("PrimativeData.txt");
  boolean capturing_tris = false;
 
  for(String line: lines){
    if(capturing_tris){
      String[] bracket_split = line.split("\\(");
      prim_order.add(bracket_split[0]);
      ArrayList tris = new ArrayList<Triangle>();
      String[] col_strings = bracket_split[-1].substring(bracket_split[-1].indexOf("\\[")).split(",");
      float[] col_floats = new float[] {parseFloat(col_strings[0]), parseFloat(col_strings[1]), parseFloat(col_strings[2])};
      
      for(int i = 1; i < bracket_split.length; i++){
        String[] comma_split = bracket_split[i].split(",");
        int v1 = parseInt(comma_split[0]);
        int v2 = parseInt(comma_split[1]);
        int v3 = parseInt(comma_split[2].substring(0, comma_split[2].indexOf(")")));
        Triangle triangle = new Triangle(new PVector[] {(PVector) vertecies.get(v1), (PVector) vertecies.get(v2), (PVector) vertecies.get(v3)}, col_floats);
        tris.add(triangle);
      }
      prims.add(tris);
    }
    else if(line.contains("PRIMS")){
      capturing_tris = true;
    }
    else {
      String[] comma_split = line.split(",");
      float x = parseFloat(comma_split[0].substring(comma_split[0].indexOf("=")+1));
      float y = parseFloat(comma_split[1]);
      float z = parseFloat(comma_split[2]);
      vertecies.add(new PVector(x, y, z));
    }
    
  }
}
