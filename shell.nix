with import <nixpkgs> {};
let
	packages = [
		hugo
		nodejs-16_x
	];


in mkShell {
	packages = packages;
}
