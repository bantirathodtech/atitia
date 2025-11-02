// lib/feature/guest_dashboard/pgs/widgets/advanced_pg_search_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';

/// Advanced PG search widget with multiple criteria
/// Provides comprehensive search and filtering capabilities
class AdvancedPgSearchWidget extends StatefulWidget {
  final List<Map<String, dynamic>> allPGs;
  final Function(List<Map<String, dynamic>>) onSearchResults;
  final VoidCallback? onClearSearch;

  const AdvancedPgSearchWidget({
    super.key,
    required this.allPGs,
    required this.onSearchResults,
    this.onClearSearch,
  });

  @override
  State<AdvancedPgSearchWidget> createState() => _AdvancedPgSearchWidgetState();
}

class _AdvancedPgSearchWidgetState extends State<AdvancedPgSearchWidget> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  // Search criteria
  String _searchQuery = '';
  String _selectedCity = '';
  String _selectedArea = '';
  double _minRent = 0;
  double _maxRent = 100000;
  final List<String> _selectedAmenities = [];
  String _selectedGender = '';
  String _selectedFoodType = '';
  bool _hasParking = false;
  bool _hasWifi = false;
  bool _hasLaundry = false;
  bool _hasGym = false;
  bool _hasSecurity = false;

  // Saved searches
  List<SavedSearch> _savedSearches = [];
  bool _showSavedSearches = false;

  @override
  void initState() {
    super.initState();
    _loadSavedSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, isDark),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSearchForm(context, isDark),
            const SizedBox(height: AppSpacing.paddingL),
            _buildActionButtons(context, isDark),
            if (_savedSearches.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.paddingL),
              _buildSavedSearches(context, isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          ),
          child: const Icon(
            Icons.search,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeadingMedium(text: 'Advanced PG Search'),
              CaptionText(
                text: 'Find your perfect PG with detailed filters',
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _showSavedSearches = !_showSavedSearches;
            });
          },
          icon: Icon(
            _showSavedSearches ? Icons.visibility_off : Icons.bookmark,
            color: AppColors.primary,
          ),
          tooltip: 'Saved Searches',
        ),
      ],
    );
  }

  Widget _buildSearchForm(BuildContext context, bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic search
          _buildBasicSearch(isDark),
          const SizedBox(height: AppSpacing.paddingL),

          // Location filters
          _buildLocationFilters(isDark),
          const SizedBox(height: AppSpacing.paddingL),

          // Rent range
          _buildRentRange(isDark),
          const SizedBox(height: AppSpacing.paddingL),

          // Amenities
          _buildAmenitiesFilter(isDark),
          const SizedBox(height: AppSpacing.paddingL),

          // Additional filters
          _buildAdditionalFilters(isDark),
        ],
      ),
    );
  }

  Widget _buildBasicSearch(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingSmall(text: 'Search Query'),
        const SizedBox(height: AppSpacing.paddingS),
        TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by PG name, area, or keywords...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildLocationFilters(bool isDark) {
    final cities = widget.allPGs
        .map((pg) => pg['city'] as String? ?? '')
        .toSet()
        .toList()
      ..sort();
    final areas = widget.allPGs
        .where((pg) =>
            (pg['city'] as String? ?? '') == _selectedCity ||
            _selectedCity.isEmpty)
        .map((pg) => pg['area'] as String? ?? '')
        .toSet()
        .toList()
      ..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingSmall(text: 'Location'),
        const SizedBox(height: AppSpacing.paddingM),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _selectedCity.isEmpty ? null : _selectedCity,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                items: cities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value ?? '';
                    _selectedArea = ''; // Reset area when city changes
                  });
                },
              ),
            ),
            const SizedBox(width: AppSpacing.paddingM),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _selectedArea.isEmpty ? null : _selectedArea,
                decoration: const InputDecoration(
                  labelText: 'Area',
                  border: OutlineInputBorder(),
                ),
                items: areas.map((area) {
                  return DropdownMenuItem<String>(
                    value: area,
                    child: Text(area),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedArea = value ?? '';
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRentRange(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingSmall(text: 'Rent Range'),
        const SizedBox(height: AppSpacing.paddingM),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: _minRent.toString(),
                decoration: const InputDecoration(
                  labelText: 'Min Rent (₹)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _minRent = double.tryParse(value) ?? 0;
                },
              ),
            ),
            const SizedBox(width: AppSpacing.paddingM),
            const Text('to'),
            const SizedBox(width: AppSpacing.paddingM),
            Expanded(
              child: TextFormField(
                initialValue: _maxRent.toString(),
                decoration: const InputDecoration(
                  labelText: 'Max Rent (₹)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _maxRent = double.tryParse(value) ?? 100000;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.paddingS),
        RangeSlider(
          values: RangeValues(_minRent, _maxRent),
          min: 0,
          max: 100000,
          divisions: 100,
          labels: RangeLabels(
            '₹${_minRent.toInt()}',
            '₹${_maxRent.toInt()}',
          ),
          onChanged: (values) {
            setState(() {
              _minRent = values.start;
              _maxRent = values.end;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAmenitiesFilter(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingSmall(text: 'Amenities'),
        const SizedBox(height: AppSpacing.paddingM),
        Wrap(
          spacing: AppSpacing.paddingS,
          runSpacing: AppSpacing.paddingS,
          children: [
            _buildAmenityChip('Parking', _hasParking, (value) {
              setState(() {
                _hasParking = value;
              });
            }),
            _buildAmenityChip('WiFi', _hasWifi, (value) {
              setState(() {
                _hasWifi = value;
              });
            }),
            _buildAmenityChip('Laundry', _hasLaundry, (value) {
              setState(() {
                _hasLaundry = value;
              });
            }),
            _buildAmenityChip('Gym', _hasGym, (value) {
              setState(() {
                _hasGym = value;
              });
            }),
            _buildAmenityChip('Security', _hasSecurity, (value) {
              setState(() {
                _hasSecurity = value;
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenityChip(
      String label, bool isSelected, Function(bool) onChanged) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onChanged,
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildAdditionalFilters(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingSmall(text: 'Additional Filters'),
        const SizedBox(height: AppSpacing.paddingM),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _selectedGender.isEmpty ? null : _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender Preference',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: '', child: Text('Any')),
                  DropdownMenuItem(value: 'Male', child: Text('Male Only')),
                  DropdownMenuItem(value: 'Female', child: Text('Female Only')),
                  DropdownMenuItem(value: 'Mixed', child: Text('Mixed')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value ?? '';
                  });
                },
              ),
            ),
            const SizedBox(width: AppSpacing.paddingM),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue:
                    _selectedFoodType.isEmpty ? null : _selectedFoodType,
                decoration: const InputDecoration(
                  labelText: 'Food Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: '', child: Text('Any')),
                  DropdownMenuItem(value: 'Veg', child: Text('Vegetarian')),
                  DropdownMenuItem(
                      value: 'Non-Veg', child: Text('Non-Vegetarian')),
                  DropdownMenuItem(value: 'Both', child: Text('Both')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFoodType = value ?? '';
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            label: 'Clear All',
            onPressed: _clearAllFilters,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: PrimaryButton(
            label: 'Search',
            onPressed: _performSearch,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: PrimaryButton(
            label: 'Save Search',
            onPressed: _saveCurrentSearch,
          ),
        ),
      ],
    );
  }

  Widget _buildSavedSearches(BuildContext context, bool isDark) {
    if (!_showSavedSearches) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingSmall(text: 'Saved Searches'),
        const SizedBox(height: AppSpacing.paddingM),
        ..._savedSearches
            .map((search) => _buildSavedSearchItem(search, isDark)),
      ],
    );
  }

  Widget _buildSavedSearchItem(SavedSearch search, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[50],
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyText(
                  text: search.name,
                ),
                CaptionText(
                  text: search.description,
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _loadSavedSearch(search),
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Use Search',
          ),
          IconButton(
            onPressed: () => _deleteSavedSearch(search),
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Search',
          ),
        ],
      ),
    );
  }

  void _performSearch() {
    final filteredPGs = widget.allPGs.where((pg) {
      // Text search
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final pgName = (pg['pgName'] as String? ?? '').toLowerCase();
        final area = (pg['area'] as String? ?? '').toLowerCase();
        final city = (pg['city'] as String? ?? '').toLowerCase();

        if (!pgName.contains(query) &&
            !area.contains(query) &&
            !city.contains(query)) {
          return false;
        }
      }

      // Location filters
      if (_selectedCity.isNotEmpty &&
          (pg['city'] as String? ?? '') != _selectedCity) {
        return false;
      }
      if (_selectedArea.isNotEmpty &&
          (pg['area'] as String? ?? '') != _selectedArea) {
        return false;
      }

      // Rent range
      final rentAmount = (pg['rentAmount'] as num? ?? 0).toDouble();
      if (rentAmount < _minRent || rentAmount > _maxRent) {
        return false;
      }

      // Amenities (simplified - in real app, you'd check actual amenities)
      if (_hasParking && !(pg['hasParking'] as bool? ?? false)) return false;
      if (_hasWifi && !(pg['hasWifi'] as bool? ?? false)) return false;
      if (_hasLaundry && !(pg['hasLaundry'] as bool? ?? false)) return false;
      if (_hasGym && !(pg['hasGym'] as bool? ?? false)) return false;
      if (_hasSecurity && !(pg['hasSecurity'] as bool? ?? false)) return false;

      // Additional filters
      if (_selectedGender.isNotEmpty &&
          (pg['genderPreference'] as String? ?? '') != _selectedGender) {
        return false;
      }
      if (_selectedFoodType.isNotEmpty &&
          (pg['foodType'] as String? ?? '') != _selectedFoodType) {
        return false;
      }

      return true;
    }).toList();

    widget.onSearchResults(filteredPGs);
  }

  void _clearAllFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCity = '';
      _selectedArea = '';
      _minRent = 0;
      _maxRent = 100000;
      _selectedAmenities.clear();
      _selectedGender = '';
      _selectedFoodType = '';
      _hasParking = false;
      _hasWifi = false;
      _hasLaundry = false;
      _hasGym = false;
      _hasSecurity = false;
    });
    _searchController.clear();
    widget.onClearSearch?.call();
  }

  void _saveCurrentSearch() {
    final searchName = 'Search ${_savedSearches.length + 1}';
    final search = SavedSearch(
      name: searchName,
      description: _buildSearchDescription(),
      criteria: _buildSearchCriteria(),
    );

    setState(() {
      _savedSearches.add(search);
    });

    _saveSearchesToStorage();
  }

  void _loadSavedSearch(SavedSearch search) {
    setState(() {
      _searchQuery = search.criteria['searchQuery'] ?? '';
      _selectedCity = search.criteria['city'] ?? '';
      _selectedArea = search.criteria['area'] ?? '';
      _minRent = search.criteria['minRent'] ?? 0.0;
      _maxRent = search.criteria['maxRent'] ?? 100000.0;
      _selectedGender = search.criteria['gender'] ?? '';
      _selectedFoodType = search.criteria['foodType'] ?? '';
      _hasParking = search.criteria['hasParking'] ?? false;
      _hasWifi = search.criteria['hasWifi'] ?? false;
      _hasLaundry = search.criteria['hasLaundry'] ?? false;
      _hasGym = search.criteria['hasGym'] ?? false;
      _hasSecurity = search.criteria['hasSecurity'] ?? false;
    });

    _searchController.text = _searchQuery;
    _performSearch();
  }

  void _deleteSavedSearch(SavedSearch search) {
    setState(() {
      _savedSearches.remove(search);
    });
    _saveSearchesToStorage();
  }

  String _buildSearchDescription() {
    final parts = <String>[];
    if (_searchQuery.isNotEmpty) parts.add('"$_searchQuery"');
    if (_selectedCity.isNotEmpty) parts.add(_selectedCity);
    if (_selectedArea.isNotEmpty) parts.add(_selectedArea);
    parts.add('₹$_minRent-₹$_maxRent');
    return parts.join(' • ');
  }

  Map<String, dynamic> _buildSearchCriteria() {
    return {
      'searchQuery': _searchQuery,
      'city': _selectedCity,
      'area': _selectedArea,
      'minRent': _minRent,
      'maxRent': _maxRent,
      'gender': _selectedGender,
      'foodType': _selectedFoodType,
      'hasParking': _hasParking,
      'hasWifi': _hasWifi,
      'hasLaundry': _hasLaundry,
      'hasGym': _hasGym,
      'hasSecurity': _hasSecurity,
    };
  }

  void _loadSavedSearches() {
    // TODO: Load from local storage
    _savedSearches = [];
  }

  void _saveSearchesToStorage() {
    // TODO: Save to local storage
  }
}

/// Saved search data model
class SavedSearch {
  final String name;
  final String description;
  final Map<String, dynamic> criteria;

  SavedSearch({
    required this.name,
    required this.description,
    required this.criteria,
  });
}
