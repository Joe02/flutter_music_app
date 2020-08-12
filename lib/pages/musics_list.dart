import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_music_app/models/music.dart';

class MusicsList extends StatefulWidget {
  @override
  MusicsListState createState() => MusicsListState();
}

class MusicsListState extends State<MusicsList> {
  List<Music> musicsList = [
    Music("Música 1", "Pejes", "", 243, false),
    Music("Música 2", "Pejes", "", 243, false),
    Music("Música 3", "Pejes", "", 243, false),
    Music("Música 4", "Pejes", "", 243, false),
    Music("Música 5", "Pejes", "", 243, false),
    Music("Música 6", "Pejes", "", 243, false),
    Music("Música 7", "Pejes", "", 243, false),
    Music("Música 8", "Pejes", "", 243, false),
    Music("Música 9", "Pejes", "", 243, false),
    Music("Música 10", "Pejes", "", 243, false),
  ];
  List<bool> selected = [];
  int selectedIndex = 0;

  bool darkMode = false;
  bool selectionMode = false;

  @override
  void initState() {
    super.initState();
    while (selectedIndex < musicsList.length) {
      selected.add(false);
      selectedIndex++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Colors.black87,
      body: buildMusicsList()
    );
  }

  buildAppBar() {
    return AppBar(
      centerTitle: true,
      actions: <Widget>[
        selectionMode
            ? Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                askForDeletion();
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.delete_outline),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  while (selectedIndex < musicsList.length) {
                    selected[selectedIndex] = false;
                  }
                  selectionMode = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.clear),
              ),
            ),
          ],
        )
            : Container(),
      ],
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: AnimatedCrossFade(
              crossFadeState: selectionMode == false
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 200),
              firstChild: Text(
                "Suas músicas",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              secondChild: Text(
                "Editar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )),
      ),
    );
  }

  buildMusicsList() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: List.generate(
              musicsList.length,
                  (index) =>
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        selectionMode = true;
                      });
                    },
                    child: Card(
                      color: Colors.black12,
                      child: Row(
                        children: <Widget>[
                          AnimatedCrossFade(
                            duration: Duration(milliseconds: 200),
                            crossFadeState: selectionMode
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: Container(),
                            secondChild: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected[index] = !selected[index];
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(
                                  selected[index]
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      musicsList[index].musicName,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      musicsList[index].musicAuthor,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Opacity(
                                      opacity:
                                      musicsList[index].isFavorite ? .9 : .3,
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          setState(() {
                                            musicsList[index].isFavorite =
                                            !musicsList[index].isFavorite;
                                          });
                                        },
                                        child: Icon(
                                          musicsList[index].isFavorite
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: musicsList[index].isFavorite
                                              ? Colors.yellowAccent
                                              : Colors.orange[400],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
          ),
        )
      ],
    );
  }

  askForDeletion() {
    selected.contains(true)
        ? buildAlertDialog()
        : buildSnackBar();
  }

  buildSnackBar() {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        "Nenhuma música selecionada.",
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 750),
      backgroundColor: Colors.black12,
    ),);
  }

  buildAlertDialog() {
    var index = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Deseja exlcuir as músicas selecionadas?"),
          actions: [
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Continuar"),
              onPressed: () {
                setState(() {
                  while (index < musicsList.length) {
                    if (selected[index] == true) {
                      musicsList.removeAt(index);
                      selected[index] = false;
                    }
                    index++;
                  }
                  Navigator.pop(context);
                });
              },
            )
          ],
        );
      },
    );
  }
}
