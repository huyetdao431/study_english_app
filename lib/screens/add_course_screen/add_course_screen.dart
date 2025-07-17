import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/screens/add_course_screen/cubit/add_edit_course_cubit.dart';
import 'package:study_english_app/widgets/others/show_dialog.dart';

import '../../common/enum/load_status.dart';
import '../../core/color.dart';
import '../../models/word.dart';
import '../../services/api.dart';

class AddCourseScreen extends StatefulWidget {
  static const String route = "AddCourseScreen";
  final bool isAddCourse;
  final String courseId;

  const AddCourseScreen({
    super.key,
    required this.isAddCourse,
    required this.courseId,
  });

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEditCourseCubit(context.read<Api>()),
      child: Page(courseId: widget.courseId, isAddCourse: widget.isAddCourse),
    );
  }
}

class Page extends StatefulWidget {
  final String courseId;
  final bool isAddCourse;

  const Page({super.key, required this.courseId, required this.isAddCourse});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  final List<_TermDefinitionCard> _cards = [];

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _courseNameController = TextEditingController();
  final GlobalKey<FormState> _courseFormKey = GlobalKey<FormState>();

  void _addCard() {
    setState(() {
      _cards.add(_TermDefinitionCard());
    });
  }

  void _removeCard(int index) {
    setState(() {
      _cards.removeAt(index);
    });
  }

  Future<void> _validateAndSubmit() async {
    if (_cards.length < 3) {
      showMyDialog(
        context,
        'Thông báo',
        'Vui lòng thêm ít nhất ba thuật ngữ và định nghĩa trước khi tạo khóa học.',
      );
      return;
    }

    final isFormValid = _courseFormKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      // Scroll tới vị trí đầu
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    final data = _cards
        .map((card) => {
      "word": card.termController.text.trim(),
      "meaning": card.definitionController.text.trim(),
    })
        .toList();

    final courseName = _courseNameController.text.trim();
    final List<Word> words = data.map((item) => Word.fromMap(item)).toList();

    widget.isAddCourse
        ? await context.read<AddEditCourseCubit>().createCourse(courseName, words)
        : await context.read<AddEditCourseCubit>().updateCourse(widget.courseId, courseName, words);
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isAddCourse) {
      context.read<AddEditCourseCubit>().loadData(widget.courseId);
    } else {
      _addCard();
    }
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _scrollController.dispose();
    for (var card in _cards) {
      card.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddEditCourseCubit, AddEditCourseState>(
      listenWhen: (prev, curr) =>
      prev.courseName != curr.courseName || prev.words != curr.words,
      listener: (context, state) {
        context.read<AddEditCourseCubit>().state.words.forEach((word) {
          _cards.add(
            _TermDefinitionCard()
              ..termController.text = word.word
              ..definitionController.text = word.meaning,
          );
        });
        _courseNameController.text =
            context.read<AddEditCourseCubit>().state.courseName;
      },
      builder: (context, state) {
        var cubit = context.read<AddEditCourseCubit>();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tạo khóa học'),
            actions: [
              TextButton(
                onPressed: () async {
                  await _validateAndSubmit();
                  if (!context.mounted) return;
                  if (cubit.state.loadStatus == LoadStatus.Success) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Thông báo'),
                        content: Text(widget.isAddCourse
                            ? 'Tạo khóa học thành công!'
                            : 'Cập nhật khóa học thành công!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Đóng'),
                          ),
                        ],
                      ),
                    );
                  } else if (cubit.state.loadStatus == LoadStatus.Error) {
                    showMyDialog(
                      context,
                      'Lỗi',
                      'Đã xảy ra lỗi khi tạo khóa học. Vui lòng thử lại sau.',
                    );
                  }
                },
                child: Text(
                  widget.courseId.isEmpty ? "Tạo" : 'Lưu thay đổi',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          body: cubit.state.loadStatus == LoadStatus.Loading
              ? const Center(child: CircularProgressIndicator())
              : Form(
            key: _courseFormKey,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _cards.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      controller: _courseNameController,
                      decoration: const InputDecoration(
                        labelText: "Tên khóa học",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty
                          ? "Vui lòng nhập tên khóa học"
                          : null,
                    ),
                  );
                }
                return _cards[index - 1].buildCard(
                  onRemove: () => _removeCard(index - 1),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _addCard,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}


class _TermDefinitionCard {
  final TextEditingController termController = TextEditingController();
  final TextEditingController definitionController = TextEditingController();

  void dispose() {
    termController.dispose();
    definitionController.dispose();
  }

  Widget buildCard({required VoidCallback onRemove}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Thuật ngữ & Định nghĩa",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onRemove,
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: termController,
              decoration: const InputDecoration(
                labelText: 'Thuật ngữ',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Vui lòng nhập thuật ngữ'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: definitionController,
              decoration: const InputDecoration(
                labelText: 'Định nghĩa',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Vui lòng nhập định nghĩa'
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

