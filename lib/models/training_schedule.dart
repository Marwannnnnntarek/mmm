enum TrainingSchedule {
  sundayTuesday,
  mondayWednesday,
  fridaySaturday;

  String toApiValue() => switch (this) {
        TrainingSchedule.sundayTuesday => 'SUN_TUE',
        TrainingSchedule.mondayWednesday => 'MON_WED',
        TrainingSchedule.fridaySaturday => 'FRI_SAT',
      };
}
