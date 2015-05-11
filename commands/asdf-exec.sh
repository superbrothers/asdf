source $(dirname $(dirname $0))/lib/utils.sh

package=$1
executable_path=$2


#TODO support .asdf-versions file
full_version=$ASDF_PACKAGE_VERSION

source_path=$(get_source_path $package)
check_if_source_exists $source_path

IFS=':' read -a version_info <<< "$full_version"
if [ "${version_info[0]}" = "tag" ] || [ "${version_info[0]}" = "commit" ]
  then
  install_type="${version_info[0]}"
  version="${version_info[1]}"
else
  install_type="version"
  version="${version_info[0]}"
fi


install_path=$(get_install_path $package $install_type $version)


if [ -f ${source_path}/bin/exec-env ]
then
  exec_env=$(${source_path}/bin/exec-env $install_type $version $install_path)
  eval $exec_env ${install_path}/${executable_path} ${@:3}
else
  ${install_path}/${executable_path} ${@:3}
fi