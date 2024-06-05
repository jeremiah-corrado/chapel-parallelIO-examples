module Fastq {
  use IO;

  record fastq: serializable {
    var id: string;     // ID and meta-data for sequence (beginning with '@')
    var seq: bytes;     // sequence data (A, C, G, T)
    var desc: string;   // optional description of sequence (beginning with '+')
    var qual: bytes;    // quality scores for each nucleotide in sequence: 0x21 ('!') -> 0x7E ('~')

    proc init() {
      this.id = "";
      this.seq = "";
      this.desc = "";
      this.qual = "";
    }

    /*
      calculate the sum of the quality scores for the sequence
    */
    proc sum(): int {
      var sum = 0;
      for q in qual do sum += q:int;
      return sum;
    }
  }

  param atByte = b'@'.toByte();

  /*
    Attempt to deserialize a 'fastq' sequence from a fileReader

    (throw an error if there isn't a valid sequence at the current file position)
  */
  proc ref fastq.deserialize(reader: fileReader(?), ref deserializer) throws {
    reader.readLiteral("@", ignoreWhitespace=false);
    this.id = reader.readLine(string, stripNewline=true);
    this.seq = reader.readLine(bytes, stripNewline=true);

    if seq[0] == atByte
      then throw new Error("Invalid character in sequence");

    reader.readLiteral("+", ignoreWhitespace=false);
    this.desc = reader.readLine(string, stripNewline=true);
    this.qual = reader.readLine(bytes, stripNewline=true);

    if seq.size != qual.size
      then throw new Error("Sequence and quality score lengths do not match");
  }
}
