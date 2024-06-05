use ParallelIO, Map, Time, TempData;
use MapReduceHelp;

config const fileName = "sample_input.txt",
             printStats = false,
             nTasks = 4;

// create a map to store temperature statistics for each city
// wrap the map in a Lock to allow safe concurrent access
var cityStats = new Lock(new map(string, tempStats));

// read cityTemp values from the lines of the file in parallel,
// while accumulating the statistics for each city into a map
var s = new stopwatch();
s.start();

forall ct in readDelimited(fileName, t=cityTemp, delim="\n", nTasks=nTasks)
  with (var mr = new mapReducer(cityStats))
    do mr.addOrUpdate(ct.city, ct.temp);

writeln("time: ", s.elapsed());

// write the accumulated statistics for all the cities
if printStats then writeln(cityStats.item);


/*
  Module to help with the map-reduce pattern
*/
module MapReduceHelp {
  use super.TempData, Map;

  /*
    The number of items to accumulate before flushing to the global map
  */
  config const flushThresh = 16;

  /*
    A record to facilitate reducing temperature statistics into a global map
  */
  record mapReducer {
    var globalMap: borrowed sharedLock(map(string, tempStats));
    var localMap: map(string, tempStats);

    proc init(globalMap: borrowed sharedLock(map(string, tempStats))) {
      this.globalMap = globalMap;
      this.localMap = new map(string, tempStats, initialCapacity=flushThresh);
    }

    /*
      Add a (city, tempStats) pair to the local map if the city is not already
      present; otherwise, update the tempStats for the city.

      If the local map reaches the flush threshold, flush the local map's
      data to the global map
    */
    proc ref addOrUpdate(city: string, temp: real) throws {
      if this.localMap.contains(city)
        then this.localMap[city] += temp;
        else this.localMap.add(city, new tempStats(temp));

      if this.localMap.size >= flushThresh then this.flush();
    }

    // flush upon deinitialization
    proc ref deinit() do this.flush();

    // acquire the lock for the global map, and flush this map's contents into it
    // (does not need to be called directly)
    proc ref flush() {
      manage this.globalMap as gm {
        for (k, v) in zip(this.localMap.keys(), this.localMap.values()) {
          if gm.contains(k)
            then gm[k] += v;
            else gm.add(k, v);
        }
      }

      this.localMap.clear();
    }
  }

  /*
    A generic 'Lock' type to facilitate safe access to a shared item
    from multiple tasks running concurrently
  */
  class Lock: contextManager {
    type T;
    var item: T;
    var isLocked: atomic bool;

    proc init(in item: ?t) {
      this.T = t;
      this.item = item;
      init this;
      this.isLocked.write(false);
    }

    proc enterContext() ref: T {
      var waitingFor = false;
      while !this.isLocked.compareExchange(waitingFor, true) {
        waitingFor = false;
      }
      return this.item;
    }

    proc exitContext(in err: owned Error?) {
      if err then halt(err!.message());
      this.isLocked.write(false);
    }
  }
}
