/// Indian states and cities data for dropdown selections
/// 
/// Provides comprehensive list of Indian states and their cities
/// Used for address forms, location selection, and geographic filtering
class IndianStatesCities {
  /// Map of Indian states to their major cities
  static const Map<String, List<String>> statesWithCities = {
    'Andhra Pradesh': [
      'Visakhapatnam',
      'Vijayawada',
      'Guntur',
      'Nellore',
      'Kurnool',
      'Rajahmundry',
      'Tirupati',
      'Kakinada',
      'Anantapur',
      'Kadapa',
    ],
    'Telangana': [
      'Hyderabad',
      'Warangal',
      'Nizamabad',
      'Khammam',
      'Karimnagar',
      'Ramagundam',
      'Mahbubnagar',
      'Nalgonda',
      'Adilabad',
      'Suryapet',
    ],
    'Karnataka': [
      'Bangalore',
      'Mysore',
      'Hubli',
      'Mangalore',
      'Belgaum',
      'Gulbarga',
      'Davangere',
      'Bellary',
      'Bijapur',
      'Shimoga',
    ],
    'Tamil Nadu': [
      'Chennai',
      'Coimbatore',
      'Madurai',
      'Tiruchirappalli',
      'Salem',
      'Tirunelveli',
      'Tiruppur',
      'Erode',
      'Vellore',
      'Thoothukudi',
    ],
    'Maharashtra': [
      'Mumbai',
      'Pune',
      'Nagpur',
      'Thane',
      'Nashik',
      'Aurangabad',
      'Solapur',
      'Amravati',
      'Kolhapur',
      'Sangli',
    ],
    'Gujarat': [
      'Ahmedabad',
      'Surat',
      'Vadodara',
      'Rajkot',
      'Bhavnagar',
      'Jamnagar',
      'Junagadh',
      'Gandhinagar',
      'Anand',
      'Nadiad',
    ],
    'Rajasthan': [
      'Jaipur',
      'Jodhpur',
      'Kota',
      'Bikaner',
      'Udaipur',
      'Ajmer',
      'Bhilwara',
      'Alwar',
      'Bharatpur',
      'Sikar',
    ],
    'Madhya Pradesh': [
      'Indore',
      'Bhopal',
      'Jabalpur',
      'Gwalior',
      'Ujjain',
      'Sagar',
      'Dewas',
      'Satna',
      'Ratlam',
      'Rewa',
    ],
    'Uttar Pradesh': [
      'Lucknow',
      'Kanpur',
      'Ghaziabad',
      'Agra',
      'Varanasi',
      'Meerut',
      'Prayagraj',
      'Bareilly',
      'Aligarh',
      'Moradabad',
    ],
    'Delhi': [
      'New Delhi',
      'North Delhi',
      'South Delhi',
      'East Delhi',
      'West Delhi',
      'Central Delhi',
      'Dwarka',
      'Rohini',
      'Janakpuri',
      'Karol Bagh',
    ],
    'West Bengal': [
      'Kolkata',
      'Howrah',
      'Durgapur',
      'Asansol',
      'Siliguri',
      'Bardhaman',
      'Malda',
      'Baharampur',
      'Habra',
      'Kharagpur',
    ],
    'Punjab': [
      'Ludhiana',
      'Amritsar',
      'Jalandhar',
      'Patiala',
      'Bathinda',
      'Mohali',
      'Hoshiarpur',
      'Batala',
      'Pathankot',
      'Moga',
    ],
    'Haryana': [
      'Faridabad',
      'Gurgaon',
      'Panipat',
      'Ambala',
      'Yamunanagar',
      'Rohtak',
      'Hisar',
      'Karnal',
      'Sonipat',
      'Panchkula',
    ],
    'Bihar': [
      'Patna',
      'Gaya',
      'Bhagalpur',
      'Muzaffarpur',
      'Darbhanga',
      'Bihar Sharif',
      'Arrah',
      'Begusarai',
      'Katihar',
      'Munger',
    ],
    'Odisha': [
      'Bhubaneswar',
      'Cuttack',
      'Rourkela',
      'Brahmapur',
      'Sambalpur',
      'Puri',
      'Balasore',
      'Bhadrak',
      'Baripada',
      'Jharsuguda',
    ],
    'Kerala': [
      'Thiruvananthapuram',
      'Kochi',
      'Kozhikode',
      'Thrissur',
      'Kollam',
      'Palakkad',
      'Alappuzha',
      'Malappuram',
      'Kannur',
      'Kottayam',
    ],
    'Jharkhand': [
      'Ranchi',
      'Jamshedpur',
      'Dhanbad',
      'Bokaro',
      'Deoghar',
      'Phusro',
      'Hazaribagh',
      'Giridih',
      'Ramgarh',
      'Medininagar',
    ],
    'Assam': [
      'Guwahati',
      'Silchar',
      'Dibrugarh',
      'Jorhat',
      'Nagaon',
      'Tinsukia',
      'Tezpur',
      'Bongaigaon',
      'Diphu',
      'Dhubri',
    ],
    'Chhattisgarh': [
      'Raipur',
      'Bhilai',
      'Bilaspur',
      'Korba',
      'Durg',
      'Rajnandgaon',
      'Jagdalpur',
      'Raigarh',
      'Ambikapur',
      'Dhamtari',
    ],
    'Uttarakhand': [
      'Dehradun',
      'Haridwar',
      'Roorkee',
      'Haldwani',
      'Rudrapur',
      'Kashipur',
      'Rishikesh',
      'Pithoragarh',
      'Nainital',
      'Almora',
    ],
    'Himachal Pradesh': [
      'Shimla',
      'Dharamshala',
      'Solan',
      'Mandi',
      'Palampur',
      'Baddi',
      'Nahan',
      'Una',
      'Kullu',
      'Hamirpur',
    ],
    'Jammu and Kashmir': [
      'Srinagar',
      'Jammu',
      'Anantnag',
      'Baramulla',
      'Sopore',
      'Kathua',
      'Udhampur',
      'Pulwama',
      'Rajouri',
      'Kupwara',
    ],
    'Goa': [
      'Panaji',
      'Margao',
      'Vasco da Gama',
      'Mapusa',
      'Ponda',
      'Bicholim',
      'Curchorem',
      'Sanquelim',
      'Cuncolim',
      'Quepem',
    ],
    'Puducherry': [
      'Puducherry',
      'Karaikal',
      'Yanam',
      'Mahe',
    ],
    'Chandigarh': [
      'Chandigarh',
    ],
  };

  /// Get list of all states
  static List<String> get states => statesWithCities.keys.toList()..sort();

  /// Get cities for a specific state
  static List<String> getCitiesForState(String state) {
    return statesWithCities[state] ?? [];
  }

  /// Validate if state exists
  static bool isValidState(String state) {
    return statesWithCities.containsKey(state);
  }

  /// Validate if city exists in state
  static bool isValidCity(String state, String city) {
    final cities = statesWithCities[state];
    return cities != null && cities.contains(city);
  }

  /// Search states by query
  static List<String> searchStates(String query) {
    if (query.isEmpty) return states;
    return states
        .where((state) => state.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Search cities in a state by query
  static List<String> searchCities(String state, String query) {
    final cities = getCitiesForState(state);
    if (query.isEmpty) return cities;
    return cities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

