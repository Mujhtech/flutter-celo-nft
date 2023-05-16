import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_celo_composer/module/auth/service/cubit/auth_cubit.dart';
import 'package:flutter_celo_composer/module/home/model/nft_model.dart';
import 'package:flutter_celo_composer/module/home/services/cubit/nft_cubit.dart';
import 'package:flutter_celo_composer/module/home/widgets/nft_card.dart';
import 'package:jazzicon/jazzicon.dart';
import 'package:jazzicon/jazziconshape.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

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

  ButtonStyle buttonStyle = ButtonStyle(
    elevation: MaterialStateProperty.all(0),
    backgroundColor: MaterialStateProperty.all(
      Colors.white.withAlpha(60),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    ),
  );

  @override
  void initState() {
    super.initState();

    /// Execute after frame is rendered to get the emit state of InitializeProviderSuccess
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountAddress = widget.connector.session.accounts[0];
      jazz = Jazzicon.getJazziconData(40,
          address: widget.connector.session.accounts[0]);

      setState(() {});

      context.read<NftCubit>().fetchNfts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    List<NftModel> nfts = [];

    return BlocListener<NftCubit, NftState>(
      listener: (BuildContext context, NftState state) {
        if (state is FetchNftSuccess) {
          nfts = state.nfts;
        } else if (state is FetchNftFailed) {
        } else if (state is FetchNftLoading) {}
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
        body: Column(
          children: <Widget>[
            Column(
              children: [
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
            Expanded(
              child: GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.08,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                shrinkWrap: true,
                itemBuilder: (_, int index) {
                  return NftCard(
                    key: Key(index.toString()),
                  );
                },
                itemCount: 20,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: SizedBox(
                width: width,
                child: ElevatedButton.icon(
                  onPressed: () {
                    //context.read<AuthCubit>().();
                  },
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
    );
  }
}
