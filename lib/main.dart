import 'package:flutter/material.dart';
import './data/dummy_data.dart';
import './models/meals.dart';
import './screens/filters_screen.dart';
import './screens/tab_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/category_meals_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten' : false,
    'lactose' : false,
    'vegetarian' : false,
    'vegan' : false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favouriteMeals = [];

  void _setFilters(Map<String,bool> filterData) {
    setState(() {
      _filters = filterData;
      _availableMeals = DUMMY_MEALS.where((meal) {
        if(_filters['gluten'] && !meal.isGlutenFree) {
          return false;
        }
        if(_filters['lactose'] && !meal.isLactoseFree) {
          return false;
        }
        if(_filters['vegetarian'] && !meal.isVegetarian) {
          return false;
        }
        if(_filters['vegan'] && !meal.isVegan) {
          return false;
        }
        return true;  
      }).toList();
    });
  }

  void _toggleFavourite(String mealId) {
    final existingIndex = _favouriteMeals.indexWhere((meal) {
      return mealId == meal.id;
    }); 
    if(existingIndex >= 0) {
      setState(() {
        _favouriteMeals.removeAt(existingIndex);
      });
    }
    else {
      setState(() {
        _favouriteMeals.add(DUMMY_MEALS.firstWhere((meal) {
          return meal.id == mealId;
        }));
      });
    }
  }

  bool _isFavourite(String id) {
    return _favouriteMeals.any((meal) {
      return meal.id == id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.indigoAccent,
        canvasColor: Color.fromRGBO(255, 244, 244, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
          bodyText1: TextStyle(color: Colors.black54,),
          bodyText2: TextStyle(color: Colors.black,),
          headline6: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
        ) 

      ),
      home: TabsScreen(_favouriteMeals),
      routes: {
        '/category-meals' : (ctx) => CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName : (ctx) => MealDetailScreen(_toggleFavourite, _isFavourite), // for adding named routes
        FiltersScreen.routeName : (ctx) => FiltersScreen(_setFilters, _filters),
      },
      /*onGenerateRoute: (settings) { }  for dynamically generated routes
      onUnknownRoute: (settings) { }  for dealing with situations where you have got an unknown route.
      in a way to prevent app crashing */
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => TabsScreen(_favouriteMeals));
      },
    );
  }
}
