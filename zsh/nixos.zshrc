nix-search()
{
    echo "Searching...";
    nix-env -qaP --description | grep -i "$1" | sed 's:\s\{2,\}: | :g';
}
