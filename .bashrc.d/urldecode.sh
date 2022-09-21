# https://stackoverflow.com/questions/6250698/how-to-decode-url-encoded-string-in-shell/37840948#37840948
function urldecode() {
	: "${*//+/ }"
	echo -e "${_//%/\\x}"
}
export -f urldecode
