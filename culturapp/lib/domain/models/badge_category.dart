class BadgeCategory {
    late String name;
    late String image;
    late int lastActivities;
    late int totalActivities;
    late int actualActivities;
    late String rank;
    late double progress;

    BadgeCategory(this.name, this.totalActivities, this.actualActivities, this.rank){
      lastActivities = totalActivities - actualActivities;
      progress = actualActivities.toDouble() / totalActivities.toDouble();
      image = wichBadge(name, rank);
    }

    String wichBadge(String name, String rank) {
      switch (name) {
        case 'circ':
          return 'assets/badges/circ_$rank.png';
        default:
          return 'assets/images/badge.png';
      }
    }
}