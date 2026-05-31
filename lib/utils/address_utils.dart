class AddressUtils {
  static String getLast(String? fullAddress){
    if (fullAddress == null || fullAddress.isEmpty) return 'Chưa xác định';
    List<String> parts = fullAddress.split(',');
    String lastPart = parts.last.trim();
    lastPart = lastPart.replaceFirst(RegExp(r'^(tỉnh|Tỉnh)\s*'), '').trim();
    return lastPart.isEmpty ? 'Chưa xác định' : lastPart;
  }
  static String getFullAddress(String? address){
    if (address == null || address.isEmpty) return '';
    List<String> parts = address.split(',');
    if(parts.length > 1){
      return parts.sublist(0, parts.length - 1).join(', ').trim();
    }
    return address;
  }
}