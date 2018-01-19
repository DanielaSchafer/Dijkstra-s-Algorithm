public class Node{

  private int x;
  private int y;
  private String name;
  private int distance;

  public Node(int x, int y, String name)
  {
    this.x = x;
    this.y = y;
    this.name = name;
    distance = Integer.MAX_VALUE;
  }

  public void setDistance(int d)
  {
    distance = d;
  }

  public int getDistance()
  {
    return distance;
  }
  public int getX()
  {
    return x;
  }

  public int getY()
  {
    return y;
  }

  public String getName()
  {
    return name;
  }
}
