import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/pantry_item.dart';
import '../domain/pantry_provider.dart';

class AddEditPantryItemScreen extends ConsumerStatefulWidget {
  final PantryItem? existingItem;

  const AddEditPantryItemScreen({
    super.key,
    this.existingItem,
  });

  @override
  ConsumerState<AddEditPantryItemScreen> createState() => _AddEditPantryItemScreenState();
}

class _AddEditPantryItemScreenState extends ConsumerState<AddEditPantryItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _qtyController;
  late final TextEditingController _thresholdController;
  
  late String _selectedCategory;
  late String _selectedUnit;
  late bool _isRecurring;
  late StockStatus _stockStatus;

  @override
  void initState() {
    super.initState();
    final item = widget.existingItem;
    
    _nameController = TextEditingController(text: item?.name ?? '');
    _qtyController = TextEditingController(text: item?.quantity.toString() ?? '1.0');
    _thresholdController = TextEditingController(text: item?.lowStockThreshold.toString() ?? '1.0');
    
    final availableCategories = AppConstants.categories.where((c) => c != 'All').toList();
    _selectedCategory = item?.category ?? (availableCategories.isNotEmpty ? availableCategories.first : 'Misc');
    
    _selectedUnit = item?.unit ?? AppConstants.units.first;
    _isRecurring = item?.isRecurring ?? false;
    _stockStatus = item?.stockStatus ?? StockStatus.enough;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  void _saveItem() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final qty = double.tryParse(_qtyController.text.trim()) ?? 0.0;
      final threshold = double.tryParse(_thresholdController.text.trim()) ?? 1.0;

      StockStatus finalStatus = _stockStatus;
      if (widget.existingItem == null) {
        if (qty <= 0) {
          finalStatus = StockStatus.finished;
        } else if (qty <= threshold) {
          finalStatus = StockStatus.low;
        } else {
          finalStatus = StockStatus.enough;
        }
      }

      final now = DateTime.now();
      final itemToSave = PantryItem(
        id: widget.existingItem?.id ?? now.millisecondsSinceEpoch.toString(),
        name: name,
        category: _selectedCategory,
        quantity: qty,
        unit: _selectedUnit,
        lowStockThreshold: threshold,
        stockStatus: finalStatus,
        createdAt: widget.existingItem?.createdAt ?? now,
        updatedAt: now,
        isRecurring: _isRecurring,
      );

      final notifier = ref.read(pantryProvider.notifier);
      if (widget.existingItem == null) {
        notifier.addItem(itemToSave);
      } else {
        notifier.updateItem(itemToSave);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingItem != null;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Item' : 'New Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Icon/Illustration
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryEmerald.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.package, size: 48, color: AppTheme.primaryEmerald),
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
              
              const SizedBox(height: 32),

              // Item Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Item Name (e.g. Organic Milk)',
                  prefixIcon: Icon(LucideIcons.type, size: 20),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a name' : null,
              ).animate().fadeIn(delay: 100.ms).moveX(begin: -10, end: 0),
              
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  hintText: 'Select Category',
                  prefixIcon: Icon(LucideIcons.tag, size: 20),
                ),
                items: AppConstants.categories
                    .where((c) => c != 'All')
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ).animate().fadeIn(delay: 200.ms).moveX(begin: -10, end: 0),
              
              const SizedBox(height: 16),

              // Quantity & Unit
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _qtyController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: 'Quantity',
                        prefixIcon: Icon(LucideIcons.hash, size: 20),
                      ),
                      validator: (value) => (value == null || double.tryParse(value) == null) ? 'Invalid' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      decoration: const InputDecoration(
                        hintText: 'Unit',
                      ),
                      items: AppConstants.units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedUnit = val);
                      },
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms).moveX(begin: -10, end: 0),
              
              const SizedBox(height: 16),

              // Threshold
              TextFormField(
                controller: _thresholdController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: 'Low stock threshold',
                  prefixIcon: Icon(LucideIcons.alertCircle, size: 20),
                ),
                validator: (value) => (value == null || double.tryParse(value) == null) ? 'Invalid' : null,
              ).animate().fadeIn(delay: 400.ms).moveX(begin: -10, end: 0),
              
              const SizedBox(height: 24),

              // Recurring Toggle
              Card(
                child: SwitchListTile(
                  title: const Text('Recurring Item', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Add to shopping list automatically', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.5))),
                  value: _isRecurring,
                  activeColor: AppTheme.primaryEmerald,
                  onChanged: (val) => setState(() => _isRecurring = val),
                  secondary: const Icon(LucideIcons.repeat, size: 20, color: AppTheme.primaryEmerald),
                ),
              ).animate().fadeIn(delay: 500.ms),
              
              const SizedBox(height: 40),

              // Save Button
              ElevatedButton(
                onPressed: _saveItem,
                child: Text(isEditing ? 'Save Changes' : 'Create Item'),
              ).animate().fadeIn(delay: 600.ms).scale(),
            ],
          ),
        ),
      ),
    );
  }
}
