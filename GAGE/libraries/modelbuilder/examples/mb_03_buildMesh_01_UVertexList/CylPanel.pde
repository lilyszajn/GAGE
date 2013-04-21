// CylPanel class with UVertexList.
// using UGeometry.quadStrip() saves a lot of code

class CylPanel {
  float a,b,r;
  UVertexList vl1,vl2;
  UVec3 v1,v2;
  CylPanel next;
  
  CylPanel(float _a,float _b) {
    a=_a;
    b=_b;

    r=50+random(150);
    v1=new UVec3(r,0,0);
    v1.rotateY(b);
    v2=new UVec3(r,0,0);
    v2.rotateY(a);

    vl1=new UVertexList();    
    vl2=new UVertexList();    
    for(int i=0; i<numSeg; i++) {
      vl1.add(v1.x,(float)i*segH,v1.z);
      vl2.add(v2.x,(float)i*segH,v2.z);
    }
  }
  
  void toModel(UGeometry g) {
    g.quadStrip(vl1,vl2);
    g.quadStrip(next.vl1,vl2);
  } 
}
