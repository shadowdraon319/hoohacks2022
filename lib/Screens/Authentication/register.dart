import 'package:careing/presence.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Background(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'REGISTER',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2661FA),
                fontSize: 36,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Text(
              'Forgot your password?',
              style: TextStyle(fontSize: 12, color: Color(0xFF2661FA)),
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: RaisedButton(
              onPressed: () async {
                if (nameController.text.toString().isEmpty ||
                    emailController.text.toString().isEmpty ||
                    passwordController.text.toString().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please Input All Fields')));
                } else {
                  if (passwordController.text.length >= 6 &&
                      passwordController.text.length >= 6) {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.toString());

                      return users.doc(userCredential.user!.uid).set({
                        'Name':
                            nameController.text.trim().toString(), // John Doe
                        'Email': emailController.text.trim().toString(),
                        'Password': passwordController.text.trim().toString(),
                        'UID': userCredential.user!.uid.toString()
                        // Stokes and Sons
                      }).then((value) {
                        print("User Added");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()));
                      }).catchError(
                          (error) => print("Failed to add user: $error"));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Password Must Be At Least 6 Characters')));
                  }
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0),
              ),
              textColor: Colors.white,
              padding: const EdgeInsets.all(0),
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                width: size.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80.0),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 136, 34),
                      Color.fromARGB(255, 255, 177, 41),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(0),
                child: Text('SIGN UP',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  'Already Have an Account? Sign in',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA)),
                ),
              ))
        ]),
      ),
    );
  }
}
