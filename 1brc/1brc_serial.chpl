use IO, Map, Time, TempData;

config const fileName = "sample_input.txt",
             printStats = false;

// create a fileReader to the input file
var fr = openReader(fileName, locking=false);

// create a map to store temperature statistics for each city
var cityStats = new map(string, tempStats);

// read a cityTemp from each line of the input file
// while accumulating temperature statistics for each city
var s = new stopwatch();
s.start();

var ct: cityTemp;
while fr.readln(ct) {
  if cityStats.contains(ct.city) {
    cityStats[ct.city] += ct.temp;
  } else {
    cityStats.add(ct.city, new tempStats(ct.temp));
  }
}

writeln("time: ", s.elapsed());

// write the accumulated statistics for all the cities
if printStats then writeln(cityStats);
