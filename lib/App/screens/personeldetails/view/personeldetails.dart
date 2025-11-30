import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projecy/App/core/utils/personel_validators.dart';
import 'package:projecy/App/screens/base_screen/view/base_screen.dart';
import 'package:projecy/App/screens/personeldetails/bloc/personeldetails_bloc.dart';

class PersonnelDetails extends StatelessWidget {
  const PersonnelDetails({super.key}); 
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      padding: EdgeInsets.zero,
      body: BlocBuilder<PersonneldetailsBloc, PersonneldetailsState>(
        builder: (context, state) {
          return Stack(
            children: [
              _buildHeaderBackground(context),
              _buildContentCard(context, state),
              _buildHeaderContent(context),
            ],
          );
        },
      ),
    );
  }
  Widget _buildHeaderBackground(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25, 
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/Frame 18341.png')),
        ),
      ),
    );
  }
  Widget _buildHeaderContent(BuildContext context) {    
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.apps, size: 28, color: Colors.black),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 28, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Personnel Details',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildContentCard(BuildContext context, PersonneldetailsState state) { 
    final bloc = context.read<PersonneldetailsBloc>();
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.25,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 252, 250, 250),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(25, 30, 25, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Full name'),
                    _buildTextField(
                      context, 'Please type', TextInputType.name,
                      (value) => bloc.add(FullNameChanged(value)),
                      initialValue: state.fullName,
                    ),
                    const SizedBox(height: 25),
                    _buildLabel('Address'),
                    _buildAddressField(
                      context, 'Please type',
                      (value) => bloc.add(AddressChanged(value)),
                      initialValue: state.address,
                    ),
                    const SizedBox(height: 25),
                    _buildLabel('Suburb'),
                    _buildTextField(
                      context, 'Please type', TextInputType.text,
                      (value) => bloc.add(SuburbChanged(value)),
                      initialValue: state.suburb,
                    ),
                    const SizedBox(height: 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('State'),
                              _buildTextField(
                                context, 'Please type', TextInputType.text,
                                (value) => bloc.add(StateCodeChanged(value)),
                                initialValue: state.stateCode,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Post code'),
                              _buildTextField(
                                context, 'Please type', TextInputType.number,
                                (value) => bloc.add(PostCodeChanged(value)),
                                initialValue: state.postCode,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    _buildLabel('Contact number'),
                    _buildTextField(
                      context,
                      'Please type',
                      TextInputType.phone,
                      (value) => bloc.add(ContactNumberChanged(value)), 
                      initialValue: state.contactNumber,
                    ),
                    const SizedBox(height: 25),
                    _buildLabel('Role'),
                    const SizedBox(height: 8),
                    _buildRoleCheckbox(context, state, PersonnelRole.colonyOwner, 'Colony Owner'),
                    const SizedBox(height: 12),
                    _buildRoleCheckbox(context, state, PersonnelRole.chemApplicator, 'Chem Applicator'),
                    const SizedBox(height: 12),
                    _buildRoleCheckbox(context, state, PersonnelRole.landOwner, 'Land Owner'),
                    const SizedBox(height: 25),
                    _buildLabel('Additional Notes'),
                    _buildNotesField(
                      context,
                      state,
                      (value) => bloc.add(NotesChanged(value)),
                      initialValue: state.additionalNotes,
                    ),
                    const SizedBox(height: 30),
                    _buildStatusToggle(context, state),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 25),
              child: _buildActionButtons(context, state),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildAddressField(
    BuildContext context,
    String hint,
    ValueChanged<String> onChanged, {
    String? initialValue,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, color: Colors.grey.shade400, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              initialValue: initialValue,
              onChanged: onChanged,
              keyboardType: TextInputType.streetAddress,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.my_location, color: Color(0xFFFDD835), size: 22), 
            onPressed: () {
            },
          ),
        ],
      ),
    );
  }
  Widget _buildTextField(
    BuildContext context,
    String hint,
    TextInputType keyboardType,
    ValueChanged<String> onChanged, {
    String? initialValue,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
  Widget _buildNotesField(
    BuildContext context,
    PersonneldetailsState state,
    ValueChanged<String> onChanged, {
    String? initialValue,
  }) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      padding: const EdgeInsets.all(15),
      child: Stack(
        children: [
          TextFormField(
            initialValue: initialValue,
            onChanged: onChanged,
            maxLines: null,
            minLines: 6,
            maxLength: 500,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'Please type',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              counterText: '',
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Text(
              '${state.additionalNotes.length}/500',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
  Widget _buildRoleCheckbox(
    BuildContext context,
    PersonneldetailsState state,
    PersonnelRole role,
    String title,
  ) {
    final isSelected = state.selectedRoles.containsKey(role.toString());
    return GestureDetector(
      onTap: () {
        context.read<PersonneldetailsBloc>().add(RoleChanged(role));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey.shade400,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildStatusToggle(BuildContext context, PersonneldetailsState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Status',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Transform.scale(
            scale: 1.1,
            child: Switch.adaptive(
              value: state.isActive,
              onChanged: (bool newValue) {
                context.read<PersonneldetailsBloc>().add(StatusToggled());
              },
              activeColor: const Color(0xFF4CAF50),
              activeTrackColor: const Color(0xFF81C784),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildActionButtons(BuildContext context, PersonneldetailsState state) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: state.isSaving ? null : () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: state.isSaving ? null : () {
                _handleSaveForm(context, state);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFDD835),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: state.isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSaveForm(BuildContext context, PersonneldetailsState state) {
    final errors = PersonnelValidators.validateForm(
      fullName: state.fullName,
      address: state.address,
      suburb: state.suburb,
      stateCode: state.stateCode,
      postCode: state.postCode,
      contactNumber: state.contactNumber,
      // selectedRoles: state.selectedRoles,
      additionalNotes: state.additionalNotes,
    );

    if (errors.isNotEmpty) {
      _showValidationError(context, errors);
    } else {
      // Form is valid, proceed with saving
      context.read<PersonneldetailsBloc>().add(FormSaved());
      Navigator.of(context).pushNamed('/personellist');
    }
  }

  void _showValidationError(BuildContext context, Map<String, String> errors) {
    String errorMessage = 'Please fix the following errors:\n\n';
    errors.forEach((field, error) {
      errorMessage += '• $error\n';
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Validation Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}