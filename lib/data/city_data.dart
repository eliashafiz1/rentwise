/// Built-in average monthly rent estimates for major U.S. cities.
/// When the user selects a city from the dropdown, the app pulls the
/// corresponding rent value from this map to pre-fill the rent field.
final Map<String, double> cityRentData = {
  'Washington, DC': 1800.0,
  'New York, NY': 2500.0,
  'Austin, TX': 1400.0,
  'Chicago, IL': 1350.0,
  'San Francisco, CA': 2800.0,
  'Miami, FL': 1700.0,
  'Denver, CO': 1500.0,
  'Los Angeles, CA': 2400.0,
  'Seattle, WA': 2000.0,
  'Atlanta, GA': 1550.0,
  'Boston, MA': 2300.0,
  'Dallas, TX': 1350.0,
  'Phoenix, AZ': 1300.0,
  'Nashville, TN': 1450.0,
  'Charlotte, NC': 1400.0,
};

/// Affordability threshold options (percentage of income).
final List<int> affordabilityThresholds = [30, 35, 40];
