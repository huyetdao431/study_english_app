import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/common/enum/load_status.dart';
import 'package:study_english_app/screens/library_screen/library_screen.dart';
import 'package:study_english_app/screens/search_screen/cubit/search_cubit.dart';

import '../../core/color.dart';
import '../../core/text.dart';
import '../../services/api.dart';
import '../course_detail/course_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  static const String route = 'SearchScreen';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(context.read<Api>()),
      child: Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _allSuggestions = [
    'Food',
    'Covid - 19',
    'Office communication',
    'City',
    'Business',
    'Football/Soccer',
    'Bank',
    'Friend',
    'Color',
    'Internet & Computer',
    'Children',
    'Lunar New Year',
    'Sport',
    'Environment',
    'Hometown',
    'Human personality',
    'Game',
    'Animals',
    'Marriage',
    'Work',
    'Start-up',
    'Time',
    'Family',
    'Household items',
    'Halloween',
    'Weather',
    'Months',
    'Tourism',
    'Mid-Autumn Festival',
    'Seasons',
    'Air',
    'Accommodation',
    'Science',
    'Culture',
    'Movie',
    'Restaurant',
    'Art',
    'Advertising',
    'Health & Fitness',
    'Job',
    'Government & Politics',
    'Noel',
    'Technology',
    'Crime',
    'Education',
    'Music',
  ];

  List<String> _filteredSuggestions = [];

  void _onSearchChanged(String value) {
    setState(() {
      _filteredSuggestions =
          _allSuggestions
              .where((s) => s.toLowerCase().contains(value.toLowerCase()))
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>().getCourseName();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        var cubit = context.read<SearchCubit>();
        return Scaffold(
          appBar: AppBar(title: const Text('Tìm kiếm từ vựng')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Nhập từ khóa...',
                    border: const OutlineInputBorder(),
                    prefixIcon: IconButton(
                      onPressed: () async {
                        await cubit.getSearchResult(_searchController.text);
                        _filteredSuggestions.clear();
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ),
                  onChanged: _onSearchChanged,
                  onSubmitted: (value) async {
                    await cubit.getSearchResult(value);
                    _filteredSuggestions.clear();
                  },
                ),
                Expanded(
                  child:
                      cubit.state.loadStatus == LoadStatus.Loading
                          ? Center(child: CircularProgressIndicator())
                          : Column(
                            children: [
                              const SizedBox(height: 16),
                              if (_filteredSuggestions.isNotEmpty &&
                                  _searchController.text.isNotEmpty)
                                Expanded(
                                  child: ListView.builder(
                                    itemCount:
                                        _filteredSuggestions.length > 5
                                            ? 5
                                            : _filteredSuggestions.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          _filteredSuggestions[index]
                                              .toLowerCase(),
                                        ),
                                        onTap: () {
                                          setState(() async {
                                            _searchController.text =
                                                _filteredSuggestions[index];
                                            _filteredSuggestions.clear();

                                            await cubit.getSearchResult(
                                              _searchController.text,
                                            );
                                          });
                                        },
                                      );
                                    },
                                  ),
                                )
                              else if (_searchController.text.isNotEmpty)
                                const SizedBox(),
                              cubit.state.searchResults.isEmpty
                                  ? SizedBox()
                                  : Expanded(
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Kết quả tìm kiếm.',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount:
                                                cubit.state.searchResults.length,
                                            itemBuilder: (context, index) {
                                              return CourseCard(
                                                course:
                                                    cubit.state.searchResults[index],
                                                popUpMenuItem: SizedBox(),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ],
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void resetData() {
    setState(() {
      _filteredSuggestions.clear();
    });
  }
}

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final Widget popUpMenuItem;

  const CourseCard({
    super.key,
    required this.course,
    required this.popUpMenuItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              CourseDetailScreen.route,
              arguments: {'courseId': course['course'].id},
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightGray, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    course['course'].name,
                    style: AppTextStyles.title,
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${course['course'].words.length} thuật ngữ',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          course['avt'].isNotEmpty
                              ? CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage(course['avt']),
                              )
                              : Container(
                                alignment: Alignment.center,
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.darkWhite,
                                ),
                                child: Text(
                                  course['username'][0].toUpperCase(),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          SizedBox(width: 8),
                          Text(
                            course['username'],
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    popUpMenuItem,
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
