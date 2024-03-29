import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:giphy_challenge/data/bloc/gif_bloc.dart';
import 'package:giphy_challenge/model/gif.dart';
import 'package:giphy_challenge/utils/size_utils.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GifBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Giphy Challenge'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Gif> gifList = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (!isTop) {
          final GifInitialized state =
              context.read<GifBloc>().state as GifInitialized;
          context.read<GifBloc>().add(GifSearchPaginateEvent(
              query: _searchController.text,
              offset: state.paginationOffset + 10));
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: BlocBuilder<GifBloc, GifState>(
          builder: (context, state) {
            if (state is GifInitial) {
              context.read<GifBloc>().add(GetTrendingEvent());
              return const CircularProgressIndicator();
            } else if (state is GifInitialized) {
              return Column(children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _searchController,
                    decoration: const InputDecoration(hintText: "Search"),
                    onChanged: (_) {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        context
                            .read<GifBloc>()
                            .add(GifSearchEvent(query: _searchController.text));
                      });
                    },
                  ),
                ),
                if (state.gifs.isNotEmpty)
                  Expanded(
                    child: GridView.builder(
                      controller: _scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: state.gifs.length,
                      itemBuilder: (context, index) {
                        final gif = state.gifs[index];
                        return SizedBox(
                          height: getScreenWidth(context) * .4,
                          child: Image.network(
                            gif.image.url,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
              ]);
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

class GiphySearchDialog extends StatefulWidget {
  const GiphySearchDialog({super.key});

  @override
  State<GiphySearchDialog> createState() => _GiphySearchDialogState();
}

class _GiphySearchDialogState extends State<GiphySearchDialog> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(children: [
            Row(
              children: [
                IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    )),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
