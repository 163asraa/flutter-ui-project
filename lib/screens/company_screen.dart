// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/const/color.dart';
// import 'package:supa_electronics/const/const.dart';
// import '../models/company.dart';
// import '../services/company_service.dart';
// import '../providers/auth_provider.dart';
// import '../screens/product_list_by_company_screen.dart';
// import 'dart:math' as math;

// class CompanyScreen extends StatefulWidget {
//   @override
//   _CompanyScreenState createState() => _CompanyScreenState();
// }

// class _CompanyScreenState extends State<CompanyScreen>
//     with SingleTickerProviderStateMixin {
//   late Future<List<Company>> _companiesFuture;
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   final _scrollController = ScrollController();
//   bool _isGridView = true;
//   String _selectedCategory = 'الكل';

//  final List<String> _baseCategories = ['غذائية', 'ألبسة', 'إلكترونيات', 'دوائية'];
// final List<String> _categories = ['الكل', ..._baseCategories, 'أخرى'];


//   final List<Color> _companyColors = [
//     AppColors.secondary,
//     AppColors.secondary,
//     AppColors.secondary,
//     AppColors.secondary,
//     AppColors.secondary,
//     AppColors.secondary,
//     AppColors.secondary,
//     AppColors.secondary,
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//     _controller.forward();
//     _fetchCompanies();
//   }

//   void _fetchCompanies() {
//     final token = Provider.of<AuthProvider>(context, listen: false).token;
//     if (token == null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('يرجى تسجيل الدخول لعرض الشركات'),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             margin: EdgeInsets.all(10),
//           ),
//         );
//         Navigator.pushReplacementNamed(context, '/login');
//       });
//       return;
//     }
//     setState(() {
//       _companiesFuture = CompanyService().fetchCompanies(token);
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Color _getCompanyColor(int index) {
//     return _companyColors[index % _companyColors.length];
//   }

//   Widget _buildCompanyCard(Company company, int index, ThemeData theme) {
//     final color = _getCompanyColor(index);
//     final random = math.Random(index);
//     final rotationAngle = (random.nextDouble() - 0.5) * 0.1;

//     if (_isGridView) {
//       return Card(
//         elevation: 8,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: InkWell(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ProductListByCompanyScreen(
//                 companyId: company.id,
//                 companyName: company.name,
//               ),
//             ),
//           ),
//           borderRadius: BorderRadius.circular(20),
//     child: Container(
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(20),
//     gradient: LinearGradient(
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//       colors: [
//         color,
//         color.withOpacity(0.7),
//       ],
//     ),
//   ),
//   child: Stack(
//     children: [
//       Positioned(
//         right: -50,
//         bottom: -50,
//         child: Transform.rotate(
//           angle: rotationAngle,
//           child: Icon(
//             Icons.business,
//             size: 150,
//             color: Colors.white.withOpacity(0.2),
//           ),
//         ),
//       ),
//       Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.white,
//               child: Text(
//                 company.name.isNotEmpty ? company.name[0] : 'ش',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//             ),
//             SizedBox(height: 12),
//             Text(
//               company.name,
//               style: theme.textTheme.titleMedium?.copyWith(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             SizedBox(height: 6),
//             Text(
//               company.category,
//               style: theme.textTheme.bodySmall?.copyWith(
//                 color: Colors.white.withOpacity(0.85),
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     ],
//   ),
// ),

//         ),
//       );
//     } else {
//       return Card(
//         elevation: 4,
//         margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: InkWell(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ProductListByCompanyScreen(
//                 companyId: company.id,
//                 companyName: company.name,
//               ),
//             ),
//           ),
//           borderRadius: BorderRadius.circular(15),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               gradient: LinearGradient(
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//                 colors: [
//                   color.withOpacity(0.1),
//                   Colors.white,
//                 ],
//               ),
//             ),
//             child: ListTile(
//               contentPadding: EdgeInsets.all(16),
//               leading: CircleAvatar(
//                 radius: 25,
//                 backgroundColor: color,
//                 child: Text(
//                   company.name.isNotEmpty ? company.name[0] : 'C',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               title: Text(
//                 company.name,
//                 style: theme.textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: theme.colorScheme.onSurface,
//                 ),
//               ),
//               trailing: Icon(Icons.arrow_forward_ios, color: color),
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       body: Column(
//         children: [
//           ClipPath(
//             clipper: TopWaveClipper(),
//             child: Container(
//               height: 130,
//               width: double.infinity,
//               padding: EdgeInsets.only(top: 40, right: 16, left: 16, bottom: 20),
//               color: AppColors.secondary,
//               child: SafeArea(
//                 child: Row(
//                   textDirection: TextDirection.rtl,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         _isGridView ? Icons.view_list : Icons.grid_view,
//                         color: Colors.white,
//                       ),
//                       onPressed: () => setState(() => _isGridView = !_isGridView),
//                       tooltip: _isGridView ? 'عرض القائمة' : 'عرض الشبكة',
//                     ),
//                     Text(
//                       'الشركات',
//                       style: theme.textTheme.titleLarge?.copyWith(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 24,
//                       ),
//                     ),
//                     SizedBox(width: 48),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Row(
//               children: _categories.map((category) {
//                 final isSelected = _selectedCategory == category;
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4),
//                   child: ChoiceChip(
//                     label: Text(category),
//                     selected: isSelected,
//                     onSelected: (_) {
//                       setState(() {
//                         _selectedCategory = category;
//                       });
//                     },
//                     selectedColor: AppColors.secondary,
//                     backgroundColor: Colors.grey[200],
//                     labelStyle: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Company>>(
//               future: _companiesFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('خطأ: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('لا توجد شركات'));
//                 }

