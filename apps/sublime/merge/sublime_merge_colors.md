### Change Sublime Merge colours:
* The look of the Sublime Merge interface is controlled by *themes*. The term theme refers strictly to the look of the UI – buttons, the commit list, location bar, command palette and so forth. 
* The highlighting of diffs is controlled by a combination of *color schemes* and syntax definitions.
* To change the color scheme:
    - There are three settings files that you need to amend and one file you need to create inside of your Sublime Merge User package, which you can find by using the Preferences > Browse Packages command; you’ll see User in there directly.
    - The file you need to create is [`MK.sublime-color-scheme`](MK.sublime-color-scheme) which holds the custom Monokai color scheme (henceforth referred to as **MK**).
    - The files you want to amend are (you are extending the default Merge Dark color scheme by doing this):
        - Commit Message - Merge Dark.sublime-settings
        - Diff - Merge Dark.sublime-settings
        - File Mode - Merge Dark.sublime-settings
    - Add the following to the above files:
      ```json
      {
        "color_scheme": "MK.sublime-color-scheme"
      }
      ```
      This *extends* the **Merge Dark** theme to use **MK** as the color scheme.
  * To change the theme, you need to extend the *Merge Dark* theme appropriately:
      - Create [`Merge Dark.sublime-theme`](Merge%20Dark.sublime-theme) is the folder containing `MK.sublime-color-scheme` and add the following to it:
      ```json
      {
          "extends": "Merge.sublime-theme",
          "variables":
          {
              "dark_gray-lightest": "rgb(23, 23, 20)", // commits
              "dark_gray-light": "rgb(35, 35, 33)", // locations
              "dark_gray-medium": "rgb(12, 12, 10)", // header
              "repository_tab_bar_bg": "rgb(35, 35, 33)", // tabs
          },
      }
      ```
      This appropriately changes the UI elements of Sublime Merge.
