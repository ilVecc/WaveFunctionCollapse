import java.util.HashSet;

abstract class Tile {

  public String su, sl, sd, sr;
  public HashSet<Tile> nu, nl, nd, nr;
  public String repr;
  public double weight;
  
  Tile(String su, String sl, String sd, String sr, String repr) {
    this(su, sl, sd, sr, repr, 1.0);
  }
  
  Tile(String su, String sl, String sd, String sr, String repr, double weight) {
    this.su = su;
    this.sl = sl;
    this.sd = sd;
    this.sr = sr;
    this.nu = new HashSet<>();
    this.nl = new HashSet<>();
    this.nd = new HashSet<>();
    this.nr = new HashSet<>();
    this.repr = repr;
    this.weight = weight;
  }
}

class Tile0 extends Tile {
  Tile0() {
    super("0", "1", "0", "1", "═");
  }
}

class Tile1 extends Tile {
  Tile1() {
    super("1", "0", "0", "1", "╚");
  }
}

class Tile2 extends Tile {
  Tile2() {
    super("1", "1", "0", "0", "╝");
  }
}

class Tile3 extends Tile {
  Tile3() {
    super("0", "0", "1", "1", "╔");
  }
}

class Tile4 extends Tile {
  Tile4() {
    super("0", "1", "1", "0", "╗");
  }
}

class Tile5 extends Tile {
  Tile5() {
    super("1", "0", "1", "0", "║");
  }
}

class Tile6 extends Tile {
  Tile6() {
    super("0", "0", "0", "0", " ", 10);
  }
}

class Tile7 extends Tile {
  Tile7() {
    super("1", "1", "1", "1", "╬", 0.1);
  }
}

class Tile8 extends Tile {
  Tile8() {
    super("1", "0", "1", "1", "╠");
  }
}

class Tile9 extends Tile {
  Tile9() {
    super("1", "1", "1", "0", "╣");
  }
}

class Tile10 extends Tile {
  Tile10() {
    super("0", "1", "1", "1", "╦");
  }
}

class Tile11 extends Tile {
  Tile11() {
    super("1", "1", "0", "1", "╩");
  }
}

class Tile12 extends Tile {
  Tile12() {
    super("2", "1", "0", "1", "╧");
  }
}

class Tile13 extends Tile {
  Tile13() {
    super("2", "0", "2", "0", "│");
  }
}

class Tile14 extends Tile {
  Tile14() {
    super("0", "1", "2", "1", "╤");
  }
}

class TilesDatabase {
  
  public HashSet<Tile> tiles = new HashSet<>();
  
  TilesDatabase(Tile... tiles) {
    for (Tile this_tile : tiles) {
      this.tiles.add(this_tile);
      for (Tile that_tile : tiles) {
        if (this_tile.su.equals(that_tile.sd)) {
          this_tile.nu.add(that_tile);
          that_tile.nd.add(this_tile);
        }
        if (this_tile.sl.equals(that_tile.sr)) {
          this_tile.nl.add(that_tile);
          that_tile.nr.add(this_tile);
        }
        if (this_tile.sd.equals(that_tile.su)) {
          this_tile.nd.add(that_tile);
          that_tile.nu.add(this_tile);
        }
        if (this_tile.sr.equals(that_tile.sl)) {
          this_tile.nr.add(that_tile);
          that_tile.nl.add(this_tile);
        }
      }  
    }
  }
}
