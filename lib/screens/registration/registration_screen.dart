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

  // Player
  final _firstNameCtrl = TextEditingController();
  final _middleNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  DateTime? _dateOfBirth;
  String _gender = 'male';
  final _schoolCtrl = TextEditingController();
  final _clubCtrl = TextEditingController();

  // Guardian
  final _fatherPhoneCtrl = TextEditingController();
  final _motherPhoneCtrl = TextEditingController();
  final _emergencyPhoneCtrl = TextEditingController();
  final _fatherOccupationCtrl = TextEditingController();
  final _motherOccupationCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  // Consent & referral
  bool _agreedToTerms = false;
  bool _showConsentError = false;
  final Set<String> _referralSources = {};

  // Submission
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _middleNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _dobCtrl.dispose();
    _schoolCtrl.dispose();
    _clubCtrl.dispose();
    _fatherPhoneCtrl.dispose();
    _motherPhoneCtrl.dispose();
    _emergencyPhoneCtrl.dispose();
    _fatherOccupationCtrl.dispose();
    _motherOccupationCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';

  int _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  bool _isValidEgyptianPhone(String value) {
    final digits = value.replaceAll(RegExp(r'[\s\-]'), '');
    return RegExp(r'^01[0-9]\d{8}$').hasMatch(digits);
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial =
        _dateOfBirth ?? DateTime(now.year - 8, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(now) ? now : initial,
      firstDate: DateTime(now.year - 25),
      lastDate: now,
    );
    if (picked != null && mounted) {
      setState(() {
        _dateOfBirth = picked;
        _dobCtrl.text = _formatDate(picked);
      });
    }
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState!.validate();

    if (!_agreedToTerms) {
      setState(() => _showConsentError = true);
    }

    if (!formValid || !_agreedToTerms) return;

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    final request = RegistrationRequest(
      playerFirstName: _firstNameCtrl.text.trim(),
      playerMiddleName: _middleNameCtrl.text.trim(),
      playerLastName: _lastNameCtrl.text.trim(),
      dateOfBirth: _dateOfBirth!,
      gender: _gender,
      school:
          _schoolCtrl.text.trim().isEmpty ? null : _schoolCtrl.text.trim(),
      club: _clubCtrl.text.trim().isEmpty ? null : _clubCtrl.text.trim(),
      fatherPhone: _fatherPhoneCtrl.text.trim(),
      motherPhone: _motherPhoneCtrl.text.trim(),
      emergencyPhone: _emergencyPhoneCtrl.text.trim(),
      fatherOccupation: _fatherOccupationCtrl.text.trim().isEmpty
          ? null
          : _fatherOccupationCtrl.text.trim(),
      motherOccupation: _motherOccupationCtrl.text.trim().isEmpty
          ? null
          : _motherOccupationCtrl.text.trim(),
      email:
          _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      referralSources: _referralSources.toList(),
    );

    try {
      await ref.read(supabaseServiceProvider).submitRegistrationRequest(request);
      if (mounted) context.go('/success');
    } catch (e) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _errorMessage = AppLocalizations.of(context)!.errorSubmissionFailed;
        });
        debugPrint('Submission error: $e');
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

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
                        icon: Icons.person_outline_rounded,
                        title: l10n.stepPlayerInfo,
                        content: _buildPlayerSection(l10n),
                      ),
                      _buildSectionCard(
                        icon: Icons.family_restroom_rounded,
                        title: l10n.stepParentInfo,
                        content: _buildGuardianSection(l10n),
                      ),
                      _buildSectionCard(
                        icon: Icons.assignment_turned_in_outlined,
                        title: l10n.consentSection,
                        content: _buildConsentSection(l10n),
                      ),
                      _buildSectionCard(
                        icon: Icons.campaign_outlined,
                        title: l10n.referralSection,
                        content: _buildReferralSection(l10n),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 4),
                        _buildErrorBanner(),
                      ],
                      const SizedBox(height: 8),
                      GradientButton(
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
                      ),
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

  // ── Section card ──────────────────────────────────────────────────────────

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

  // ── Player section ────────────────────────────────────────────────────────

  Widget _buildPlayerSection(AppLocalizations l10n) {
    return Column(
      children: [
        _twoCol(
          _field(
            controller: _firstNameCtrl,
            label: l10n.playerFirstName,
            required: true,
            validator: _required(l10n),
          ),
          _field(
            controller: _lastNameCtrl,
            label: l10n.playerLastName,
            required: true,
            validator: _required(l10n),
          ),
        ),
        const SizedBox(height: 14),
        _field(
          controller: _middleNameCtrl,
          label: l10n.playerMiddleName,
          required: true,
          validator: _required(l10n),
        ),
        const SizedBox(height: 14),
        _buildDobField(l10n),
        const SizedBox(height: 14),
        _buildGenderSelector(l10n),
        const SizedBox(height: 14),
        _twoCol(
          _field(
            controller: _schoolCtrl,
            label: l10n.playerSchool,
            required: false,
          ),
          _field(
            controller: _clubCtrl,
            label: l10n.playerClub,
            required: false,
          ),
        ),
      ],
    );
  }

  Widget _buildDobField(AppLocalizations l10n) {
    final age = _dateOfBirth != null ? _calculateAge(_dateOfBirth!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _dobCtrl,
          readOnly: true,
          onTap: _pickDob,
          decoration: InputDecoration(
            labelText: '${l10n.playerDob} *',
            hintText: 'DD/MM/YYYY',
            suffixIcon: const Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: SlaColors.textSecondary,
            ),
          ),
          validator: (_) {
            if (_dateOfBirth == null) return l10n.validationDobRequired;
            if (_dateOfBirth!.isAfter(DateTime.now())) {
              return l10n.validationDobFuture;
            }
            return null;
          },
        ),
        if (age != null && age >= 0)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              '${l10n.playerAgeLabel}: $age ${l10n.yearsUnit}',
              style: const TextStyle(
                fontSize: 12,
                color: SlaColors.primaryPurple,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGenderSelector(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${l10n.playerGender} *',
          style: const TextStyle(
            fontSize: 13,
            color: SlaColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
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
    final selected = _gender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _gender = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? SlaColors.primaryPurple : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  selected ? SlaColors.primaryPurple : SlaColors.inputBorder,
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

  // ── Guardian section ──────────────────────────────────────────────────────

  Widget _buildGuardianSection(AppLocalizations l10n) {
    return Column(
      children: [
        _twoCol(
          _field(
            controller: _fatherPhoneCtrl,
            label: l10n.fatherPhone,
            required: true,
            hint: '01X XXXX XXXX',
            keyboardType: TextInputType.phone,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l10n.validationRequired;
              if (!_isValidEgyptianPhone(v.trim())) {
                return l10n.validationMobileFormat;
              }
              return null;
            },
          ),
          _field(
            controller: _motherPhoneCtrl,
            label: l10n.motherPhone,
            required: true,
            hint: '01X XXXX XXXX',
            keyboardType: TextInputType.phone,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l10n.validationRequired;
              if (!_isValidEgyptianPhone(v.trim())) {
                return l10n.validationMobileFormat;
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 14),
        _field(
          controller: _emergencyPhoneCtrl,
          label: l10n.emergencyPhone,
          required: true,
          hint: '01X XXXX XXXX',
          keyboardType: TextInputType.phone,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return l10n.validationRequired;
            if (!_isValidEgyptianPhone(v.trim())) {
              return l10n.validationMobileFormat;
            }
            final d = v.trim().replaceAll(RegExp(r'[\s\-]'), '');
            final fd =
                _fatherPhoneCtrl.text.trim().replaceAll(RegExp(r'[\s\-]'), '');
            final md =
                _motherPhoneCtrl.text.trim().replaceAll(RegExp(r'[\s\-]'), '');
            if (d == fd || d == md) {
              return l10n.validationEmergencyPhoneSameAsParent;
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        _field(
          controller: _fatherOccupationCtrl,
          label: l10n.fatherOccupation,
          required: false,
        ),
        const SizedBox(height: 14),
        _field(
          controller: _motherOccupationCtrl,
          label: l10n.motherOccupation,
          required: false,
        ),
        const SizedBox(height: 14),
        _field(
          controller: _emailCtrl,
          label: l10n.guardianEmail,
          required: false,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return null;
            if (!RegExp(r'^[\w\.\+\-]+@[\w\-]+\.[\w\.]{2,}$')
                .hasMatch(v.trim())) {
              return l10n.validationEmailFormat;
            }
            return null;
          },
        ),
      ],
    );
  }

  // ── Consent section ───────────────────────────────────────────────────────

  Widget _buildConsentSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _policyItem(
          icon: Icons.payments_outlined,
          title: l10n.consentPaymentTitle,
          body: l10n.consentPaymentText,
        ),
        const SizedBox(height: 8),
        _policyItem(
          icon: Icons.money_off_outlined,
          title: l10n.consentRefundTitle,
          body: l10n.consentRefundText,
        ),
        const SizedBox(height: 8),
        _policyItem(
          icon: Icons.local_hospital_outlined,
          title: l10n.consentMedicalTitle,
          body: l10n.consentMedicalText,
        ),
        const SizedBox(height: 8),
        _policyItem(
          icon: Icons.photo_camera_outlined,
          title: l10n.consentPhotosTitle,
          body: l10n.consentPhotosText,
        ),
        const SizedBox(height: 14),
        const Divider(height: 1),
        const SizedBox(height: 10),
        _buildConsentCheckbox(l10n),
      ],
    );
  }

  Widget _policyItem({
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SlaColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: SlaColors.inputBorder.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: SlaColors.primaryPurple),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: SlaColors.darkNavy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              fontSize: 12,
              color: SlaColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentCheckbox(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (v) => setState(() {
              _agreedToTerms = v!;
              if (v) _showConsentError = false;
            }),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() {
              _agreedToTerms = !_agreedToTerms;
              if (_agreedToTerms) _showConsentError = false;
            }),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  l10n.consentAgree,
                  style: const TextStyle(
                    fontSize: 13,
                    color: SlaColors.darkNavy,
                    height: 1.4,
                  ),
                ),
                if (_showConsentError) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.validationConsentRequired,
                    style: const TextStyle(
                      color: SlaColors.redOrange,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Referral section ──────────────────────────────────────────────────────

  Widget _buildReferralSection(AppLocalizations l10n) {
    final options = [
      (id: 'friends', label: l10n.referralFriends, icon: Icons.people_outline),
      (id: 'facebook', label: l10n.referralFacebook, icon: Icons.facebook),
      (
        id: 'instagram',
        label: l10n.referralInstagram,
        icon: Icons.camera_alt_outlined,
      ),
      (
        id: 'brochures',
        label: l10n.referralBrochures,
        icon: Icons.menu_book_outlined,
      ),
      (
        id: 'other',
        label: l10n.referralOther,
        icon: Icons.more_horiz_rounded,
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final selected = _referralSources.contains(opt.id);
        return FilterChip(
          avatar: Icon(
            opt.icon,
            size: 16,
            color: selected ? SlaColors.primaryPurple : SlaColors.textSecondary,
          ),
          label: Text(opt.label),
          selected: selected,
          onSelected: (v) => setState(() {
            if (v) {
              _referralSources.add(opt.id);
            } else {
              _referralSources.remove(opt.id);
            }
          }),
          selectedColor: SlaColors.primaryPurple.withValues(alpha: 0.12),
          checkmarkColor: SlaColors.primaryPurple,
          labelStyle: TextStyle(
            fontSize: 13,
            color: selected ? SlaColors.primaryPurple : SlaColors.darkNavy,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
          side: BorderSide(
            color: selected ? SlaColors.primaryPurple : SlaColors.inputBorder,
          ),
          backgroundColor: Colors.white,
        );
      }).toList(),
    );
  }

  // ── Error banner ──────────────────────────────────────────────────────────

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EE),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: SlaColors.redOrange.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: SlaColors.redOrange, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style:
                  const TextStyle(color: SlaColors.redOrange, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ── Utility ───────────────────────────────────────────────────────────────

  Widget _twoCol(Widget left, Widget right) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          const SizedBox(width: 12),
          Expanded(child: right),
        ],
      );

  String? Function(String?) _required(AppLocalizations l10n) =>
      (v) => (v == null || v.trim().isEmpty) ? l10n.validationRequired : null;

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
}
