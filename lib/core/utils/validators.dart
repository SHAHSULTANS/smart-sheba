class Validators {
  // Bangladesh phone number validation
  static bool isValidBangladeshiPhone(String phone) {
    // Remove spaces and hyphens
    String cleanPhone = phone.replaceAll(RegExp(r'[\s-]'), '');
    
    // Patterns for Bangladeshi numbers
    List<RegExp> patterns = [
      RegExp(r'^(\+8801|8801|01)[3-9]\d{8}$'),  // Standard format
      RegExp(r'^01[3-9]\d{8}$'),                // Local format
      RegExp(r'^\+88013\d{8}$'),                // Grameenphone
      RegExp(r'^\+88014\d{8}$'),                // Banglalink
      RegExp(r'^\+88015\d{8}$'),                // Teletalk
      RegExp(r'^\+88016\d{8}$'),                // Airtel
      RegExp(r'^\+88017\d{8}$'),                // Robi
      RegExp(r'^\+88018\d{8}$'),                // Robi
      RegExp(r'^\+88019\d{8}$'),                // Banglalink
    ];
    
    return patterns.any((pattern) => pattern.hasMatch(cleanPhone));
  }

  // Format phone number for display
  static String formatBangladeshiPhone(String phone) {
    String cleanPhone = phone.replaceAll(RegExp(r'[\s-+]'), '');
    
    if (cleanPhone.startsWith('880')) {
      cleanPhone = cleanPhone.substring(3);
    }
    
    if (cleanPhone.length == 11 && cleanPhone.startsWith('0')) {
      cleanPhone = cleanPhone.substring(1);
    }
    
    if (cleanPhone.length == 10) {
      return '+880 ${cleanPhone.substring(0, 2)} ${cleanPhone.substring(2, 5)} ${cleanPhone.substring(5, 8)} ${cleanPhone.substring(8)}';
    }
    
    return phone; // Return original if can't format
  }

  // Get carrier name from phone number
  static String getCarrierName(String phone) {
    String cleanPhone = phone.replaceAll(RegExp(r'[\s-+]'), '');
    
    if (cleanPhone.startsWith('880')) {
      cleanPhone = cleanPhone.substring(3);
    }
    
    if (cleanPhone.startsWith('0')) {
      cleanPhone = cleanPhone.substring(1);
    }
    
    if (cleanPhone.length >= 3) {
      String prefix = cleanPhone.substring(0, 3);
      switch (prefix) {
        case '130':
        case '131':
        case '132':
        case '133':
        case '134':
        case '135':
        case '136':
        case '137':
        case '138':
        case '139':
          return 'Grameenphone';
        case '140':
        case '141':
        case '142':
        case '143':
        case '144':
        case '145':
        case '146':
        case '147':
        case '148':
        case '149':
          return 'Banglalink';
        case '150':
        case '151':
        case '152':
        case '153':
        case '154':
        case '155':
        case '156':
        case '157':
        case '158':
        case '159':
          return 'Teletalk';
        case '160':
        case '161':
        case '162':
        case '163':
        case '164':
        case '165':
        case '166':
        case '167':
        case '168':
        case '169':
          return 'Airtel';
        case '170':
        case '171':
        case '172':
        case '173':
        case '174':
        case '175':
        case '176':
        case '177':
        case '178':
        case '179':
          return 'Robi';
        case '180':
        case '181':
        case '182':
        case '183':
        case '184':
        case '185':
        case '186':
        case '187':
        case '188':
        case '189':
          return 'Robi';
        case '190':
        case '191':
        case '192':
        case '193':
        case '194':
        case '195':
        case '196':
        case '197':
        case '198':
        case '199':
          return 'Banglalink';
        default:
          return 'Unknown';
      }
    }
    
    return 'Unknown';
  }

  // Validate OTP
  static bool isValidOtp(String otp) {
    return RegExp(r'^\d{6}$').hasMatch(otp);
  }

  // Validate name
  static bool isValidName(String name) {
    if (name.trim().isEmpty) return false;
    if (name.trim().length < 2) return false;
    if (name.trim().length > 50) return false;
    return RegExp(r'^[a-zA-Z\u0980-\u09FF\s.]+$').hasMatch(name);
  }

  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }
}