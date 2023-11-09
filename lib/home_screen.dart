

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'boxes/boxes.dart';
import 'models/notes_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<Color> colors = [Colors.purple , Colors.black38, Colors.green, Colors.blue , Colors.red] ;

  Random random = Random(5);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Database'),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context,box ,_){
          var data = box.values.toList();


            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ListView.builder(
                  itemCount: box.length,
                  reverse: true,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        color: colors[random.nextInt(4)],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              Row(
                                children: [
                                  Text(data[index].title.toString() ,
                                    style: const TextStyle(fontSize: 20 , fontWeight: FontWeight.w500 , color: Colors.white),),
                                  const Spacer(),
                                  InkWell(
                                      onTap: (){
                                        delete(data[index]);
                                      },
                                      child: const Icon(Icons.delete , color: Colors.white,)),
                                  const SizedBox(width: 15,),
                                  InkWell(
                                      onTap: (){
                                        _editDialog(data[index], data[index].title.toString(), data[index].description.toString());
                                      },
                                      child: const Icon(Icons.edit, color: Colors.white,)) ,


                                ],
                              ),
                              Text(data[index].description.toString(),
                                style: const TextStyle(fontSize: 18 , fontWeight: FontWeight.w300, color: Colors.white),),
                            ],
                          ),
                        ),
                      ),
                    );

                  }
              ),
            );


        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          _showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void delete(NotesModel notesModel)async{
    await notesModel.delete() ;
    await notesModel.save();

  }


  Future<void> _editDialog(NotesModel notesModel, String title, String description)async{

    titleController.text = title ;
    descriptionController.text = description ;

    return showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: Text('Edit NOTES'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter title',
                        border: OutlineInputBorder()
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text('Cancel')),

              TextButton(onPressed: ()async{

                notesModel.title = titleController.text.toString();
                notesModel.description = descriptionController.text.toString();

                notesModel.save();
                descriptionController.clear() ;
                titleController.clear() ;


                // box.

                Navigator.pop(context);
              }, child: Text('Edit')),
            ],
          );
        }
    ) ;
  }

  Future<void> _showMyDialog()async{

    return showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: const Text('Add NOTES'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter title',
                        border: OutlineInputBorder()
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text('Cancel')),

              TextButton(onPressed: (){
                final data = NotesModel(title: titleController.text,
                    description: descriptionController.text) ;

                final box = Boxes.getData();
                box.add(data);


                // data.save() ;

                titleController.clear();
                descriptionController.clear();

                // box.

                Navigator.pop(context);
              }, child: const Text('Add')),
            ],
          );
        }
    ) ;
  }


}