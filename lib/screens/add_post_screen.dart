import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:MakeMyDay/models/ActionRequired.dart';
import 'package:MakeMyDay/models/prompt_result.dart';
import 'package:MakeMyDay/models/user.dart';
import 'package:MakeMyDay/providers/user_provider.dart';
import 'package:MakeMyDay/resources/GeminiService.dart';
import 'package:MakeMyDay/resources/firestore_methods.dart';
import 'package:MakeMyDay/utils/colors.dart';
import 'package:MakeMyDay/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  PromptResult _promptAnalized = PromptResult(diagnoseDescription: "", takeActionDescription: '', imageType: PromptImageType.notdetected);
  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext parentContext, User user) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);

                  setState(() {
                    _file = file;
                    isLoading = true;
                  });
                  final promptAnalized =
                      await GeminiService().getPromptFromImage(file, user);
                  setState(() {
                    _promptAnalized = promptAnalized;
                    isLoading = false;
                  });
           
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                    isLoading = true;
                  });
                  final promptAnalized =
                      await GeminiService().getPromptFromImage(file, user);
                  setState(() {
                    _promptAnalized = promptAnalized;
                    isLoading = false;
                  });
               
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loadin

    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
        _promptAnalized
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void postRequiredActionImage(String uid, String username, String description) async {
    setState(() {
      isLoading = true;
    });
    try {
      
      String actionId = const Uuid().v1(); 
      final actionRequired = ActionRequiredPost(selectedDate: DateTime.now(), description: description, uid: uid, username: username, datePublished: DateTime.now(), actionRequiredId: actionId);
      String res = await FireStoreMethods().uploadActionRequiderPost(actionRequired);
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Done!',
          );
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser!;
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
              ),
              onPressed: () => _selectImage(context, user),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back), color: black,
                onPressed: clearImage,
              ),
              title: const Text(
                'Post to', 
                style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () => postImage(
                    user.uid,
                    user.username,
                    user.photoUrl,
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            // POST FORM
            body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    isLoading
                    ? const LinearProgressIndicator() :
                    ListTile(
                      leading: const Icon(Icons.assignment_add),
                      title: const Text('Diagnose (Not For Medical Purpose)'),
                      subtitle: Text(_promptAnalized.diagnoseDescription),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                   isLoading
                    ? const LinearProgressIndicator() :
                    ListTile(
                      leading: const Icon(Icons.add_alarm),
                      title: const Text('Take Action (Not For Medical Purpose)'),
                      subtitle: Text(_promptAnalized.takeActionDescription),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(width: 12),
                        TextButton(
                          child: const Text('Set Reminder'),
                          onPressed: () {/* ... */
                          postRequiredActionImage( user.uid, user.username, _promptAnalized.takeActionDescription);
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
  }
}
