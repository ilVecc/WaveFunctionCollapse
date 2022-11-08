import java.util.HashSet;
import java.util.Random;
import java.util.Collections;
import java.util.stream.Collectors;
import java.util.function.Predicate;



class WFC {

  private int rows, cols;
  private ArrayList<ArrayList<HashSet<Tile>>> wave;
  private HashMap<Integer, HashSet<Integer>> entropy;
  public Tile[][] collapsedWave;

  WFC(int N, int M, TilesDatabase db) {
    this.rows = N;
    this.cols = M;
    this.collapsedWave = new Tile[N][M];
    this.wave = new ArrayList<>();
    
    ArrayList<HashSet<Tile>> row;
    for (int i = 0; i < N; i++) {
      row = new ArrayList<>();
      for (int j = 0; j < M; j++) {
        row.add((HashSet) db.tiles.clone());
      }
      this.wave.add(row);
    }
    
    int e = db.tiles.size();
    this.entropy_init(e);
  }
  
  int sub_to_ind(int[] coords) {
    return coords[0] + coords[1] * this.cols;
  }
  
  int[] ind_to_sub(int index) {
    return new int[]{index % this.cols, index / this.cols};
  }
  
  void entropy_init(int init_entropy) {
    this.entropy = new HashMap<>();
    for (int i = 0; i < this.rows; i++) {
      for (int j = 0; j < this.cols; j++) {
        this.entropy_add(init_entropy, new int[]{i, j});
      }
    }
  }
  
  void entropy_add(int e, int[] coords) {
    this.entropy.putIfAbsent(e, new HashSet<Integer>());
    this.entropy.get(e).add(this.sub_to_ind(coords));
  }
  
  void entropy_sub(int e, int[] coords) {
    HashSet<Integer> availableCoords = this.entropy.get(e);
    availableCoords.remove(this.sub_to_ind(coords));
    if (availableCoords.isEmpty()) {
      this.entropy.remove(e);
    }
  }
  
  int get_lowest_entropy() {
    try {
      return Collections.min(this.entropy.keySet());
    } catch (Throwable th) {
      throw new IllegalStateException();
    }
  }
  
  int[] get_lowest_entropy_cell(int minEntropy) {
    HashSet<Integer> minEntropyCoords = this.entropy.get(minEntropy);
    int index = minEntropyCoords.stream().skip(new Random().nextInt(minEntropyCoords.size())).findFirst().get();
    return this.ind_to_sub(index);
  }
  
  void collapse(int[] coords) {
    HashSet<Tile> options = this.wave.get(coords[0]).get(coords[1]);
    
    // VERSION 1 (equally distributed tiles)
    //Tile tile = options.stream().skip(new Random().nextInt(options.size())).findFirst().get();
    
    // VERSION 2 (unevenly distributed tiles)
    ArrayList<Tile> optionsArray = new ArrayList<>(options);
    // compute the total
    double totalWeight = 0.0;
    for (Tile i : optionsArray) totalWeight += i.weight;
    // get the item
    int idx = 0;
    for (double r = Math.random() * totalWeight; idx < optionsArray.size() - 1; ++idx) {
        r -= optionsArray.get(idx).weight;
        if (r <= 0.0) break;
    }
    Tile tile = optionsArray.get(idx);
    
    options.clear();
    this.collapsedWave[coords[0]][coords[1]] = tile;
  }
  
  void apply_constraints(int i, int j, Predicate<Tile> filter) {
    HashSet<Tile> neighOptions = this.wave.get(i).get(j);
    if (!neighOptions.isEmpty()) {
      this.entropy_sub(neighOptions.size(), new int[]{i, j});
      neighOptions.removeAll(neighOptions.stream().filter(filter).collect(Collectors.toList()));
      this.entropy_add(neighOptions.size(), new int[]{i, j});
      if (neighOptions.isEmpty()) {
        println(String.format("cell (%d, %d) is now uncollapsable", i, j));
      }
    }
  }
  
  void update_neighbours(int[] coords) {
    int i = coords[0];
    int j = coords[1];
    Tile chosenTile = this.collapsedWave[i][j]; //<>//
    
    // up
    if (0 < i) {
      this.apply_constraints(i-1, j, neigh -> !neigh.nd.contains(chosenTile));
    }
    // down
    if (i < this.rows-1) {
      this.apply_constraints(i+1, j, neigh -> !neigh.nu.contains(chosenTile));
    }
    // left
    if (0 < j) {
      this.apply_constraints(i, j-1, neigh -> !neigh.nr.contains(chosenTile));
    }
    // right
    if (j < this.cols-1) {
      this.apply_constraints(i, j+1, neigh -> !neigh.nl.contains(chosenTile));
    }
  }
  
  void DEBUG() {
    for (int i : this.entropy.keySet()) {
      println(i + " -> " + this.entropy.get(i).size());
    }
    println();
  }

  void collapse_step() {
    // get new tile to collapse
    int minEntropy;
    try {
      minEntropy = this.get_lowest_entropy();
    } catch (IllegalStateException e) {
      // println("wave completely collapsed");
      return;
    }
    int[] coords = this.get_lowest_entropy_cell(minEntropy);
    this.entropy_sub(minEntropy, coords);
    
    // collapse
    this.collapse(coords);
    
    // update neighbours
    this.update_neighbours(coords);
    return;
  }
};
