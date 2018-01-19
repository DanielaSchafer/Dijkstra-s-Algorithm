PImage dino;
PImage grass;
PImage tree;

void setup()
{
  size(1200, 800);
  background(255);

  dino = loadImage("dijkstra.png");
  grass = loadImage("dans_grass.png");
  tree = loadImage("tree.png");

  image(grass, 0, 0);

  PFont g = createFont("Bookman Old Style Italic", 20);
  textFont(g);
  text("Art by Sonia Fung", 1000, 780);

  String[] fontList = PFont.list();
  printArray(fontList);
}


void draw()
{
  Node a = new Node(200, 400, "a");
  Node b = new Node(300, 200, "b");
  Node c = new Node(400, 500, "c");
  Node d = new Node(500, 300, "d");
  Node e = new Node(600, 500, "e");
  Node f = new Node(700, 200, "f");
  Node g = new Node(800, 400, "g");
  Node h = new Node(900, 600, "h");
  Node i = new Node(1000, 400, "i");

  Node[] nodes = {a, b, c, d, e, f, g, h, i};
  drawEdge(a, b);
  drawEdge(b, c);
  drawEdge(b, d);
  drawEdge(a, c);
  drawEdge(c, d);
  drawEdge(c, e);
  drawEdge(b, f);
  drawEdge(e, f);
  drawEdge(e, h);
  drawEdge(e, f);
  drawEdge(f, g);
  drawEdge(g, i);
  drawEdge(g, h);
  drawEdge(h, i);
  drawEdge(c, h);
  drawEdge(e, g);
  drawEdge(d, f);
  drawNodes(nodes);
  drawDino(a);
}

public void drawDino(Node n)
{
  image(dino, n.getX()-70, n.getY()+12);
}

public void drawNodes(Node[] nodes)
{
  for (int i = 0; i<nodes.length; i++)
  {
    drawNode(nodes[i]);
  }
}

public void drawNode(Node n)
{
  strokeWeight(1);
  stroke(0);
  PFont f = createFont("Consolas", 35);
  //fill(50,200,100);
  //ellipse(n.getX(),n.getY(),50,50);
  image(tree, n.getX(), n.getY());
  fill(0);
  textFont(f);
  text(n.getName(), n.getX()+10, n.getY()-4);

  fill(22,159,242);
  if(n.getDistance() == Integer.MAX_VALUE)
  {
    noStroke();
    ellipse(n.getX()+25, n.getY()+81,29,15);
    fill(0);
    text("∞",n.getX()+15, n.getY()+90);
  }
  else
  text(n.getDistance(),n.getX()+44, n.getY()+70);
}

public void drawEdge(Node a, Node b)
{
  strokeWeight(3);
  stroke(0);
  line(a.getX()+25, a.getY()+65, b.getX()+25, b.getY()+65);
}

public void drawGEdge(Node a, Node b)
{
  strokeWeight(3);
  stroke(100, 200, 100);
  line(a.getX(), a.getY(), b.getX(), b.getY());
}
