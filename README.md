# sa_menu

This is a Flutter project. sa_menu is my personal favorite way of working with a platform. I have similar setup on Python and Scala.

This project is structured in a multi-level menu-driven manner eventually display a tailor-made GUI to test an aspect of functionality on mobile phone platforms. The component file design targets minimization of file editing during test GUI editing. Noted that Flutter doesn't require the project name (sa_menu) to be the same as the gitbub repo name (rayk_test.)

Component dart files:

main.dat - top level menu
menu_base.dart - contains shard code/ functions for various menu-construction related widgets.
menu_utils.dart - contains utility functions and classes to be usable to all.
item_*_menu.dat - mid-level menu screen
item_*(_demo).dart - various testing GUI screens. Most them end with _demo. But, some won't. No special meaning.
