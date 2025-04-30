import 'package:flutter/material.dart';

class AddNewCoursePage extends StatefulWidget {
  const AddNewCoursePage({Key? key}) : super(key: key);

  @override
  State<AddNewCoursePage> createState() => _AddNewCoursePageState();
}

class _AddNewCoursePageState extends State<AddNewCoursePage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _offerPercentageController = TextEditingController();
  String _selectedCategory = '';
  String _selectedLevel = 'Beginner';
  final List<String> _lessons = [];
  
  String _courseThumbnail = '';
  
 
  final List<String> _categories = ['Programming', 'Design', 'Business', 'Marketing', 'Other'];
  final List<String> _levels = ['Beginner', 'Intermediate', 'Advanced'];
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _offerPercentageController.dispose();
    super.dispose();
  }
  
  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (_currentStep < 3) {
          _currentStep += 1;
        }
      });
    }
  }
  
  void _goBack() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep -= 1;
      }
    });
  }
  
  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Course Title',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: 'Enter a descriptive title',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a course title';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        const Text(
          'Course Description',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            hintText: 'Describe what students will learn',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a course description';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        const Text(
          'Course Category',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategory.isEmpty ? null : _selectedCategory,
          decoration: const InputDecoration(
            hintText: 'Select category',
            border: OutlineInputBorder(),
          ),
          items: _categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value!;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a category';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        const Text(
          'Course Thumbnail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            // Dummy action for thumbnail selection
            setState(() {
              _courseThumbnail = 'dummy_thumbnail_url';
            });
          },
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: _courseThumbnail.isEmpty
                ? const Center(child: Text('Tap to upload thumbnail'))
                : const Center(child: Text('Thumbnail uploaded')),
          ),
        ),
      ],
    );
  }
  
  Widget _buildAdvancedInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Course Price (USD)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _priceController,
          decoration: const InputDecoration(
            hintText: 'Enter price (0 for free)',
            border: OutlineInputBorder(),
            prefixText: '\$ ',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a price';
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        const Text(
          'Discount Percentage (%)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _offerPercentageController,
          decoration: const InputDecoration(
            hintText: 'Enter discount (0 for no discount)',
            border: OutlineInputBorder(),
            suffixText: '%',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a discount percentage';
            }
            int? discount = int.tryParse(value);
            if (discount == null) {
              return 'Please enter a valid number';
            }
            if (discount < 0 || discount > 100) {
              return 'Discount must be between 0 and 100';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        const Text(
          'Course Level',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedLevel,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: _levels.map((level) {
            return DropdownMenuItem<String>(
              value: level,
              child: Text(level),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedLevel = value!;
            });
          },
        ),
      ],
    );
  }
  
  Widget _buildCurriculumStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Course Curriculum',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        const Text(
          'Add lessons to your course',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        
        // Display existing lessons
        if (_lessons.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No lessons added yet'),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _lessons.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Lesson ${index + 1}'),
                subtitle: Text(_lessons[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _lessons.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        
        const SizedBox(height: 16),
        
        ElevatedButton.icon(
          onPressed: () {
            _showAddLessonDialog();
          },
          icon: const Icon(Icons.add),
          label: const Text('Add New Lesson'),
        ),
      ],
    );
  }
  
  void _showAddLessonDialog() {
    final lessonTitleController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Lesson'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: lessonTitleController,
                decoration: const InputDecoration(
                  labelText: 'Lesson Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'You can add content to the lesson after creating the course.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (lessonTitleController.text.isNotEmpty) {
                  setState(() {
                    // Just add a dummy lesson ID
                    _lessons.add('Lesson ${lessonTitleController.text}');
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildPublishStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review and Publish',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _titleController.text.isEmpty ? 'Course Title' : _titleController.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Category: ${_selectedCategory.isEmpty ? 'Not selected' : _selectedCategory}'),
                Text('Level: $_selectedLevel'),
                Text('Price: \$${_priceController.text.isEmpty ? '0' : _priceController.text}'),
                Text('Discount: ${_offerPercentageController.text.isEmpty ? '0' : _offerPercentageController.text}%'),
                const SizedBox(height: 8),
                Text('${_lessons.length} lessons'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        CheckboxListTile(
          title: const Text('I agree to the terms and conditions'),
          value: true, // This would be a state variable in a real app
          onChanged: (value) {
            // Dummy action
          },
        ),
        
        const SizedBox(height: 16),
        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Course published successfully (dummy action)')),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('PUBLISH COURSE'),
          ),
        ),
      ],
    );
  }
  
  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('Basic Information'),
        content: _buildBasicInfoStep(),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Advanced Information'),
        content: _buildAdvancedInfoStep(),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Curriculum'),
        content: _buildCurriculumStep(),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: const Text('Publish'),
        content: _buildPublishStep(),
        isActive: _currentStep >= 3,
      ),
    ];
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Add New Course'),
    ),
    body: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: _currentStep == 0
                    ? _buildBasicInfoStep()
                    : _currentStep == 1
                        ? _buildAdvancedInfoStep()
                        : _currentStep == 2
                            ? _buildCurriculumStep()
                            : _buildPublishStep(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  ElevatedButton(
                    onPressed: _goBack,
                    child: const Text('Back'),
                  )
                else
                  const SizedBox.shrink(),
                ElevatedButton(
                  onPressed: _saveAndContinue,
                  child: Text(_currentStep == 3 ? 'Finish' : 'Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

}