import 'package:flutter/material.dart';
import 'package:password_manager/utils/ColorConverter.dart';

class ChangePassword extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword>{

   final formKey = GlobalKey<FormState>();

  String _newPassword;
  String _confirmedPassword;

  void _validateAndSave(){
    final form = formKey.currentState;
    if (form.validate()){
      form.save();
      _alertProfileCreated();      
    }
  }

  void _alertProfileCreated(){
    Future.delayed(Duration(seconds: 1), (){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Icon(
              Icons.check_circle,
              color: ColorConverter().firstButtonGradient(),
              size: 50,
            ),
            content: Text(
              'Password Updated',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white
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
                    color: ColorConverter().firstButtonGradient()
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
    return Scaffold(
      body: _buildChangePasswordLayout(),
      appBar: _buildAppBar(),
    );
  }
  
  Widget _buildChangePasswordLayout(){
    return Container(
      margin: EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildFormField('New Password', 'New Password can\'t be empty'),
            _buildFormField('Confirm Password', 'Confirm Password can\'t be empty'),
            _buildChangePasswordButton(),
          ],
        ),
      ),
    );      
  }

  Widget _buildFormField(String label, String error){
    return Container(
      margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white
          ),        
        ),
        validator: (value) => value.isEmpty ? error : null,
        onSaved: (value){
          if (label == 'New Password'){
            _newPassword = value;
          }
          else if (label == 'Confirm Password'){
            _confirmedPassword = value;
          }
        },
      ),
    );
  }

  Widget _buildChangePasswordButton(){
    return Container(
      height: 50,
      margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: RaisedButton(
        onPressed: (){
          _validateAndSave();      
        },
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
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
            borderRadius: BorderRadius.circular(32)
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'Change Password',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildAppBar(){
    return AppBar(
      title: Text(
        'Change Password',
      ),
      centerTitle: true,
    );
  }
}