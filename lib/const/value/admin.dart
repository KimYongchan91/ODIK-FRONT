enum AdminType { kke, kse, kyc, syh }

String getAdminName(AdminType adminType) {
  switch (adminType) {
    case AdminType.kke:
      return "김경은";

    case AdminType.kse:
      return "김승은";

    case AdminType.kyc:
      return "김용찬";

    case AdminType.syh:
      return "심연화";

    default:
      return "";
  }
}
