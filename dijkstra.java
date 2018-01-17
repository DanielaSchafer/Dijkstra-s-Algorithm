import java.util.ArrayList;
import java.util.HashMap;

public class dijkstra {

	public static void main(String[] args) {

		Node a = new Node("a",0); //0
		Node b = new Node("b",0); //1
		Node c = new Node("c",0); //2
		Node d = new Node("d",0); //3
		Node e = new Node("e",0); //4
		Node f = new Node("f",0); //5
		Node g = new Node("g",0); //6
		Node h = new Node("h",0); //7
		Node i = new Node("i",0); //8

		Edge ab = new Edge(a,b,4);
		Edge ag = new Edge(a,g,8);
		Edge bc = new Edge(b,c,8);
		Edge bh = new Edge(b,h,11);
		Edge cd = new Edge(c,d,7);
		Edge ci = new Edge(c,i,2);
		Edge cf = new Edge(c,f,4);
		Edge de = new Edge(d,e,9);
		Edge ef = new Edge(e,f,10);
		Edge df = new Edge(d,f,14);
		Edge fg = new Edge(f,g,2);
		Edge gh = new Edge(g,h,1);
		Edge hi = new Edge(h,i,7);
		Edge gi = new Edge(g,i,6);

		a.addNeighbor(ab);
		a.addNeighbor(ag);
		b.addNeighbor(bc);
		b.addNeighbor(bh);
		c.addNeighbor(cd);
		c.addNeighbor(ci);
		c.addNeighbor(cf);
		d.addNeighbor(de);
		d.addNeighbor(df);
		e.addNeighbor(ef);
		f.addNeighbor(fg);
		g.addNeighbor(gh);
		h.addNeighbor(hi);
		g.addNeighbor(gi);

		int nodeCount = 8;

		System.out.println(a.getNeighbors());

		System.out.println(getShortestPath(nodeCount,a));

	}

	public static ArrayList<Edge> getShortestPath(int nodeCount, Node startingNode)
	{
		ArrayList<Node> spSet = new ArrayList<Node>();
		ArrayList<Edge> sp = new ArrayList<Edge>();

		spSet.add(startingNode);

		while(spSet.size()<nodeCount)
		{
			ArrayList<Edge> possEdges = new ArrayList<Edge>();

			//gets possible edge choices
			for(int i = 0; i<spSet.size(); i++)
			{
				possEdges.addAll(spSet.get(i).getNeighbors());
			}
			for(int i = 0; i<possEdges.size(); i++)
			{
				if(sp.contains(possEdges.get(i)))
					possEdges.remove(i);
				else if(spSet.contains(possEdges.get(i).getOne()) && spSet.contains(possEdges.get(i).getTwo()))
					possEdges.remove(i);
			}

			int minDistanceIndex = 0;
			for(int i = 1; i<possEdges.size(); i++)
			{
				if(possEdges.get(i).getWeight()<possEdges.get(minDistanceIndex).getNeighbor())
					minWeightIndex = i;
			}
			Edge minEdge = possEdges.get(minWeightIndex);
			Node nodeAdded = getOtherNode(minEdge,spSet);
			int distance = nodeAdded.getDistance();
			sp.add(minEdge);
			spSet.add(nodeAdded);

			ArrayList<Edge> newEdges = nodeAdded.getNeighbors();

			for(int i = 0; i<newEdges.size(); i++)
			{
				if(!sp.contains(newEdges.get(i)))
				{
					newEdges.get(i).getNeighbor(nodeAdded).setDistance(newEdges.get(i).getWeight()+distance);
				}
			}
		}
		return sp;
	}

	public static Node getOtherNode(Edge e, ArrayList<Node> nodes)
	{
		for(int i = 0; i< nodes.size(); i++)
		{
			if(e.getOne().equals(nodes.get(i)))
				return e.getTwo();
			else if(e.getTwo().equals(nodes.get(i)))
				return e.getOne();
		}

		System.err.println("node does not exsist");
		return e.getOne();
	}

}
