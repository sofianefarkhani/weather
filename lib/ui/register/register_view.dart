import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:stacked/stacked.dart';
import 'package:weather/di/dependency_graph.dart';
import 'package:weather/ui/register/register_viewmodel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
        viewModelBuilder: () => locator<RegisterViewModel>(),
        builder: (context, viewModel, child) => Scaffold(
              backgroundColor: const Color(0xff030317),
              appBar: AppBar(
                title: const Text("Inscription"),
                backgroundColor: const Color(0xff00A1FF),
              ),
              body: Column(
                children: [
                  GlowContainer(
                    height: MediaQuery.of(context).size.height - 330,
                    margin: const EdgeInsets.all(2),
                    padding:
                        const EdgeInsets.only(top: 50, left: 30, right: 30),
                    glowColor: const Color(0xff00A1FF).withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                    color: const Color(0xff00A1FF),
                    spreadRadius: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 430,
                            child: Stack(
                              children: [
                                const Image(
                                  image: AssetImage("assets/sunny_2d.png"),
                                  fit: BoxFit.fill,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  left: 0,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: TextField(
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            cursorColor: Colors.white,
                                            controller:
                                                viewModel.emailController,
                                            onSubmitted: (value) {
                                              viewModel.verifyEmail(
                                                  context, value);
                                            },
                                            decoration: const InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              labelText: 'Email',
                                              labelStyle: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          child: TextField(
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            cursorColor: Colors.white,
                                            obscureText: true,
                                            controller:
                                                viewModel.passwordController,
                                            onSubmitted: (value) => viewModel
                                                .verifyPassword(context, value),
                                            decoration: const InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              labelText: 'Password',
                                              labelStyle: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          controller: viewModel.nameController,
                                          cursorColor: Colors.white,
                                          decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                            labelText: 'Nom',
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: GlowButton(
                      onPressed: () => viewModel.register(context),
                      width: 150,
                      child: const Text(
                        "S'inscrire",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
