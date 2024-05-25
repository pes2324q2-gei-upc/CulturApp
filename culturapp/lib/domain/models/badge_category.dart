class BadgeCategory {
    late String name;
    late String image;
    late int lastActivities;
    late int totalActivities;
    late int actualActivities;
    late String rank;
    late double progress;

    BadgeCategory(this.name, this.actualActivities, this.rank){
      if (rank == 't') {
        totalActivities = 10;
      } else if (rank == 'b') {
        totalActivities = 50;
      } else if (rank == 'p') {
        totalActivities = 100;
      } else {
        totalActivities = actualActivities;
      }
      lastActivities = totalActivities - actualActivities;
      progress = actualActivities.toDouble() / totalActivities.toDouble();
      image = 'assets/badges/${name}_$rank.png';
    }
}