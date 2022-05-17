class Node {
  String label;
  float x, y; 
  int index;  
  
  Node(String label, float x, float y, int index) {
    this.label = label; 
    this.x = x;
    this.y = y;
    this.index = index;
  }
  
  int getIndex() {
    return index;
  }

  void draw(boolean activeStatus) {
    stroke(0); 
    strokeWeight(1);
    if(activeStatus){
      fill(255);  
    }else{
      fill(230);
    }
    ellipse(x, y, 5, 5);      
  }
}
