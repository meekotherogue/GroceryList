Martina Nagy
mln433
11052407

CMPT 298
Class Project
Chad Jones

Grocery List

This application is intended to act as a Grocery list for the user.  The
main motivation was to give users the ability to add their list to this
application, and check off the items as they pick them up.  In order to
expand the scope of this project, there are many other features as well.
For one, each list that is entered is saved, and the user can access
these lists from the "My Lists" option on the home screen.  In addition,
there is also a Recipe keeper for the user to use.  These recipes
visually look the same as the lists, but functionally are a little bit
different, for reasons I'll explain below.  Finally, the user can check
into Foursquare for the grocery store (or other store, for that matter)
and the location the user chose is then saved with each item in the
Current list.  In this fashion, the user will always know where they got
their items from.

On the home screen there are multiple options.  I'll explain each in
detail now.

Current List:
This option will open the list that is currently set to be the user's
"current" list.  From here, they simply have to tap the item on the
list, and it will mark it as checked.  This checked state is only stored
for as long as the list is in the Current list area.  Basically it is
just for visual reference for the user.  In addition, in the subtitle in
each table cell the location the item has been checked in at will be
displayed, if it exists. 

The current list can be initialized in many ways.  The first - and main
- one is when the user creates a new list (explained below).  As soon as
a new list is created, this new list will become the Current list
automatically.  The next way a list is created is by adding a previously
created list or recipe to the Current list when there is no current list
at the time and add it to the My Lists area..  If there is indeed a Current 
list, then the items from the added list or recipe are simply added to this 
Current list.  Finally, individual items can be added to a current list (by 
tapping them in any of the views that display them) and like with lists and 
recipes, if there is no Current list at the time it will create a new list. 

Create List:
This is the view where the user creates a new list, and is pretty
straightforward.  You simply type in a name and an optional quantity and
click the add button.  The item will be displayed in a table below the
input area.  Then, if the user decides they don't want a certain item,
they can do the left-swipe on the table cell to bring up the delete
button and delete it from the list.  As mentioned above, creating a list
will set it to the Current list.

My Lists:
This will display all lists ever created.  Not to much else here, but
clicking on a list name will then open up a view with that lists items.
From this view, you can do multiple things.

If you click the plus sign in the top right corner, this will add the
whole list to the Current list in the manner described above.  Tapping
any individual item will place a checkmark in the cell.  This indicates
that the item is now queued to be put into the Current list.  Tapping
the cell again will uncheck it and not put it in the Current list.  You
are able to navigate back and forth from any of the lists in the My
Lists view and add items to the Current list this way.

In addition, swiping to the right on an item with a location set will
bring up a new view containing a map view.  It will place a pin on where
this item's location is set, so that the user can find where to get it.

It should be noted that in any view that lists individual items, this
tapping and right-swiping behaviour is applicable (this includes Current
List, any List view, and in the Items view that displays every item).

Recipes:
This will bring up a list of all the recipes.  This view acts pretty
much identical to the List view described above.  However, there is a
plus sign in the top right of the Recipes list view.  This is where you
can create a new recipe.

This create recipe view acts identical to the Create Lists view.

The major difference with recipes and lists is that they are an entity
in itself.  They can be added to lists, but lists cannot be added to
them.  Locations can then be set on the list, but the location will not
affect the recipe.

All Items:
This view simply lists every item entered into the system.  It also will
display the last location the item was checked in at.  However, if the
item is used in multiple lists, the location set in that particular list
will remain intact.  As explained above, tapping these items will add
them to the Current list, and swiping right on them will open a map view
of its location (where applicable).

Checkin with Foursquare:
This is where the user can check in at a location.  This location will
be applied to the Current list, and saved with that list.

If there happens to be a bug that causes corrupt data, the database
should be located in the directory returned by
NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
NSUserDomainMask, YES);

and is given the name grocery.db

For example:
/Users/<USERNAME>/Library/Application
Support/iPhone
Simulator/6.0/Applications/49514F18-D6EC-40AF-BB00-CB859B8E8236/Documents/grocery.db

In the event of bad data, deleting the database will allow you to start
fresh.
