class HexUtils {
  static const List<String> _digitsLower = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f'
  ];
  static const List<String> _digitsUpper = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F'
  ];

  static String _encodeHex(List<int> data, List<String> toDigits) {
    int l = data.length;
    List<String> out = List.filled(l * 2, '');
    int j = 0;
    for (int i = 0; i < l; i++) {
      out[j] = toDigits[(data[i] & 240) >> 4];
      j++;
      out[j] = toDigits[data[i] & 15];
      j++;
    }
    return out.join('');
  }

  static String encodeHexStr(List<int> data, {bool toLowerCase = true}) {
    return _encodeHex(data, toLowerCase ? _digitsLower : _digitsUpper);
  }

  static List<int> hexStringToBytes(String hexString) {
    if (hexString.isEmpty) {
      return List.empty();
    }
    List<int> bytes = [];
    for (int i = 0; i < hexString.length; i += 2) {
      String part = hexString.substring(i, i + 2);
      int byte = int.parse(part, radix: 16);
      bytes.add(byte);
    }
    return bytes;
  }

  static int _charToByte(String c) {
    return "0123456789ABCDEF".indexOf(c);
  }

  static String conver2HexStr(List<int> b) {
    StringBuffer result = StringBuffer();
    for (var b2 in b) {
      result.write(b2.toRadixString(2).padLeft(8, '0'));
    }
    return result.toString();
  }

  static String byteListToHexString(List<int> byteData) {
    return byteData
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  static String hexStringToBinaryString(String hexString) {
    // Parsing the hex string to an integer
    int intValue = int.parse(hexString, radix: 16);

    // Converting the integer to a binary string
    String binaryString = intValue.toRadixString(2);

    return binaryString;
  }
}
