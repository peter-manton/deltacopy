#!/bin/bash

usage() {
if [ "$*" != "" ] ; then
   echo "Error: $*"
fi

echo "Description: A simply utility to compare files / directories between A and B and output files not present in B to C"
echo "Usage deltacopy.sh --source|-s <source-path> --dest|-d <destination-path> --output|-o <output-path>"
exit 1
}

SourceRoot=""
DestinationRoot=""
OutputDestination=""

while [ $# -gt 0 ] ; do
    case "$1" in
    -h|--help)
        usage
        ;;
    -s|--source)
        SourceRoot=$2
	shift
        ;;
    -d|--dest)
        DestinationRoot="$2"
	shift
        ;;
    -o|--output)
    	OutputDestination="$2"
    	shift
    	;;
    -*)
	usage "Unknown option '$1'"
        ;;
    *)
        usage "Too many arguments"
        ;;
    esac
    shift
done

if [[ $SourceRoot == "" ]] || [[ $DestinationRoot == "" ]] || [[ $OutputDestination == "" ]]
  then usage "Please ensure all arguments are specified!"
  exit 1
fi	  

SourceFiles=()
SourceRootEscaped=`echo $SourceRoot | sed 's;\/;\\\/;g'`
DestinationRootEscaped=`echo $DestinationRoot | sed 's;\/;\\\/;g'`
DestinationFiles=()
DuplicateFiles=()

for file in `find $SourceRoot | tail -n +2`
do temp=`echo $file | sed s/$SourceRootEscaped//g` 
SourceFiles+=($temp)
done

for file in `find $DestinationRoot | tail -n +2`
do temp=`echo $file | sed s/$DestinationRootEscaped//g`
DestinationFiles+=($temp)
done

# now add the destination files to list and compare!

for fl in "${DestinationFiles[@]}" 
do
  for fo in "${SourceFiles[@]}"
     do
       if [[ "$fl" == "$fo" ]]
         then DuplicateFiles+=($fl)
       fi		 
  done
done

# copy from source to output dir (excluding non-new/duplicate files)
NewFileCount=0

for src in "${SourceFiles[@]}"
do
  if ! [[ " ${DuplicateFiles[@]} " =~ " ${src} " ]]
    then 
       (( NewFileCount += 1 ))
       if [[ -d "$SourceRoot""$src" ]]
         #then	 echo "is folder: " $SourceRoot$src
	 then
	 echo "Creating directory: " "$OutputDestination""$src" 
	 mkdir -p "$OutputDestination$src"
       else
	 echo "Copying file: $SourceRoot$src to $OutputDestination$src"
	 cp $SourceRoot$src $OutputDestination$src
       fi
  fi
done

echo "Copied / found  $NewFileCount file(s)"
