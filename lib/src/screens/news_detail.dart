import 'dart:async';
import 'package:flutter/material.dart';
import '../blocs/comments_provider.dart';
import '../models/item_model.dart';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  NewsDetail({this.itemId});

  Widget build(context) {
    final bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
          if(!snapshot.hasData) {
            return Text('Loading');
          }

          final itemFuture = snapshot.data[itemId];

          return FutureBuilder(
            future: itemFuture,
            builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
              if(!itemSnapshot.hasData) {
                return Text('Item loading');
              }

              return buildList(itemSnapshot.data, snapshot.data);
            },
          );
        },
    );
  }

  buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final children = <Widget>[];
    children.add(buildTitle(item.title));
    final commentsList = item.kids.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: itemMap,
        depth: 1,
      );
    }).toList();
    children.addAll(commentsList);

    return ListView(
      children: children,
    );
  }

  buildTitle(String title) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.all(10.00),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

}
