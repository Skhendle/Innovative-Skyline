import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:postgrad_tracker/Controller/Project_BoardController.dart';
import 'package:postgrad_tracker/Controller/UserController.dart';
import 'package:postgrad_tracker/Model/Project_Board.dart';
import 'package:postgrad_tracker/View/Board.dart';
import 'package:postgrad_tracker/View/Login.dart';
import 'package:postgrad_tracker/View/register/StudentSuperVisorRegister.dart';
import 'package:postgrad_tracker/View/register/SupervisorRegister.dart';
import 'package:postgrad_tracker/main.dart';



class MockClient extends Mock implements http.Client {}

Widget makeWidgetTestable(Widget widget){
  return MaterialApp(
    home: DefaultAssetBundle(bundle: rootBundle,child: widget),
  );
}

main(){
  group('Server connection', ()
  {


    http.Client client=new MockClient();

    Board testBoardPage = new Board();
    Project_Board tBoard =new Project_Board();
    testWidgets('Initialize', (WidgetTester tester) async {

      final client = new MockClient();
      personNo='1713445';
      var data = {
        'UserTypeID': 1.toString(),
        'StudentNo': personNo.toLowerCase(),
        'StaffNo': personNo.toLowerCase()
      };
      when(client.post('http://10.100.15.38/ReadBoards.php', body: data))
          .thenAnswer((_) async => http.Response(
          '[{"ProjectID":"55","Project_Title":"Default test board","Project_Description":"This board is a default board created for testing purposes. It should not be deleted.","Project_StartDate":null,"Project_EndDate":null,"BoardActive":"1","AccessLevelID":"4","AssignmentActive":"1"},{"ProjectID":"63","Project_Title":"Created by a sup","Project_Description":null,"Project_StartDate":null,"Project_EndDate":null,"BoardActive":"1","AccessLevelID":"1","AssignmentActive":"1"},{"ProjectID":"707","Project_Title":"a","Project_Description":"","Project_StartDate":null,"Project_EndDate":null,"BoardActive":"1","AccessLevelID":"4","AssignmentActive":"1"},{"ProjectID":"708","Project_Title":"b","Project_Description":"","Project_StartDate":null,"Project_EndDate":null,"BoardActive":"1","AccessLevelID":"4","AssignmentActive":"0"}]'
          ,200));
      Project_BoardController project_boardController=new Project_BoardController();
      List allBoards=await project_boardController.ReadBoards(1, personNo, client);
      if(allBoards!=null){
        if(allBoards[0]!=null){
          user.boards=allBoards[0];
          tBoard=user.boards.where((element) => element.ProjectID==55).first;
          testBoardPage.proj_board = tBoard;
        }
        if(allBoards[1]!=0){
          user.archivedBoards=allBoards[1];
        }
      }


      data = {
        'ProjectID': tBoard.ProjectID.toString(),
      };
      when(client.post('http://10.100.15.38/ReadLists.php', body: data))
          .thenAnswer((_) async => http.Response(
          '[{"ListID":"5","ProjectID":"55","List_Title":"Default List!"},{"ListID":"6","ProjectID":"55","List_Title":"Test 2"},{"ListID":"256","ProjectID":"55","List_Title":"tbd"},{"ListID":"266","ProjectID":"55","List_Title":"new"},{"ListID":"268","ProjectID":"55","List_Title":"new"},{"ListID":"270","ProjectID":"55","List_Title":"3"},{"ListID":"271","ProjectID":"55","List_Title":"4"},{"ListID":"272","ProjectID":"55","List_Title":"b"}]'
          ,200));

      data={
        'ListID' : 5.toString(),
      };

      when(client.post('http://10.100.15.38/ReadTasks.php', body: data))
          .thenAnswer((_) async => http.Response(
          '[{"TaskID":"3","ListID":"5","Task_Title":"First Task associated test.","Task_Description":"This is one of the first tasks.","Task_AddedBy":"","Task_StatusID":"4","Task_Date_added":"2020-05-25 14:05:52","Task_Date_Due":"2020-05-25 00:00:00"},{"TaskID":"4","ListID":"5","Task_Title":"Length test task.","Task_Description":"","Task_AddedBy":"","Task_StatusID":"1","Task_Date_added":"2020-06-05 13:27:20","Task_Date_Due":null},{"TaskID":"299","ListID":"5","Task_Title":"abc","Task_Description":null,"Task_AddedBy":"1713445","Task_StatusID":"1","Task_Date_added":"2020-06-10 13:01:02","Task_Date_Due":null},{"TaskID":"300","ListID":"5","Task_Title":"d","Task_Description":null,"Task_AddedBy":"1713445","Task_StatusID":"3","Task_Date_added":"2020-06-05 13:32:38","Task_Date_Due":null},{"TaskID":"304","ListID":"5","Task_Title":"e","Task_Description":null,"Task_AddedBy":"1713445","Task_StatusID":"1","Task_Date_added":"2020-06-05 00:00:00","Task_Date_Due":null},{"TaskID":"305","ListID":"5","Task_Title":"f","Task_Description":null,"Task_AddedBy":"1713445","Task_StatusID":"1","Task_Date_added":"2020-06-05 00:00:00","Task_Date_Due":null},{"TaskID":"306","ListID":"5","Task_Title":"g","Task_Description":null,"Task_AddedBy":"1713445","Task_StatusID":"1","Task_Date_added":"2020-06-05 00:00:00","Task_Date_Due":null},{"TaskID":"307","ListID":"5","Task_Title":"e","Task_Description":null,"Task_AddedBy":"1713445","Task_StatusID":"1","Task_Date_added":"2020-06-05 00:00:00","Task_Date_Due":null}]'
          ,200));
      boardClient = client;
      await tester.pump();

      when(client.post(
          'http://10.100.15.38/login.php',
          body: {
            'Email': '1713445@students.wits.ac.za'.toLowerCase(),
            'Password': 'Meghan'
          })).thenAnswer((_) async =>
          http.Response(
              '[{"UserID":"48","Email":"1713445@students.wits.ac.za","Password":"\$2y\$10\$gxaTrZTzD0L.LGCrBtKMZeaLcWKimeWN76KaSpMlthe6M9ARFFoYG","UserTypeId":"1"}]',
              200
          ));

      //2
      when(client.post('http://10.100.15.38/getTaskStatuses.php'))
          .thenAnswer((_) async =>
          http.Response(
              '[{"Task_StatusID":"1","Status":"Assigned"},{"Task_StatusID":"2","Status":"Acknowledged "},{"Task_StatusID":"3","Status":"Pending"},{"Task_StatusID":"4","Status":"Complete"}]'
              , 200
          ));
      //3
      when(client.post('http://10.100.15.38/getAssignmentTypes.php'))
          .thenAnswer((_) async =>
          http.Response(
              '[{"AssignmentTypeID":"1","AssignmentType":"Can edit and share."},{"AssignmentTypeID":"2","AssignmentType":"Can edit."},{"AssignmentTypeID":"3","AssignmentType":"Can view."},{"AssignmentTypeID":"4","AssignmentType":"Is Owner."}]'
              , 200
          ));

      //4
      when(client.post("http://10.100.15.38/getStudentTypes.php"))
          .thenAnswer((_) async =>
          http.Response(
              '[{"StudentTypeID":"1","Student_Type":"Full-time"},{"StudentTypeID":"2","Student_Type":"Part-time"}]'
              , 200
          ));

      //5
      when(client.post('http://10.100.15.38/getDegreeTypes.php')).thenAnswer((
          _) async =>
          http.Response(
              '[{"DegreeID":"1","Degree_Type":"Honors"},{"DegreeID":"2","Degree_Type":"Masters by dissertation"},{"DegreeID":"3","Degree_Type":"Masters by coursework"},{"DegreeID":"4","Degree_Type":"PhD"}]'
              , 200
          ));

      data = {
        "Email": '1713445@students.wits.ac.za',
      };

      //6
      when(client.post(
          'http://10.100.15.38/viewStudentProfile.php', body: data))
          .thenAnswer((_) async =>
          http.Response(
              '[{"StudentNo":"1713445","Student_FirstName":"Meghan","Student_LastName":"Sinclair-Black","Student_Email":"1713445@students.wits.ac.za","Degree_ID":"1","Student_RegistrationDate":"2021-01-01","StudentTypeID":"1"}]'
              , 200
          ));

      data = {
        'UserTypeID': 1.toString(),
        'StudentNo': personNo.toLowerCase(),
        'StaffNo': personNo.toLowerCase()
      };

      data = {"StudNo": personNo};

      //6
      when(client.post(
          "http://10.100.15.38/viewStudentStudNo.php", body: data))
          .thenAnswer((_) async =>
          http.Response(
              '[{"StudentNo":"1713445","Student_FirstName":"Meghan","Student_LastName":"Sinclair-Black","Student_Email":"1713445@students.wits.ac.za","Degree_ID":"1","Student_RegistrationDate":"2021-01-01","StudentTypeID":"1"}]'
              , 200
          ));

      data =
      {
        'Email': '1713445@students.wits.ac.za'.toLowerCase(),
        'Password': 'Meghan',
      };

      when(client.post(
          'http://10.100.15.38/ResetPassword.php', body: json.encode(data)))
          .thenAnswer((_) async =>
          http.Response(
              'Password updated successfully'
              , 200
          ));

      LoginPage loginPage=new LoginPage();
      await tester.pumpWidget(makeWidgetTestable(loginPage));
      LoginClient=client;

    final email=find.byKey(Key('emailField'));
    final password=find.byKey(Key('passwordField'));
    final toggleVisibilityButton=find.byKey(Key('toggle'));
    final forgotPasswordButton=find.byKey(Key('ForgotPasswordInput'));
    final loginButton=find.byKey(Key('loginButton'));
    final divider=find.byKey(Key('divider'));
    final registerButton=find.byKey(Key('registerButton'));

    expect(email,findsOneWidget);
    expect(password,findsOneWidget);
    expect(toggleVisibilityButton,findsOneWidget);
    expect(forgotPasswordButton,findsOneWidget);
    expect(loginButton,findsOneWidget);
    expect(divider,findsOneWidget);
    expect(registerButton,findsOneWidget);


      Finder formWidgetFinder = find.byType(Form);
      Form formWidget = tester.widget(formWidgetFinder) as Form;
      GlobalKey<FormState> formKey = formWidget.key as GlobalKey<FormState>;
      expect(formKey.currentState.validate(), isFalse);
      expect(loginPage.visible, isFalse);
      expect(loginPage.isHidden, isTrue);

    expect(find.text('Please enter an email address.'), findsNothing);
    expect(find.text('Password cannot be empty.'), findsNothing);
      expect(find.text('Username or password incorrect'), findsNothing);

      await tester.tap(toggleVisibilityButton);
      await tester.pump();
      expect(loginPage.isHidden, isFalse);

      await tester.tap(toggleVisibilityButton);
      await tester.pump();
      expect(loginPage.isHidden, isTrue);

    await tester.tap(loginButton);
    await tester.pump();

      expect(find.text('Please enter an email address.'), findsOneWidget);
      expect(find.text('Password cannot be empty.'), findsOneWidget);

      await tester.enterText(email, '1');
      await tester.enterText(password, '1');

      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Username or password incorrect'), findsOneWidget);

      await tester.enterText(email, '1713445@students.wits.ac.za');
      await tester.enterText(password, 'Meghan');

      await tester.tap(loginButton);
      expect(loginPage.visible, isTrue);
      await tester.pump();

      expect(find.text('Please enter an email address.'), findsNothing);
      expect(find.text('Password cannot be empty.'), findsNothing);
      expect(formKey.currentState.validate(), isTrue);
      expect(loginPage.visible, isFalse);

      await tester.tap(registerButton);
      await tester.pump();

//      await tester.pumpWidget(makeWidgetTestable(loginPage));

//      await tester.tap(forgotPasswordButton);
//      await tester.pump();


    });






  });

}
