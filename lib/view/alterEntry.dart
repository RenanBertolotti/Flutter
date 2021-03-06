import 'package:flutter/material.dart';
import 'package:password_manager/Firebase/dbController.dart';
import 'package:password_manager/utils/ColorConverter.dart';
import 'package:password_manager/utils/appSize.dart';
import 'package:password_manager/utils/cryptoRandomString.dart';

class AlterEntry extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AlterEntryState();
}

class AlterEntryState extends State<AlterEntry>{

  final formKey = GlobalKey<FormState>();

  String _title;
  String _account;
  String _username;
  String _password;  

  Map<String, dynamic> profileDatas;
  Map<String, dynamic> datasToUpdate;

  TextEditingController _passwordController = new TextEditingController();

  bool hidePassword = true;

  Icon visibleOnOff = Icon(Icons.visibility, color: Colors.white);

  void _validateAndSave() async{
    final form = formKey.currentState;
    if (form.validate()){
      form.save(); 

      datasToUpdate = {
        "id": profileDatas["id"],
        "title": _title,
        "account": _account,
        "username": _username,
        "password": _password
      };

      await AuthProvider().updateCryptoEntry(datasToUpdate).then((bool isUpdated){
        if(isUpdated){
          _alertEntryCreated(); 
        }
      });      
    }
  }

  void _alertEntryCreated(){
    Future.delayed(Duration(seconds: 1), (){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Icon(
              Icons.check_circle,
              color: ColorConverter().firstButtonGradient(),
              size: SizeConfig.blockSizeVertical * 6.0,
            ),
            content: Text(
              'Entry updated',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.blockSizeVertical * 2.0
              ),
            ),
            backgroundColor: ColorConverter().backgroundColor(),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: ColorConverter().firstButtonGradient(),
                    fontSize: SizeConfig.blockSizeVertical * 2.0
                  ),
                ),
              )
            ],
          );
        }
      );
    });
  }

  @override
  Widget build(BuildContext context) {    
    profileDatas = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    _passwordController.text = profileDatas["password"];

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildCreateEntryLayout(),
    );
  }

  
  Widget _buildAppBar(){
    return AppBar(
      title: Text(
        'Update Entry',
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildCreateEntryLayout(){
    return LayoutBuilder(
      builder: (context, constraint){
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 5, 0, SizeConfig.blockSizeHorizontal * 5, 0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildFormField('Title', 'Title can\'t be empty', profileDatas["title"]),
                    _buildFormField('Account', 'Account can\'t be empty', profileDatas["account"]),
                    _buildFormField('Username', 'Username can\'t be empty', profileDatas["username"]),
                    _buildPasswordField('Password', 'Password can\'t be empty'),
                    _buildCreateEntryButton(),
                    _buildDeleteEntryButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );  
  }

  Widget _buildFormField(String label, String error, String initialData){
    return Container(
      margin: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical * 3.5, 0, 0),
      child: TextFormField(
        initialValue: initialData,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.blockSizeVertical * 2.0
          ),        
        ),
        validator: (value) => value.isEmpty ? error : null,
        onSaved: (value){
          if (label == 'Title'){
            _title = value;
          }
          else if (label == 'Account'){
            _account = value;
          }
          else if (label == 'Username'){
            _username = value;
          }
          else if (label == 'Password'){
            _password = value;
          }
        },
      ),
    );
  }

  Widget _buildPasswordField(String label, String error){
    return Container(
      margin: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical * 3.5, 0, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              obscureText: hidePassword,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.blockSizeVertical * 2.0
                ),
              ),
              validator: (value) => value.isEmpty ? error : null,
              onSaved: (value){
                  _password = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 4.0, 0, 0, 0),
            child: GestureDetector(
              onTap: (){                
                String encondedPassword = CryptoRandomString().createCryptoRandomString();                     
                setState(() {
                  profileDatas["password"] = encondedPassword;
                });                                  
              },
              child: Icon(
                Icons.replay, 
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 6.0, 0, 0, 0),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  if(hidePassword == false){
                    hidePassword = true;
                    visibleOnOff = Icon(Icons.visibility, color: Colors.white);
                  } else {
                    hidePassword = false;
                    visibleOnOff = Icon(Icons.visibility_off, color: Colors.white);
                  }                
                });
              },
              child: visibleOnOff
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCreateEntryButton(){
    return Container(
      height: SizeConfig.blockSizeVertical * 5.5,
      margin: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical * 8.0, 0, 0),
      child: RaisedButton(
        onPressed: (){
          _validateAndSave();
        },
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 6.0)),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                ColorConverter().firstButtonGradient(),
                ColorConverter().secondButtonGradient()
              ],              
            ),
            borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 6.0)
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'Update Entry',
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.blockSizeVertical * 2.0
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteEntryButton(){
    return Container(
      height: SizeConfig.blockSizeVertical * 5.5,
      margin: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical * 4.0, 0, 0),
      child: RaisedButton(
        onPressed: (){
          _confirmEntryDelete();
        },
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 6.0)),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 6.0)
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'Delete Entry',
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.blockSizeVertical * 2.0
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _deleteEntry() async{
    await AuthProvider().deleteCryptoEntry(profileDatas["id"]).then((bool isDeleted){
      if(isDeleted){
        _alertEntryDeleted();        
      }
    });
  }

  void _confirmEntryDelete(){
    Future.delayed(Duration(seconds: 1), (){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2)),
            content: Text(
              'Are you sure you want to delete this entry?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.blockSizeVertical * 2.0
              ),
            ),
            backgroundColor: ColorConverter().backgroundColor(),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);                  
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: ColorConverter().firstButtonGradient(),
                    fontSize: SizeConfig.blockSizeVertical * 2.0
                  ),
                ),
              ),
              FlatButton(
                onPressed: (){   
                  Navigator.pop(context);               
                  _deleteEntry();                  
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: ColorConverter().firstButtonGradient(),
                    fontSize: SizeConfig.blockSizeVertical * 2.0
                  ),
                ),
              ),
            ],
          );
        }
      );
    });
  }

  void _alertEntryDeleted(){
    Future.delayed(Duration(seconds: 0), (){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Icon(
              Icons.check_circle,
              color: ColorConverter().firstButtonGradient(),
              size: SizeConfig.blockSizeVertical * 6.0,
            ),
            content: Text(
              'Entry deleted',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.blockSizeVertical * 2.0
              ),
            ),
            backgroundColor: ColorConverter().backgroundColor(),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: ColorConverter().firstButtonGradient(),
                    fontSize: SizeConfig.blockSizeVertical * 2.0
                  ),
                ),
              )
            ],
          );
        }
      );
    });
  }
}