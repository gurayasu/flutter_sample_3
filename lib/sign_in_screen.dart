import 'package:flutter/material.dart';
import 'package:photoapp/photo_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          // Columnを使い縦に並べる
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // タイトル
              Text(
                'Photo App',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 16),
              // 入力フォーム（メールアドレス）
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) {
                  if (value?.isEmpty == true) {
                    return 'メールアドレスを入力して下さい';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              // 入力フォーム（パスワード）
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'パスワード'),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                validator: (String? value) {
                  if (value?.isEmpty == true) {
                    return 'パスワードを入力して下さい';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                // ボタン（ログイン）
                child: ElevatedButton(
                  onPressed: () => {_onSignIn()},
                  child: const Text('ログイン'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                // ボタン（新規登録）
                child: ElevatedButton(
                  onPressed: () => {_onSignUp()},
                  child: const Text('新規登録'),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> _onSignIn() async {
    try {
      if (_formKey.currentState?.validate() != true) {
        return;
      }

      // 新規登録と同じく入力された内容をもとにログイン処理を行う
      final String email = _emailController.text;
      final String password = _passwordController.text;
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => PhotoListScreen()));
    } catch (e) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('エラー'),
              content: Text(e.toString()),
            );
          });
    }
  }

  Future<void> _onSignUp() async {
    try {
      if (_formKey.currentState?.validate() != true) {
        return;
      }

      final String email = _emailController.text;
      final String password = _passwordController.text;

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => PhotoListScreen()));
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text(e.toString()),
          );
        },
      );
    }
  }
}
