Description: A simple demo utility to compare files / directories between A and B and output files not present in B to C
Usage deltacopy.sh --source|-s <source-path> --dest|-d <destination-path> --output|-o <output-path>

You can effectivley achieve the same result using rysnc:

rsync -aHxv --progress --dry-run --compare-dest=folderA/ folderB/ folderC/
