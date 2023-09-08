String getFormattedAddress(String address){
  return address.replaceAll("대한민국", '').replaceAll('제주특별자치도', '').trim();
}