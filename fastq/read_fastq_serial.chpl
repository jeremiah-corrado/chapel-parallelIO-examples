use IO, Fastq, Time, List;

config const fileName = "small.fastq";

var s = new stopwatch();
s.start();

const sequences = readFastqSequences(fileName);

writeln("time: ", s.elapsed());
writeln("sum: ", + reduce forall f in sequences do f.sum());


proc readFastqSequences(path: string): [] fastq {
  var fr = openReader(path, locking=false),
      sequences = new list(fastq);

  // read sequences until the end of the file
  var f: fastq;
  while fr.read(f) {
    sequences.pushBack(f);
  }

  // return an array of fastq sequences
  return sequences.toArray();
}
