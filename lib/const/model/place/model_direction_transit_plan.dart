class ModelDirectionTransitPlan {
  final int pathType;
  final int countTransfer;
  final int distanceTotal;
  final int distanceWalk;
  final int durationTotal;
  final int durationWalk;
  final int fareTotal;

  const ModelDirectionTransitPlan({
    required this.pathType,
    required this.countTransfer,
    required this.distanceTotal,
    required this.distanceWalk,
    required this.durationTotal,
    required this.durationWalk,
    required this.fareTotal,
  });
}
