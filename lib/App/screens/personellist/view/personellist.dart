import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:projecy/App/core/models/personel_list_model.dart';
import 'package:projecy/App/screens/personellist/bloc/personellist_bloc.dart';
import 'package:projecy/App/screens/personellist/bloc/personellist_event.dart';
import 'package:projecy/App/screens/personellist/bloc/personellist_state.dart';

class PersonnelListScreen extends StatelessWidget {
  const PersonnelListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonnelListBloc()..add(FetchPersonnelList()),
      child: const PersonnelListView(),
    );
  }
}

class PersonnelListView extends StatelessWidget {
  const PersonnelListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Header background
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Frame 18341.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Column(
                    children: const [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.grid_view, color: Colors.black),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Personnel Details List',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Search bar
                SizedBox(height: 40,),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              context
                                  .read<PersonnelListBloc>()
                                  .add(SearchQueryChanged(value));
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search...',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFDD835),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            "GO",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // Personnel list
                Expanded(
                  child: BlocBuilder<PersonnelListBloc, PersonnelListState>(
                    builder: (context, state) {
                      if (state.status == ListStatus.loading) {
                        return const Center(child: CircularProgressIndicator(color: Colors.amber,));
                      } else if (state.status == ListStatus.failure) {
                        return Center(
                            child: Text('Error: ${state.errorMessage}'));
                      } else if (state.status == ListStatus.success) {
                        if (state.personnelList.isEmpty) {
                          return const Center(
                              child: Text('No personnel found'));
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 10, bottom: 80),
                          itemCount: state.personnelList.length,
                          itemBuilder: (context, index) {
                            return _buildPersonnelCard(state.personnelList[index]);
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: () {
          Navigator.of(context).popAndPushNamed('/personeldetails');
        },
        backgroundColor: const Color(0xFFFDD835),
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
    );
  }

  Widget _buildPersonnelCard(PersonnelData item) {
    final status = item.status == "1" ? PersonnelStatus.active : PersonnelStatus.inactive;
    final role = item.roleDetails.isNotEmpty ? item.roleDetails[0].role : "Unknown";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDD835),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.groups, color: Colors.black54),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.firstName ?? "",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: status == PersonnelStatus.active
                                    ? Colors.green
                                    : Colors.red),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle,
                                  size: 8,
                                  color: status == PersonnelStatus.active
                                      ? Colors.green
                                      : Colors.red),
                              const SizedBox(width: 4),
                              Text(
                                status == PersonnelStatus.active
                                    ? "Active"
                                    : "Inactive",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: status == PersonnelStatus.active
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Phone + Role
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(item.contactNumber ?? "",
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(width: 10),
                        const Icon(Icons.person, size: 16, color: Colors.grey),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            role,
                            style: const TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(thickness: 0.5),
          const SizedBox(height: 5),
          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined,
                  color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.address ?? "",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
