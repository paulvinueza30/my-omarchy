spin() {
  local G="\e[32m" # Green
  local B="\e[34m" # Blue
  local Y="\e[33m" # Tan
  local R="\e[31m" # Red
  local W="\e[0m"  # Reset
  local teemo=$(
    cat <<EOF
$R⠀⠀⠄⣑⠒⡠$G⣀⣀⠀⣠⣀⠀⠀⠀⠀⠀⠀⠀⠀
   ⠀⣙⣴⣿⣿⣿⠟⠿⣿⣿⣳⣠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢠⢹⠏⣿⣽⣯⡄⣴⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⡄
⠀⠀⠀⢸⣦⣼⡿⣽⣾⣿⡿⣫⡾⠍⣀⠀  ⠀⠀⠀⠀⠀⠀⡀⢐⠀⠔⠃
 ⠀⠀⠸⣯⡿⣽⣿⡽⣾⠉⠀⠀ ⢀⠀⠀⠀⠀⠀⠀⠠⠠⠑⠈⠀⠀⠀⠀
  ⠀⡈⣿⡿⢺⠈⠀⠀⠀⠀⣀⢢⣴⣚⠤⠰⠆⠃⠁⠀⠀⠀⠀⠀⠀⠀
  ⠀⢛⠛⠩⣸⢶⣶⣞⡿⣹⢗⡧⠾⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
$Y ⠀⠬⢤⣴⣿⡛⣟⢦⢉⠫⣌⣑⠭⢡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠈⣿⣏⡻⣝⣿⣬⡤⣛⡋⢄⣼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢿⣿⣿⡿⢋⣷⠉⠁⢛⣧⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀  ⠀⠀⠀⠈⠁⣀⣟⠛⠲⠤⠺⣈⡙⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
EOF
  )

  tput civis
  tput sc
  echo
  echo "Captain Teemo on Duty!"
  echo -e "$teemo"

  local eye=⠂
  local eye_col=12
  local eye_row_offset=6
  local pipe_col=30
  local pipe_row_offset=4
  local zigzags=("~" "-")

  while true; do
    for ((i = 0; i < 25; i++)); do
      tput rc
      tput cud $((eye_row_offset))
      tput cuf $((eye_col))
      if ((i % 8 > 1)); then
        printf "$B%s$W" "$eye"
      else
        printf " "
      fi

      tput rc
      tput cud $((pipe_row_offset + (i % 2)))
      tput cuf $((pipe_col + i))

      printf "\e[35m%s\e[0m" "${zigzags[$((i % 2))]}"

      sleep 0.3

      printf "\b "
    done
  done
}
on_kill() {
  cleanup
  echo -e "\e[31mCaptain Teemo off duty ;(\e[0m"
  sleep .8
  tput rc
  tput ed
}
on_exit() {
  cleanup
  echo "$output"
  exit $exit_code
}

cleanup() {
  [[ -n $spin_pid ]] && kill "$spin_pid" 2>/dev/null
  tput rc
  tput ed
}

trap on_exit EXIT
trap on_kill SIGINT

spin &
spin_pid=$!

output=$("$@" 2>&1)
exit_code=$?
