module Color {
  use IO;
  use Random;

  /*
    A record representing an RGB color
  */
  record color: serializable {
    var r, g, b: uint(8);

    proc init() {
      r = 0;
      g = 0;
      b = 0;
    }

    proc init(r: uint(8), g: uint(8), b: uint(8)) {
      this.r = r;
      this.g = g;
      this.b = b;
    }

    /*
      Sum of the color components
    */
    proc sum(): int {
      return this.r:int + this.g:int + this.b:int;
    }
  }

  /*
    Deserialize a 'Color' from a fileReader in CSV format ("r,g,b")
  */
  proc ref color.deserialize(reader: fileReader(?), ref deserializer) throws {
    reader.read(this.r);
    reader.readLiteral(b",");
    reader.read(this.g);
    reader.readLiteral(b",");
    reader.read(this.b);
  }

  /*
    Serialize a 'Color' into a fileWriter in CSV format ("r,g,b")
  */
  proc color.serialize(writer: fileWriter(?), ref serializer) throws {
    writer.write(this.r);
    writer.writeLiteral(b",");
    writer.write(this.g);
    writer.writeLiteral(b",");
    writer.write(this.b);
  }

  private var rng = new randomStream(uint(8));

  /*
    Generate a random color
  */
  proc type color.random(): color {
    return new color(
      rng.next(),
      rng.next(),
      rng.next()
    );
  }
}
