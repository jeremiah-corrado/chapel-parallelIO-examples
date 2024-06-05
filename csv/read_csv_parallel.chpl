use ParallelIO, Color, Time;

config const fileName = "colors.csv",
             nTasks = 4;

var s = new stopwatch();
s.start();

const colors = readDelimitedAsArray(
                fileName,
                t=color,
                nTasks=nTasks,
                header=headerPolicy.skipLines(1)
                delim="\n"
              );

writeln("time: ", s.elapsed());
writeln("sum: ", + reduce forall c in colors do c.sum());
