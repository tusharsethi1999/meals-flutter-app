import 'package:flutter/material.dart';

import '../data/dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';
  final Function toggleFavourite;
  final Function isFavourite;

  MealDetailScreen(this.toggleFavourite, this.isFavourite);

  Widget buildSectionTitle(BuildContext ctx, String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        title,
        style: Theme.of(ctx).textTheme.headline6,
      ),
    );
  }

  Widget buildContainer(BuildContext context, List<String> iterator,
      double hght, double wdt, bool isHavingIndex) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).primaryColorDark,
          ),
          borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      height: hght,
      width: wdt,
      child: Center(
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            if (isHavingIndex) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      child: Text('# ${index + 1}'),
                    ),
                    title: Text(
                      iterator[index],
                    ),
                  ),
                  Divider(),
                ],
              );
            }
            return Card(
              color: Colors.yellow[100],
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Text(
                  iterator[index],
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
          itemCount: iterator.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context).settings.arguments as String;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) {
      return meal.id == mealId;
    });
    final appBar = AppBar(
      title: Text(selectedMeal.title),
      /*actions: <Widget>[
        if (!isFavourite(selectedMeal.id))
          IconButton(
            icon: Icon(
              Icons.favorite,
            ),
            onPressed: () {
              toggleFavourite(selectedMeal.id);
            },
          ),
        if (isFavourite(selectedMeal.id))
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              toggleFavourite(selectedMeal.id);
            },
          )
      ],*/
    );
    final mediaQuery = MediaQuery.of(context);
    final pageSize = mediaQuery.size.height - appBar.preferredSize.height;
    final pageWidth = mediaQuery.size.width;
    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: pageSize * 0.4,
                child: Image.network(
                  selectedMeal.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              buildSectionTitle(context, 'Ingredients'),
              buildContainer(context, selectedMeal.ingredients, pageSize * 0.3,
                  pageWidth * 0.9, false),
              buildSectionTitle(context, 'Steps'),
              buildContainer(context, selectedMeal.steps, pageSize * 0.3,
                  pageWidth * 0.9, true),
            ],
          ),
        ),
        /*floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          elevation: 4,
          splashColor: Colors.indigo,
          child: Icon(
            Icons.delete,
          ),
          onPressed: () {
            Navigator.of(context).pop(mealId);
          },
        ),*/
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.favorite,
            color : isFavourite(mealId) ? Colors.red : Colors.white,
          ),
          onPressed: () {
            toggleFavourite(selectedMeal.id);
          },
        ),
      ),
    );
  }
}
