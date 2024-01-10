export BASHRC_STARTUP_PWD=$(pwd)

PATH_CONFIG_BASHRC="${HOME}/.config/bashrc"

if [ ! -d $PATH_CONFIG_BASHRC ]; then
  echo "create : $PATH_CONFIG_BASHRC"
  mkdir -p $PATH_CONFIG_BASHRC
fi

cd ${PATH_CONFIG_BASHRC}

for bashrc_path_name in $(ls ${PATH_CONFIG_BASHRC}/bashrc*); do
  echo "[bashrc] : ${bashrc_path_name}"
  source ${bashrc_path_name}
done

cd ${BASHRC_STARTUP_PWD}
export BASHRC_STARTUP_PWD=
