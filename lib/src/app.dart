import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'canvas_widget.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'r/Place Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color selectedColor = Colors.green; // 默认颜色

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("r/Place Clone"),
      ),
      body: Column(
        children: [
          ColorPicker(
            onColorChanged: (color) {
              setState(() {
                selectedColor = color;
              });
            },
          ),
          Expanded(
            child: CanvasWidget(
              selectedColor: selectedColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ColorPicker extends StatefulWidget {
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({super.key, required this.onColorChanged});

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color? selectedColor; // 记录当前选中的颜色

  @override
  Widget build(BuildContext context) {
    // 使用 Colors.primaries 来获取一组预定义的颜色
    List<Color> colors =List.from( Colors.primaries);
    colors.add(Colors.black);
    colors.add(Colors.white);
    colors.add(Colors.transparent);

   
   return Row(  
  mainAxisAlignment: MainAxisAlignment.center,  
  children: colors.map((color) {  
    bool isSelected = (color == selectedColor); // 计算当前颜色是否为选中颜色  
    
    return GestureDetector(  
      onTap: () {  
        setState(() {  
          selectedColor = color; // 更新选中的颜色  
        });  
        widget.onColorChanged(color); // 回调选中的颜色  
      },  
      child: Column( // 使用Column来包含色块和文本  
        children: [  
          Container(  
            width: 40,  
            height: 40,  
            margin: const EdgeInsets.all(4.0), // 为颜色方块增加一些间距  
            decoration: BoxDecoration(  
              color: color, // 颜色设置在装饰中  
              border: isSelected  
                  ? Border.all(color: Colors.black, width: 2)  
                  : null, // 选中时添加边框  
              shape: BoxShape.rectangle,  
            ),  
          ),  
          // 添加文本说明  
          Text(  
            color.value.toString(), // 显示颜色的字符串表示  
            style: TextStyle(fontSize: 12), // 设置字体大小  
          ),  
        ],  
      ),  
    );  
  }).toList(),  
);  
  }
}

// class ColorPicker extends StatelessWidget {
//   final ValueChanged<Color> onColorChanged;

//   const ColorPicker({super.key, required this.onColorChanged});

//   @override
//   Widget build(BuildContext context) {
//     // 使用 Colors.primaries 来获取一组预定义的颜色
//     final List<Color> colors = Colors.primaries;

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: colors.map((color) {
//         return GestureDetector(
//           onTap: () => onColorChanged(color),
//           child: Container(
//             color: color,
//             width: 40,
//             height: 40,
//           ),
//         );
//       }).toList(),
//     );
//   }

// }
