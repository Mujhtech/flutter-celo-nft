import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_celo_composer/infrastructures/service/cubit/web3_cubit.dart';
import 'package:flutter_celo_composer/module/auth/interfaces/screens/authentication_screen.dart';
import 'package:flutter_celo_composer/module/home/models/nft_model.dart';
import 'package:flutter_celo_composer/module/home/services/cubit/art_cubit.dart';
import 'package:flutter_celo_composer/module/home/widgets/nft_card.dart';
import 'package:jazzicon/jazzicon.dart';
import 'package:jazzicon/jazziconshape.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

enum TabSection { art, nft }

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.session,
    required this.connector,
    required this.uri,
    Key? key,
  }) : super(key: key);

  final dynamic session;
  final WalletConnect connector;
  final String uri;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String accountAddress = '';
  String networkName = '';
  TextEditingController greetingTextController = TextEditingController();
  JazziconData? jazz;
  int totalNftCounter = 0;
  bool loadingNewArt = false;
  TabSection currentTab = TabSection.art;
  bool minting = false;
  String artUrl =
      'https://oaidalleapiprodscus.blob.core.windows.net/private/org-NgdYB80bWCLnUzlRzOhYiCUw/user-lToV6MMtIH7Nt2nIXJIVHgDA/img-7Yc45JxPIFofnfuHfKNwkOp1.png?st=2023-05-17T10%3A50%3A34Z&se=2023-05-17T12%3A50%3A34Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-05-16T19%3A11%3A25Z&ske=2023-05-17T19%3A11%3A25Z&sks=b&skv=2021-08-06&sig=T8gIbfAxE/mGe6YIFfSrs/sfh6qwict3QrojXxE9q4o%3D';

  ButtonStyle buttonStyle = ButtonStyle(
    elevation: MaterialStateProperty.all(0),
    backgroundColor: MaterialStateProperty.all(
      Colors.white.withAlpha(60),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    ),
  );

  void updateGreeting() {
    launchUrlString(widget.uri, mode: LaunchMode.externalApplication);

    //context.read<Web3Cubit>().updateGreeting(greetingTextController.text);
    greetingTextController.text = '';
  }

  @override
  void initState() {
    super.initState();

    /// Execute after frame is rendered to get the emit state of InitializeProviderSuccess
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountAddress = widget.connector.session.accounts[0];
      jazz = Jazzicon.getJazziconData(40,
          address: widget.connector.session.accounts[0]);

      setState(() {});

      context.read<Web3Cubit>().initializeProvider(
            connector: widget.connector,
            session: widget.session,
          );
    });
  }

  void showToast(BuildContext context, String message,
      [Color color = Colors.black, Color textColor = Colors.white]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            message,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: textColor, fontSize: 14),
          ),
          backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return BlocListener<Web3Cubit, Web3State>(
      listener: (BuildContext context, Web3State state) {
        if (state is SessionTerminated) {
          Future<void>.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const AuthenticationScreen(),
              ),
            );
          });
        } else if (state is MintFailed) {
          setState(() {
            minting = false;
          });
          showToast(context, state.message, Colors.red, Colors.black);
        } else if (state is MintLoading) {
          setState(() {
            minting = true;
          });
        } else if (state is MintSuccess) {
          setState(() {
            minting = false;
          });
          showToast(
            context,
            'Minted successfully',
          );
          // Generate new art to mint
          // context.read<ArtCubit>().fetchNewArt();
        } else if (state is FetchTokenCountFailed) {
          showToast(context, state.message, Colors.red, Colors.black);
        } else if (state is InitializeProviderSuccess) {
          setState(() {
            accountAddress = state.accountAddress;
            networkName = state.networkName;
          });
        } else if (state is FetchTokenCountSuccess) {
          setState(() {
            totalNftCounter = state.counter;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Image.asset(
            'assets/images/logo.png',
            width: 50,
            height: 50,
          ),
          centerTitle: true,
          // ignore: use_decorated_box
          backgroundColor: const Color(0xFFFCFF52),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  if (accountAddress.isNotEmpty)
                    Text(
                      'Address: ${accountAddress.substring(0, 8)}...${accountAddress.substring(accountAddress.length - 8, accountAddress.length)}',
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: width * 0.4,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            currentTab = TabSection.art;
                          });
                        },
                        icon: const SizedBox.shrink(),
                        label: Text(
                          'New art',
                          style: theme.textTheme.titleMedium!
                              .copyWith(color: Colors.black),
                        ),
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(
                            Colors.grey.shade400,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.4,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            currentTab = TabSection.nft;
                          });
                        },
                        icon: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey.shade400,
                          child: Text(
                            '$totalNftCounter',
                            style: theme.textTheme.titleMedium!
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        label: Text(
                          'My NFT',
                          style: theme.textTheme.titleMedium!
                              .copyWith(color: Colors.black),
                        ),
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(
                            Colors.grey.shade400,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (currentTab == TabSection.art)
                BlocListener<ArtCubit, ArtState>(
                  listener: (BuildContext context, ArtState state) {
                    if (state is FetchArtLoading) {
                      loadingNewArt = true;
                      setState(() {});
                    } else if (state is FetchArtFailed) {
                      loadingNewArt = false;
                      setState(() {});

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (state is FetchArtSuccess) {
                      loadingNewArt = false;
                      artUrl = state.url;
                      setState(() {});
                    }
                  },
                  child: Expanded(
                      child: Column(
                    children: <Widget>[
                      if (loadingNewArt)
                        const CircularProgressIndicator(
                          value: 30,
                          color: Color(0xFFFCFF52),
                        ),
                      if (artUrl.isNotEmpty && !loadingNewArt)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: height * 0.5,
                              width: width * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                    artUrl,
                                  ))),
                            ),
                            Center(
                              child: SizedBox(
                                width: width * 0.4,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (minting) {
                                      return;
                                    }

                                    context.read<Web3Cubit>().mint(artUrl);

                                    showToast(
                                        context, 'Minting, please wait...');
                                  },
                                  icon: const SizedBox.shrink(),
                                  label: Text(
                                    'Mint',
                                    style: theme.textTheme.titleMedium!
                                        .copyWith(color: Colors.black),
                                  ),
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.grey.shade400,
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      Center(
                        child: SizedBox(
                          width: width * 0.4,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (minting) {
                                return;
                              }
                              context.read<ArtCubit>().fetchNewArt();
                            },
                            icon: const SizedBox.shrink(),
                            label: Text(
                              'Generate new art',
                              style: theme.textTheme.titleMedium!
                                  .copyWith(color: Colors.black),
                            ),
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all(
                                Colors.grey.shade400,
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                )
              else if (currentTab == TabSection.nft)
                Expanded(
                  child: totalNftCounter > 0
                      ? FutureBuilder<List<NftModel>>(
                          future: context
                              .read<Web3Cubit>()
                              .fetchAllNft(totalNftCounter),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<NftModel>> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1 / 1.08,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                shrinkWrap: true,
                                itemBuilder: (_, int index) {
                                  return NftCard(
                                    nft: snapshot.data![index],
                                    key: Key(index.toString()),
                                  );
                                },
                                itemCount: snapshot.data!.length,
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                snapshot.error.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                        color: Colors.black, fontSize: 14),
                              );
                            }

                            return const Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  value: 30,
                                  color: Color(0xFFFCFF52),
                                ),
                              ),
                            );
                          },
                        )
                      : Text(
                          'Nothing in your collection',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.black, fontSize: 14),
                        ),
                ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: SizedBox(
                  width: width,
                  child: ElevatedButton.icon(
                    onPressed: context.read<Web3Cubit>().closeConnection,
                    icon: const Icon(
                      Icons.power_settings_new,
                    ),
                    label: Text(
                      'Disconnect',
                      style: theme.textTheme.titleMedium!
                          .copyWith(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey.shade400,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