//                 final companies = snapshot.data!;
//                 final filteredCompanies = _selectedCategory == 'الكل'
//                     ? companies
//                     : companies.where((c) => c.category == _selectedCategory).toList();

//                 return _isGridView
//                     ? GridView.builder(
//                         controller: _scrollController,
//                         padding: EdgeInsets.all(16),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           childAspectRatio: 0.85,
//                           crossAxisSpacing: 16,
//                           mainAxisSpacing: 16,
//                         ),
//                         itemCount: filteredCompanies.length,
//                         itemBuilder: (context, index) =>
//                             _buildCompanyCard(filteredCompanies[index], index, theme),
//                       )
//                     : ListView.builder(
//                         controller: _scrollController,
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                         itemCount: filteredCompanies.length,
//                         itemBuilder: (context, index) =>
//                             _buildCompanyCard(filteredCompanies[index], index, theme),
//                       );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supa_electronics/const/color.dart';
import 'package:supa_electronics/const/const.dart';
import '../models/company.dart';
import '../services/company_service.dart';
import '../providers/auth_provider.dart';
import '../screens/product_list_by_company_screen.dart';
import 'dart:math' as math;

class CompanyScreen extends StatefulWidget {
  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Company>> _companiesFuture;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final _scrollController = ScrollController();
  bool _isGridView = true;
  String _selectedCategory = 'الكل';

  List<String> _baseCategories = ['غذائية', 'ألبسة', 'إلكترونيات', 'دوائية'];
  late List<String> _categories;

  final List<Color> _companyColors = List.generate(8, (_) => AppColors.secondary);

  @override
  void initState() {
    super.initState();
    _categories = ['الكل', ..._baseCategories, 'أخرى'];
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    _fetchCompanies();
  }

  void _fetchCompanies() {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يرجى تسجيل الدخول لعرض الشركات'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(10),
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      });
      return;
    }
    setState(() {
      _companiesFuture = CompanyService().fetchCompanies(token);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Color _getCompanyColor(int index) {
    return _companyColors[index % _companyColors.length];
  }

  Widget _buildCompanyCard(Company company, int index, ThemeData theme) {
    final color = _getCompanyColor(index);
    final random = math.Random(index);
    final rotationAngle = (random.nextDouble() - 0.5) * 0.1;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductListByCompanyScreen(
              companyId: company.id,
              companyName: company.name,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.7)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                bottom: -50,
                child: Transform.rotate(
                  angle: rotationAngle,
                  child: Icon(
                    Icons.business,
                    size: 150,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                        company.name.isNotEmpty ? company.name[0] : 'C',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      company.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      company.category,
                      style: TextStyle(color: Colors.white70),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(34),
              bottomRight: Radius.circular(34),
            ),
            child: Image.asset(
              "assets/image2.jpg",
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
          ),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: const Color.fromARGB(137, 18, 62, 68),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0, right: 30, left: 30),
            child: Container(
               width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
              color: const Color.fromARGB(136, 255, 255, 255),
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      ),
            ),
          ),
                 Padding(
          padding: const EdgeInsets.only(top: 34.0, right: 30, left: 30),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromARGB(0, 255, 255, 255),
              borderRadius: BorderRadius.all(
                Radius.circular(32),
              ),
            ),
            child: Center(child: Text("استعرض الشركات",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 255, 255, 255)),)),
          ),
        ),
          
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
      _buildHeader(),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppColors.secondary,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Company>>(
              future: _companiesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا توجد شركات'));
                }

                final companies = snapshot.data!;
                final filteredCompanies = _selectedCategory == 'الكل'
                    ? companies
                    : _selectedCategory == 'أخرى'
                        ? companies.where((c) => !_baseCategories.contains(c.category)).toList()
                        : companies.where((c) => c.category == _selectedCategory).toList();

                return _isGridView
                    ? GridView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredCompanies.length,
                        itemBuilder: (context, index) =>
                            _buildCompanyCard(filteredCompanies[index], index, theme),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        itemCount: filteredCompanies.length,
                        itemBuilder: (context, index) =>
                            _buildCompanyCard(filteredCompanies[index], index, theme),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
