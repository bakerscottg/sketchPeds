class Citizen {
  ArrayList<Ped> peds;

  Citizen() {
    peds = new ArrayList<Ped>();
  }

  void run() {
    for (Ped p : peds) {
      p.run(peds);
    }
  }


  void addPed(Ped p) {
    peds.add(p);
  }
}

