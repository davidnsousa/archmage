# Prompt the user to choose between Fish and Bash
read -p "Run Fish shell? [Y/n] " choice
case "$choice" in
  y|Y ) exec fish;;
  n|N ) ;;
  * ) exec fish;;
esac

#test