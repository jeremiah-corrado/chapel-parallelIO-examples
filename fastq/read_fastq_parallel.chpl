use ParallelIO, Fastq, Time;

config const fileName = "small.fastq",
              nTasks = 4;

var s = new stopwatch();
s.start();

const sequences = readItemsAsArray(
                    fileName,
                    fastq,
                    b"\n@",
                    nTasks=nTasks
                  );

writeln("time: ", s.elapsed());
writeln("sum: ", + reduce forall f in sequences do f.sum());
