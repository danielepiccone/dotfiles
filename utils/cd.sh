cd() {
  builtin cd "$@"

  # Check if a project is using a .nvmrc file
  if [ -f '.nvmrc' ]
  then
    EXPECTED=$(cat .nvmrc)
    CURRENT=$(nvm current)
    if ! [[ $CURRENT =~ $EXPECTED ]]

    then
      echo This project .nvmrc uses node $EXPECTED run 'nvm use' to update
    fi
  fi
}
