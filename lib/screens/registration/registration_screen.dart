import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../models/registration_request.dart';
import '../../providers/registration_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_button.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _parentNameCtrl = TextEditingController();
  final _parentPhoneCtrl = TextEditingController();
  final _childNameCtrl = TextEditingController();
  final _childAgeCtrl = TextEditingController();
  final _preferredBranchCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _childGender = 'male';
  String? _swimmingLevel;
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _parentNameCtrl.dispose();
    _parentPhoneCtrl.dispose();
    _childNameCtrl.dispose();
    _childAgeCtrl.dispose();
    _preferredBranchCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    final request = RegistrationRequest(
      parentName: _parentNameCtrl.text.trim(),
      parentPhone: _parentPhoneCtrl.text.trim(),
      childName: _childNameCtrl.text.trim(),
      childAge: int.parse(_childAgeCtrl.text.trim()),
      childGender: _childGender,
      swimmingLevel: _swimmingLevel!,
      preferredBranch: _preferredBranchCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    try {
      await ref.read(supabaseServiceProvider).submitRegistrationRequest(request);
      if (mounted) context.go('/success');
    } catch (_) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _errorMessage = AppLocalizations.of(context)!.errorSubmissionFailed;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/');
      },
      child: Scaffold(
        backgroundColor: SlaColors.background,
        body: CustomScrollView(
          slivers: [
            _buildAppBar(l10n),
            SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    children: [
                      _buildSectionCard(
                        icon: Icons.family_restroom_rounded,
                        title: l10n.stepParentInfo,
                        content: _buildParentSection(l10n),
                      ),
                      _buildSectionCard(
                        icon: Icons.person_outline_rounded,
                        title: l10n.stepChildInfo,
                        content: _buildChildSection(l10n),
                      ),
                      _buildSectionCard(
                        icon: Icons.pool_rounded,
                        title: l10n.stepRegistrationDetails,
                        content: _buildDetailsSection(l10n),
                      ),
                      _buildSectionCard(
                        icon: Icons.notes_rounded,
                        title: l10n.notesOptional,
                        content: _buildNotesSection(l10n),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 4),
                        _buildErrorBanner(),
                      ],
                      const SizedBox(height: 8),
                      _buildSubmitButton(l10n),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── App bar ───────────────────────────────────────────────────────────────

  Widget _buildAppBar(AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 110,
      pinned: true,
      backgroundColor: SlaColors.darkNavy,
      foregroundColor: Colors.white,
      leading: BackButton(onPressed: () => context.go('/')),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 56, bottom: 14, right: 16),
        title: Text(
          l10n.registrationTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(gradient: SlaGradients.header),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                Icons.sports_score_rounded,
                size: 72,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Section card shell ────────────────────────────────────────────────────

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: SlaColors.primaryPurple.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: const BoxDecoration(
              gradient: SlaGradients.header,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 19),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ],
      ),
    );
  }

  // ── Form sections ─────────────────────────────────────────────────────────

  Widget _buildParentSection(AppLocalizations l10n) {
    return Column(
      children: [
        _field(
          controller: _parentNameCtrl,
          label: l10n.parentFullName,
          required: true,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? l10n.validationRequired : null,
        ),
        const SizedBox(height: 14),
        _field(
          controller: _parentPhoneCtrl,
          label: l10n.parentMobile,
          required: true,
          hint: '01X XXXX XXXX',
          keyboardType: TextInputType.phone,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return l10n.validationRequired;
            final digits = v.replaceAll(RegExp(r'\D'), '');
            if (digits.length < 10) return l10n.validationMobileFormat;
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildChildSection(AppLocalizations l10n) {
    return Column(
      children: [
        _field(
          controller: _childNameCtrl,
          label: l10n.childName,
          required: true,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? l10n.validationRequired : null,
        ),
        const SizedBox(height: 14),
        _field(
          controller: _childAgeCtrl,
          label: l10n.childAge,
          required: true,
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return l10n.validationRequired;
            final age = int.tryParse(v.trim());
            if (age == null || age < 1 || age > 99) return l10n.validationAge;
            return null;
          },
        ),
        const SizedBox(height: 14),
        _buildGenderSelector(l10n),
      ],
    );
  }

  Widget _buildGenderSelector(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('${l10n.playerGender} *'),
        const SizedBox(height: 8),
        Row(
          children: [
            _genderOption(l10n.genderMale, 'male', Icons.male_rounded),
            const SizedBox(width: 12),
            _genderOption(l10n.genderFemale, 'female', Icons.female_rounded),
          ],
        ),
      ],
    );
  }

  Widget _genderOption(String label, String value, IconData icon) {
    final selected = _childGender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _childGender = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? SlaColors.primaryPurple : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? SlaColors.primaryPurple : SlaColors.inputBorder,
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: SlaColors.primaryPurple.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? Colors.white : SlaColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : SlaColors.darkNavy,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection(AppLocalizations l10n) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: _swimmingLevel,
          decoration: InputDecoration(labelText: '${l10n.swimmingLevel} *'),
          items: [
            DropdownMenuItem(value: 'beginner', child: Text(l10n.swimBeginner)),
            DropdownMenuItem(
                value: 'intermediate', child: Text(l10n.swimIntermediate)),
            DropdownMenuItem(
                value: 'advanced', child: Text(l10n.swimAdvanced)),
          ],
          onChanged: (v) => setState(() => _swimmingLevel = v),
          validator: (v) => v == null ? l10n.validationRequired : null,
        ),
        const SizedBox(height: 14),
        _field(
          controller: _preferredBranchCtrl,
          label: l10n.preferredBranch,
          required: true,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? l10n.validationRequired : null,
        ),
      ],
    );
  }

  Widget _buildNotesSection(AppLocalizations l10n) {
    return _field(
      controller: _notesCtrl,
      label: l10n.notesOptional,
      required: false,
      maxLines: 3,
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SlaColors.redOrange.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: SlaColors.redOrange, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: SlaColors.redOrange, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(AppLocalizations l10n) {
    return GradientButton(
      onPressed: _submitting ? null : _submit,
      isLoading: _submitting,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.send_rounded, size: 20),
          const SizedBox(width: 8),
          Text(l10n.submitButton),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _field({
    required TextEditingController controller,
    required String label,
    required bool required,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textInputAction:
          maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
      ),
      validator: validator,
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: SlaColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
